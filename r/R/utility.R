
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
kgen_poly <- function(S, TK, Mg = 0.0528171, Ca = 0.0102821) {
  # Create descriptor vector
  dx <- t(c(TK, log(TK), S, Mg, Ca))

  # Build poly matrix
  dy <- stats::poly(dx, degree = 3, raw = TRUE)

  # Sort by index - according to python output
  out <- c(1, dy[order(-attr(dy, "degree"), colnames(dy), decreasing = TRUE)])

  return(out)
}
