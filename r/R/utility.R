
#' @title Calculate pressure correction factor
#'
#' @description Calculate pressure correction factor for a specified equilibrium constant.
#'
#' @author Dennis Mayk
#'
#' @param k K to be calculated
#' @param TC Temperature (Celsius)
#' @param P Pressure (Bar)
#' @export
calc_pressure_correction <- function(k, TC, P) {
  checkmate::assert(
    combine = "and",
    checkmate::check_choice(k, choices = names(K_fns)),
    checkmate::check_string(k),
    checkmate::check_numeric(TC, lower = 0, upper = 40)
  )

  # Load K_pressure_correction.json
  K_presscorr_coefs <- rjson::fromJSON(file = system.file("coefficients/K_pressure_correction.json", package = "Kgen"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients

  out <- fn_pc(p = K_presscorr_coefs[[k]], P = P, TC = TC)

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
