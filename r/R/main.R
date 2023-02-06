#' @title Calculate equilibrium constant for carbon
#'
#' @description Calculate a specified stoichiometric equilibrium constant at given temperature, salinity and pressure.
#'
#' @author Dennis Mayk
#'
#' @param k K to be calculated
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU)
#' @param P Pressure (Bar) (optional)
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
#' @param method Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (defaults to "MyAMI").
#' @param Kcorrect TRUE = calculate corrections, FALSE = don't calculate corrections.
#' @return Specified K at the given conditions
#' @export
calc_K <- function(k, TC = 25, S = 35, Mg = 0.0528171, Ca = 0.0102821, P = NULL, method = "MyAMI", Kcorrect = TRUE) {
  # Check input values
  checkmate::assert(
    combine = "and",
    checkmate::check_choice(k, choices = names(K_fns)),
    checkmate::check_choice(method, choices = c("R_Polynomial", "MyAMI_Polynomial", "MyAMI")),
    checkmate::check_string(k),
    checkmate::check_logical(Kcorrect),
    checkmate::check_numeric(TC, lower = 0, upper = 40),
    checkmate::check_numeric(S, lower = 30, upper = 40),
    checkmate::check_numeric(Mg, lower = 0, upper = 0.06),
    checkmate::check_numeric(Ca, lower = 0, upper = 0.06)
  )

  # Check if miniconda is installed
  if (!mc_exists() & method != "R_Polynomial") {
    print("Kgen requires r-Miniconda which appears to not exist on your system.")
    install_confirm <- utils::askYesNo("Would you like to install it now?")
    if (install_confirm) {
      install_pymyami()
    } else {
      stop("Closing Kgen.")
    }
  }

  # Load K_calculation.json
  K_coefs <- rjson::fromJSON(file = system.file("coefficients/K_calculation.json", package = "Kgen"))
  K_coefs <- K_coefs$coefficients

  # Celsius to Kelvin
  TK <- TC + 273.15

  # Select function and run calculation
  K_fn <- K_fns[[k]]
  k_value <- K_fn(p = K_coefs[[k]], TK = TK, S = S)

  # Pressure correction?
  if (!is.null(P)) {
    k_value <- calc_pressure_correction(k = k, k_value = k_value, TC = TC, S = S, P = P)
  }

  # Calculate correction factor
  if (Kcorrect) {
    if (method == "MyAMI") {
      pymyami <- reticulate::import("pymyami")
      Fcorr <- pymyami$calc_Fcorr(Sal = S, TempC = TC, Mg = Mg, Ca = Ca)
      k_value <- k_value * as.numeric(Fcorr[[k]])
    }
    if (method == "MyAMI_Polynomial") {
      pymyami <- reticulate::import("pymyami")
      Fcorr <- pymyami$approximate_Fcorr(Sal = S, TempC = TC, Mg = Mg, Ca = Ca)
      k_value <- k_value * as.numeric(Fcorr[[k]])
    }
    if (method == "R_Polynomial") {
      # Load polynomial_coefficients.json
      poly_coefs <- rjson::fromJSON(file = system.file("coefficients/polynomial_coefficients.json", package = "Kgen"))

      if (k %in% names(poly_coefs)) {
        # Calculate correction factors
        KF <- sapply(seq_len(length(TK)), function(ii) {
          poly_coefs[[k]] %*% kgen_poly(S = S[ii], TK = TK[ii], Mg = Mg[ii], Ca = Ca[ii])
        })
        k_value <- k_value * KF
      }
    }
  }

  return(k_value)
}

#' @title Calculate multiple equilibrium constants for carbon
#'
#' @description Wrapper to calculate multiple stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @author Dennis Mayk
#'
#' @inheritParams calc_K
#' @param ks character vectors of Ks to be calculated e.g., c("K0", "K1")
#' @return Data.frame of specified Ks at the given conditions
#' @export
calc_Ks <- function(ks, TC = 25, S = 35, Mg = 0.0528171, Ca = 0.0102821, P = NULL, method = "MyAMI") {
  # Check if ks is supplied, use K_fns as default
  if (missing(ks)) {
    ks <- names(K_fns)
  }

  # Calculate ks
  ks_list <- lapply(ks, function(k) {
    calc_K(
      k = k, TC = TC,
      S = S, Mg = Mg,
      Ca = Ca, P = P,
      method = method,
      Kcorrect = FALSE
    )
  })

  # Return data.frame
  Ks <- data.frame(t(do.call(rbind, ks_list)))
  colnames(Ks) <- ks

  # Celsius to Kelvin
  TK <- TC + 273.15

  # Calculate correction factor with MyAMI
  if (method == "MyAMI") {
    pymyami <- reticulate::import("pymyami")
    Fcorr <- pymyami$calc_Fcorr(Sal = S, TempC = TC, Mg = Mg, Ca = Ca)
  }
  if (method == "MyAMI_Polynomial") {
    pymyami <- reticulate::import("pymyami")
    Fcorr <- pymyami$approximate_Fcorr(Sal = S, TempC = TC, Mg = Mg, Ca = Ca)
  }
  if (method == "R_Polynomial") {
    # Load polynomial_coefficients.json
    poly_coefs <- rjson::fromJSON(file = system.file("coefficients/polynomial_coefficients.json", package = "Kgen"))

    # Calculate correction factors
    Fcorr <- lapply(names(poly_coefs), function(k) {
      sapply(seq_len(length(TK)), function(ii) {
        poly_coefs[[k]] %*% kgen_poly(S = S[ii], TK = TK[ii], Mg = Mg[ii], Ca = Ca[ii])
      })
    })
  }

  # Apply correction
  for (k in unique(ks)) {
    KF <- Fcorr[[k]]
    if (!is.null(KF)) {
      Ks[k] <- Ks[k] * as.numeric(KF)
    }
  }

  return(Ks)
}
