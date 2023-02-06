
#' @title Calculate pressure correction factor
#'
#' @description Calculate pressure correction factors for a specified equilibrium constant
#'
#' @author Dennis Mayk
#'
#' @param k K to be calculated
#' @param k_value value for k (optional). The function will apply a correction to any supplied values. If NULL, the pressure correction factors will be returned.
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU)
#' @param P Pressure (Bar)
#' @export
calc_pressure_correction <- function(k, k_value = NULL, TC, S, P) {
  checkmate::assert(
    combine = "and",
    checkmate::check_choice(k, choices = names(K_fns)),
    checkmate::check_string(k),
    checkmate::check_numeric(TC, lower = 0, upper = 40),
    checkmate::check_numeric(S, lower = 30, upper = 40)
  )

  # Load K_calculation.json
  K_coefs <- rjson::fromJSON(file = system.file("coefficients/K_calculation.json", package = "Kgen"))
  K_coefs <- K_coefs$coefficients

  # Load K_pressure_correction.json
  K_presscorr_coefs <- rjson::fromJSON(file = system.file("coefficients/K_pressure_correction.json", package = "Kgen"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients

  # Celsius to Kelvin
  TK <- TC + 273.15

  TS <- calc_TS(S)
  TF <- calc_TF(S)

  KS_surf <- K_fns[["KS"]](p = K_coefs[["KS"]], TK = TK, S = S)
  KS_deep <- KS_surf * fn_pc(p = K_presscorr_coefs[["KS"]], P = P, TC = TC)
  KF_surf <- K_fns[["KF"]](p = K_coefs[["KF"]], TK = TK, S = S)
  KF_deep <- KF_surf * fn_pc(p = K_presscorr_coefs[["KF"]], P = P, TC = TC)

  # convert from TOT to SWS before pressure correction
  tot_to_sws_surface <- (1 + TS / KS_surf) / (1 + TS / KS_surf + TF / KF_surf)

  # convert from SWS to TOT after pressure correction
  sws_to_tot_deep <- (1 + TS / KS_deep + TF / KF_deep) / (1 + TS / KS_deep)

  out <- fn_pc(p = K_presscorr_coefs[[k]], P = P, TC = TC)

  if (!is.null(k_value)) {
    check_pc <- ifelse(out != 0, out, 1)
    out <- k_value * tot_to_sws_surface * check_pc * sws_to_tot_deep
  }

  return(out)
}

#' @title Kgen R polynomial function
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
