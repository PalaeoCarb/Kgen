#' @title Calculate pressure correction factor
#'
#' @description Calculate pressure correction factor for a specified equilibrium constant.
#'
#' @author Dennis Mayk
#'
#' @param k K to be calculated
#' @param temp_c Temperature (Celsius)
#' @param p_bar Pressure (Bar)
#' @return pressure correction factor
#' @export
calc_pressure_correction <- function(k, temp_c, p_bar) {
  checkmate::assert(
    combine = "and",
    checkmate::check_character(k),
    checkmate::check_numeric(temp_c, lower = 0, upper = 40)
  )

  # Load K_pressure_correction.json
  K_presscorr_coefs <- rjson::fromJSON(file = system.file("coefficients/K_pressure_correction.json", package = "kgen"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients

  out <- calc_pc(p = K_presscorr_coefs[[k]], p_bar = p_bar, temp_c = temp_c)

  return(out)
}

#' @title Kgen R polynomial function
#'
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity (PSU)
#' @param magnesium magnesium concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average magnesium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param calcium calcium concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average calcium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
kgen_poly <- function(sal, temp_k, magnesium = 0.0528171, calcium = 0.0102821) {
  # Create descriptor vector
  dx <- t(c(temp_k, log(temp_k), sal, magnesium, calcium))

  # Build poly matrix
  dy <- stats::poly(dx, degree = 3, raw = TRUE)

  # Sort by index - according to python output
  out <- c(1, dy[order(-attr(dy, "degree"), colnames(dy), decreasing = TRUE)])

  return(out)
}

#' @title Kgen seawater composition correction function
#'
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity (PSU)
#' @param magnesium magnesium concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average magnesium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param calcium calcium concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average calcium concentration in seawater - a salinity correction is then applied to calculate the magnesium concentration in the sample.
#' @param method string describing method which should be either 'myami', 'myami_polynomial', or 'r_polynomial'.
#' @return seawater correction factor
#' @export
calc_seawater_correction <- function(k, sal, temp_c, magnesium = 0.0528171, calcium = 0.0102821, method="myami") {
  # Calculate correction factor
  if (tolower(method) == "myami") {
    pymyami <- reticulate::import("pymyami")
    seawater_correction <- pymyami$calculate_seawater_correction(Sal = sal, TempC = temp_c, Mg = magnesium, Ca = calcium)
  }
  else if (tolower(method) == "myami_polynomial") {
    pymyami <- reticulate::import("pymyami")
    seawater_correction <- pymyami$approximate_seawater_correction(Sal = sal, TempC = temp_c, Mg = magnesium, Ca = calcium)
  }
  else if (tolower(method) == "r_polynomial") {
    poly_coefs <- rjson::fromJSON(file = system.file("coefficients/polynomial_coefficients.json", package = "kgen"))
    seawater_correction <- list(k=poly_coefs[[k]] %*% kgen_poly(sal = sal, temp_k = temp_c+273.15, magnesium = magnesium, calcium = calcium))
  }
  if (k %in% names(seawater_correction)) {
    return(as.numeric(seawater_correction[[k]]))
  }
  else {
    return(1)
  }
}