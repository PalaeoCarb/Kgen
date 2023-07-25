#' @title Calculate a single equilibrium constant
#'
#' @description Calculate a specified stoichiometric equilibrium constant at given temperature, salinity, pressure and the concentration of magnesium, calcium, sulphate, and fluorine.
#'
#' @author Dennis Mayk
#'
#' @param k K to be calculated
#' @param temp_c Temperature (Celsius)
#' @param p_bar Pressure (Bar) (optional)
#' @param sal Salinity
#' @param magnesium Magnesium concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average magnesium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param calcium Calcium concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average calcium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param sulphate Sulphate concentration in mol/kgsw. Calculated from salinity if not given.
#' @param fluorine Fluorine concentration in mol/kgsw. Calculated from salinity if not given.
#' @param method Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (defaults to "MyAMI").
#' @return Specified K at the given conditions
#' @export
calc_K <- function(k, temp_c = 25, sal = 35, p_bar = NULL, magnesium = 0.0528171, calcium = 0.0102821, sulphate = NULL, fluorine = NULL, method = "MyAMI") {
  # Check input values
  checkmate::assert(
    combine = "and",
    checkmate::check_choice(k, choices = names(K_fns)),
    checkmate::check_choice(tolower(method), choices = c("r_polynomial", "myami_polynomial", "myami")),
    checkmate::check_string(k),
    checkmate::check_numeric(temp_c, lower = 0, upper = 40),
    checkmate::check_numeric(sal, lower = 30, upper = 40),
    checkmate::check_numeric(magnesium, lower = 0, upper = 0.06),
    checkmate::check_numeric(calcium, lower = 0, upper = 0.06)
  )

  KF <- k_value <- temp_k <- KF_deep <- KF_surf <- KS_deep <- KS_surf <- check_pc <- pc <- sws_to_tot_deep <- tot_to_sws_surface <- row_id <- NULL
  dat <- data.table::data.table(temp_c, sal, p_bar, magnesium, calcium, sulphate, fluorine)

  # Celsius to Kelvin
  dat[, temp_k := temp_c + 273.15]

  # Check if miniconda is installed
  if (!mc_exists() & tolower(method) != "r_polynomial") {
    warning("Kgen requires r-Miniconda which appears to not exist on your system.")
    install_confirm <- utils::askYesNo("Would you like to install it now?")
    if (install_confirm) {
      install_pymyami()
    } else {
      stop("Closing Kgen.")
    }
  }

  # Load K_calculation.json
  K_coefs <- rjson::fromJSON(file = system.file("coefficients/K_calculation.json", package = "kgen"))
  K_coefs <- K_coefs$coefficients

  # Select function and run calculation
  K_fn <- K_fns[[k]]
  dat[, k_value := K_fn(p = K_coefs[[k]], temp_k = temp_k, sal = sal)]

  # Pressure correction?
  if (!is.null(p_bar)) {
    # Load K_pressure_correction.json
    K_presscorr_coefs <- rjson::fromJSON(file = system.file("coefficients/K_pressure_correction.json", package = "kgen"))
    K_presscorr_coefs <- K_presscorr_coefs$coefficients

    if (is.null(sulphate)) {
      dat[, sulphate := calc_sulphate(sal = sal)]
    } else {
      dat[is.na(sulphate), sulphate := calc_sulphate(sal = sal)]
    }

    if (is.null(fluorine)) {
      dat[, fluorine := calc_fluorine(sal = sal)]
    } else {
      dat[is.na(fluorine), fluorine := calc_fluorine(sal = sal)]
    }

    dat[, KS_surf := K_fns[["KS"]](p = K_coefs[["KS"]], temp_k = temp_k, sal = sal)]
    dat[, KS_deep := KS_surf * fn_pc(p = K_presscorr_coefs[["KS"]], p_bar = p_bar, temp_c = temp_c)]
    dat[, KF_surf := K_fns[["KF"]](p = K_coefs[["KF"]], temp_k = temp_k, sal = sal)]
    dat[, KF_deep := KF_surf * fn_pc(p = K_presscorr_coefs[["KF"]], p_bar = p_bar, temp_c = temp_c)]

    # convert from TOT to SWS before pressure correction
    dat[, tot_to_sws_surface := (1 + sulphate / KS_surf) / (1 + sulphate / KS_surf + fluorine / KF_surf)]

    # convert from SWS to TOT after pressure correction
    dat[, sws_to_tot_deep := (1 + sulphate / KS_deep + fluorine / KF_deep) / (1 + sulphate / KS_deep)]
    dat[, pc := calc_pressure_correction(k = k, temp_c = temp_c, p_bar = p_bar)]

    dat[, check_pc := ifelse(pc != 0, pc, 1)]
    dat[, k_value := k_value * tot_to_sws_surface * check_pc * sws_to_tot_deep]
  }

  # Calculate correction factor
  if (tolower(method) == "myami") {
    pymyami <- reticulate::import("pymyami")
    Fcorr <- pymyami$calculate_seawater_correction(Sal = dat$sal, TempC = dat$temp_c, Mg = dat$magnesium, Ca = dat$calcium)
    if (k %in% names(Fcorr)) {
      KF <- as.numeric(Fcorr[[k]])
      dat[, k_value := k_value * KF]
    }
  }
  if (tolower(method) == "myami_polynomial") {
    pymyami <- reticulate::import("pymyami")
    Fcorr <- pymyami$approximate_seawater_correction(Sal = dat$sal, TempC = dat$temp_c, Mg = dat$magnesium, Ca = dat$calcium)
    if (k %in% names(Fcorr)) {
      KF <- as.numeric(Fcorr[[k]])
      dat[, k_value := k_value * KF]
    }
  }
  if (tolower(method) == "r_polynomial") {
    poly_coefs <- rjson::fromJSON(file = system.file("coefficients/polynomial_coefficients.json", package = "kgen"))
    if (k %in% names(poly_coefs)) {
      # Calculate correction factors
      dat[, row_id := .I]
      dat[, KF := poly_coefs[[k]] %*% kgen_poly(sal = sal, temp_k = temp_k, magnesium = magnesium, calcium = calcium), by = row_id]
      dat[, k_value := k_value * KF]
    }
  }

  return(dat$k_value)
}

#' @title Calculate equilibrium constants for seawater
#'
#' @description Wrapper to calculate specified stoichiometric equilibrium constants at given temperature, salinity, pressure and the concentration of magnesium, calcium, sulphate, and fluorine.
#'
#' @author Dennis Mayk
#'
#' @inheritParams calc_K
#' @param ks character vectors of Ks to be calculated e.g., c("K0", "K1")
#' @return Data.table of specified Ks at the given conditions
#' @export
calc_Ks <- function(ks, temp_c = 25, sal = 35, p_bar = NULL, magnesium = 0.0528171, calcium = 0.0102821, sulphate = NULL, fluorine = NULL, method = "MyAMI") {
  # Check if ks is supplied, use K_fns as default
  if (is.null(ks)) {
    ks <- names(K_fns)
  }

  # Calculate ks
  ks_list <- pbapply::pblapply(ks, function(k) {
    calc_K(
      k = k,
      temp_c = temp_c,
      sal = sal,
      p_bar = p_bar,
      magnesium = magnesium,
      calcium = calcium,
      sulphate = sulphate,
      fluorine = fluorine,
      method = method
    )
  })

  # Return data.table
  ks_value <- data.table::data.table(do.call(cbind, ks_list))
  names(ks_value) <- ks

  return(ks_value)
}

#' @title Calculate equilibrium constants for seawater
#'
#' @description Wrapper to calculate all stoichiometric equilibrium constants at given temperature, salinity, pressure and the concentration of magnesium, calcium, sulphate, and fluorine.
#'
#' @author Ross Whiteford
#'
#' @param temp_c Temperature (Celsius)
#' @param p_bar Pressure (Bar) (optional)
#' @param sal Salinity
#' @param magnesium Magnesium concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average magnesium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param calcium Calcium concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average calcium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param sulphate Sulphate concentration in mol/kgsw. Calculated from salinity if not given.
#' @param fluorine Fluorine concentration in mol/kgsw. Calculated from salinity if not given.
#' @param method Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (defaults to "MyAMI").
#' @return Data.table of specified Ks at the given conditions
#' @export
calc_all_Ks <- function(temp_c = 25, sal = 35, p_bar = NULL, magnesium = 0.0528171, calcium = 0.0102821, sulphate = NULL, fluorine = NULL, method = "MyAMI") {
  k_names <- names(K_fns)
  ks <- calc_Ks(ks = k_names, temp_c = temp_c, sal = sal, p_bar = p_bar, magnesium = magnesium, calcium = calcium, sulphate = sulphate, fluorine = fluorine, method = method)
  
  return(ks)
}
