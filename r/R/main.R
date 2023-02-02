#' Kgen R polynomial function
#'
#' @param TK Temperature (Kelvin)
#' @param S Salinity (PSU)
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
kgen_poly <- function(S, TK, Mg, Ca) {
  # Create descriptor vector
  dx <- t(c(TK, log(TK), S, Mg, Ca))

  # Build poly matrix
  dy <- cbind(intercept = 1, stats::poly(dx, 3, raw = TRUE))

  # Sort by index - according to python output
  index <- c(
    1, 2, 7, 22, 3, 8, 23, 12, 27, 37, 4, 9, 24, 13, 28, 38, 16, 31, 41, 47, 5, 10, 25, 14, 29,
    39, 17, 32, 42, 48, 19, 34, 44, 50, 53, 6, 11, 26, 15, 30, 40, 18, 33, 43, 49, 20, 35,
    45, 51, 54, 21, 36, 46, 52, 55, 56
  )

  out <- dy[order(index)]

  return(out)
}

#' Calculate a specified stochiometric equilibrium constant at given temperature, salinity and pressure.
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

  # Load K_pressure_correction.json
  K_presscorr_coefs <- rjson::fromJSON(file = system.file("coefficients/K_pressure_correction.json", package = "Kgen"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients

  # Celsius to Kelvin
  TK <- TC + 273.15

  # Select function and run calculation
  K_fn <- K_fns[[k]]
  K <- K_fn(p = K_coefs[[k]], TK = TK, S = S)

  # Pressure correction?
  if (!is.null(P)) {
    TS <- calc_TS(S)
    TF <- calc_TF(S)

    KS_surf <- K_fns[["KS"]](p = K_coefs[["KS"]], TK = TK, S = S)
    KS_deep <- KS_surf * fn_pc(p = K_presscorr_coefs[["KS"]], P = P, TC = TC)
    KF_surf <- K_fns[["KF"]](p = K_coefs[["KF"]], TK = TK, S = S)
    KF_deep <- KF_surf * fn_pc(p = K_presscorr_coefs[["KF"]], P = P, TC = TC)

    tot_to_sws_surface <- (1 + TS / KS_surf) / (1 + TS / KS_surf + TF / KF_surf) # convert from TOT to SWS before pressure correction
    sws_to_tot_deep <- (1 + TS / KS_deep + TF / KF_deep) / (1 + TS / KS_deep) # convert from SWS to TOT after pressure correction

    pc <- fn_pc(p = K_presscorr_coefs[[k]], P = P, TC = TC)
    check_pc <- ifelse(pc != 0, pc, 1)
    K <- K * tot_to_sws_surface * check_pc * sws_to_tot_deep
  }

  # Calculate correction factor
  if (Kcorrect) {
    if (method == "MyAMI") {
      pymyami <- reticulate::import("pymyami")
      Fcorr <- pymyami$calc_Fcorr(Sal = S, TempC = TC, Mg = Mg, Ca = Ca)
      K <- K * as.numeric(Fcorr[[k]])
    }
    if (method == "MyAMI_Polynomial") {
      pymyami <- reticulate::import("pymyami")
      Fcorr <- as.numeric(pymyami$approximate_Fcorr(Sal = S, TempC = TC, Mg = Mg, Ca = Ca))
      K <- K * as.numeric(Fcorr[[k]])
    }
    if (method == "R_Polynomial") {
      # Load polynomial_coefficients.json
      poly_coefs <- rjson::fromJSON(file = system.file("coefficients/polynomial_coefficients.json", package = "Kgen"))

      if (k %in% names(poly_coefs)) {
        # Calculate correction factors
        KF <- sapply(seq_len(length(TK)), function(ii) {
          poly_coefs[[k]] %*% kgen_poly(S = S[ii], TK = TK[ii], Mg = Mg[ii], Ca = Ca[ii])
        })
        K <- K * KF
      }
    }
  }

  return(K)
}

#' Wrapper to calculate multiple stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU)
#' @param P Pressure (Bar) (optional)
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param method Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (defaults to MyAMI).
#' @param ks character vectors of Ks to be calculated e.g., c("K0", "K1")
#' @return Dataframe of specified Ks at the given conditions
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
    KF <- as.numeric(Fcorr[[k]])
    if (!is.null(KF)) {
      Ks[k] <- Ks[k] * KF
    }
  }

  return(Ks)
}
