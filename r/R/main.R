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
#' @return Specified K at the given conditions
calc_K <- function(k, TC = 25, S = 35, Mg = 0.0528171, Ca = 0.0102821, P = NULL, method = "MyAMI") {
  # Check input values
  checkmate::assert(
    combine = "and",
    checkmate::check_choice(k, choices = names(K_fns)),
    checkmate::check_choice(method, choices = c("R_Polynomial", "MyAMI_Polynomial", "MyAMI")),
    checkmate::check_string(k),
    checkmate::check_numeric(TC, lower = 0, upper = 40),
    checkmate::check_numeric(S, lower = 30, upper = 40),
    checkmate::check_numeric(Mg, lower = 0, upper = 0.06),
    checkmate::check_numeric(Ca, lower = 0, upper = 0.06)
  )

  KF <- k_value <- TK <- KF_deep <- KF_surf <- KS_deep <- KS_surf <- TF <- TS <- check_pc <- pc <- sws_to_tot_deep <- tot_to_sws_surface <- rid <- NULL
  dat <- data.table::data.table(k, TC, S, Mg, Ca, P)[, rid := .I]

  # Celsius to Kelvin
  dat[, TK := TC + 273.15]

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

  # Select function and run calculation
  K_fn <- K_fns[[k]]

  dat[, k_value := K_fn(p = K_coefs[[k]], TK = TK, S = S), by = rid]

  # Pressure correction?
  if (!is.null(P)) {
    # Load K_pressure_correction.json
    K_presscorr_coefs <- rjson::fromJSON(file = system.file("coefficients/K_pressure_correction.json", package = "Kgen"))
    K_presscorr_coefs <- K_presscorr_coefs$coefficients

    dat[, TS := calc_TS(S)]
    dat[, TF := calc_TF(S)]

    dat[, KS_surf := K_fns[["KS"]](p = K_coefs[["KS"]], TK = TK, S = S)]
    dat[, KS_deep := KS_surf * fn_pc(p = K_presscorr_coefs[["KS"]], P = P, TC = TC)]
    dat[, KF_surf := K_fns[["KF"]](p = K_coefs[["KF"]], TK = TK, S = S)]
    dat[, KF_deep := KF_surf * fn_pc(p = K_presscorr_coefs[["KF"]], P = P, TC = TC)]

    # convert from TOT to SWS before pressure correction
    dat[, tot_to_sws_surface := (1 + TS / KS_surf) / (1 + TS / KS_surf + TF / KF_surf)]

    # convert from SWS to TOT after pressure correction
    dat[, sws_to_tot_deep := (1 + TS / KS_deep + TF / KF_deep) / (1 + TS / KS_deep)]
    dat[, pc := calc_pressure_correction(k = k, TC = TC, P = P), by = rid]

    dat[, check_pc := ifelse(pc != 0, pc, 1)]
    dat[, k_value := k_value * tot_to_sws_surface * check_pc * sws_to_tot_deep]
  }

  # Calculate correction factor
  if (method == "MyAMI") {
    pymyami <- reticulate::import("pymyami")
    Fcorr <- pymyami$calc_Fcorr(Sal = dat$S, TempC = dat$TC, Mg = dat$Mg, Ca = dat$Ca)
    if (k %in% names(Fcorr)) {
      KF <- as.numeric(Fcorr[[k]])
      dat[, k_value := k_value * KF]
    }
  }
  if (method == "MyAMI_Polynomial") {
    pymyami <- reticulate::import("pymyami")
    Fcorr <- pymyami$approximate_Fcorr(Sal = dat$S, TempC = dat$TC, Mg = dat$Mg, Ca = dat$Ca)
    if (k %in% names(Fcorr)) {
      KF <- as.numeric(Fcorr[[k]])
      dat[, k_value := k_value * KF]
    }
  }
  if (method == "R_Polynomial") {
    poly_coefs <- rjson::fromJSON(file = system.file("coefficients/Fcorr_approx.json", package = "Kgen"))
    if (k %in% names(poly_coefs)) {
      # Calculate correction factors
      dat[, KF := poly_coefs[[k]] %*% kgen_poly(S = S, TK = TK, Mg = Mg, Ca = Ca), by = rid]
      dat[, k_value := k_value * KF]
    }
  }

  return(dat$k_value)
}

#' @title Calculate multiple equilibrium constants for carbon
#'
#' @description Wrapper to calculate multiple stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @author Dennis Mayk
#'
#' @inheritParams calc_K
#' @param ks character vectors of Ks to be calculated e.g., c("K0", "K1")
#' @return Data.table of specified Ks at the given conditions
#' @export
calc_Ks <- function(ks = NULL, TC = 25, S = 35, Mg = 0.0528171, Ca = 0.0102821, P = NULL, method = "MyAMI") {
  # Check if ks is supplied, use K_fns as default
  if (is.null(ks)) {
    ks <- names(K_fns)
  }

  # Calculate ks
  ks_list <- pbapply::pblapply(ks, function(k) {
    calc_K(
      k = k, TC = TC,
      S = S, Mg = Mg,
      Ca = Ca, P = P,
      method = method
    )
  })

  # Return data.table
  ks_value <- data.table::data.table(do.call(cbind, ks_list))
  names(ks_value) <- ks

  return(ks_value)
}
