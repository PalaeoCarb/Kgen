#' @title Ionic strength after Dickson (1990a); see Dickson et al. (2007)
#'
#' @param sal Salinity
#' @return Ionic strength
calc_ionic_strength <- function(sal) {
  Istr <- 19.924 * sal / (1000 - 1.005 * sal)

  return(Istr)
}

#' @title Calculate K1
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return K1
calc_K1 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  K1 <- 10^(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    coefficients[4] * sal +
    coefficients[5] * sal^2)

  return(K1)
}

#' @title Calculate K2
#'
#' @inheritParams calc_K1
#' @return K2
calc_K2 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  K2 <- 10^(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    coefficients[4] * sal +
    coefficients[5] * sal^2)

  return(K2)
}

#' @title Calculate KW
#'
#' @inheritParams calc_K1
#' @return KW
calc_KW <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  KW <- exp(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5] +
      coefficients[6] * log(temp_k)) * sqrt(sal) +
    coefficients[7] * sal)

  return(KW)
}

#' @title Calculate KB
#'
#' @inheritParams calc_K1
#' @return KB
calc_KB <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  KB <- exp((coefficients[1] +
    coefficients[2] * sqrt(sal) +
    coefficients[3] * sal) +
    (coefficients[4] +
      coefficients[5] * sqrt(sal) +
      coefficients[6] * sal +
      coefficients[7] * sal * sqrt(sal) +
      coefficients[8] * sal * sal) / temp_k +
    (coefficients[9] + coefficients[10] * sqrt(sal) +
      coefficients[11] * sal) * log(temp_k) +
    coefficients[12] * sqrt(sal) * temp_k)

  return(KB)
}

#' @title Calculate K0
#'
#' @inheritParams calc_K1
#' @return K0
calc_K0 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  K0 <- exp(coefficients[1] +
    coefficients[2] * 100 / temp_k +
    coefficients[3] * log(temp_k / 100) +
    sal * (coefficients[4] + coefficients[5] *
      temp_k / 100 + coefficients[6] *
      (temp_k / 100) * (temp_k / 100)))

  return(K0)
}

#' @title Calculate KS
#'
#' @inheritParams calc_K1
#' @return KS
calc_KS <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  Istr <- calc_ionic_strength(sal)
  KS <- exp(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    sqrt(Istr) * (coefficients[4] / temp_k +
      coefficients[5] + coefficients[6] * log(temp_k)) +
    Istr * (coefficients[7] / temp_k + coefficients[8] +
      coefficients[9] * log(temp_k)) +
    coefficients[10] / temp_k * Istr * sqrt(Istr) +
    coefficients[11] / temp_k * Istr^2 +
    log(1 - 0.001005 * sal))

  return(KS)
}

#' @title Calculate Ksp
#'
#' @inheritParams calc_K1
#' @return Ksp
calc_Ksp <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  Ksp <- 10^(coefficients[1] +
    coefficients[2] * temp_k +
    coefficients[3] / temp_k +
    coefficients[4] * log10(temp_k) +
    (coefficients[5] + coefficients[6] * temp_k +
      coefficients[7] / temp_k) * sqrt(sal) +
    coefficients[8] * sal +
    coefficients[9] * sal * sqrt(sal))

  return(Ksp)
}

#' @title Calculate KP1
#'
#' @inheritParams calc_K1
#' @return KP1
calc_KP1 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  KP <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5]) * sqrt(sal) +
    (coefficients[6] / temp_k + coefficients[7]) * sal)

  return(KP)
}

#' @title Calculate KP2
#'
#' @inheritParams calc_K1
#' @return KP2
calc_KP2 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  KP <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5]) * sqrt(sal) +
    (coefficients[6] / temp_k + coefficients[7]) * sal)

  return(KP)
}

#' @title Calculate KP3
#'
#' @inheritParams calc_K1
#' @return KP3
calc_KP3 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  KP3 <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    (coefficients[3] / temp_k + coefficients[4]) * sqrt(sal) +
    (coefficients[5] / temp_k + coefficients[6]) * sal)

  return(KP3)
}

#' @title Calculate KSi
#'
#' @inheritParams calc_K1
#' @return KSi
calc_KSi <- function(coefficients, temp_c, sal) {
  Istr <- calc_ionic_strength(sal)
  temp_k <- temp_c + 273.15
  tmp <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5]) * Istr^0.5 +
    (coefficients[6] / temp_k + coefficients[7]) * Istr +
    (coefficients[8] / temp_k + coefficients[9]) * Istr^2)

  KSi <- tmp * (1 - 0.001005 * sal)

  return(KSi)
}

#' @title Calculate KF
#'
#' @inheritParams calc_K1
#' @return KF
calc_KF <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c + 273.15
  KF <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * sqrt(sal))

  return(KF)
}

#' @title Calculate pressure correction factor for Ks
#'
#' @references From Millero et al. (2007, doi:10.1021/cr0503557), Eqns 38-40
#'
#' @inheritParams calc_K1
#' @param p_bar Pressure (Bar)
#' @return Pressure correction factor
calc_pc <- function(coefficients, temp_c, p_bar) {
  a0 <- coefficients[1]
  a1 <- coefficients[2]
  a2 <- coefficients[3]
  b0 <- coefficients[4]
  b1 <- coefficients[5]

  dV <- a0 + a1 * temp_c + a2 * temp_c^2

  dk <- (b0 + b1 * temp_c)

  RT <- 83.1451 * (temp_c + 273.15)

  prescorr <- exp((-dV + 0.5 * dk * p_bar) * p_bar / RT)

  return(prescorr)
}

#' @title Calculate sulphate
#' @references From Dickson et al., 2007, Table 2, Note: Sal / 1.80655 = Chlorinity
#'
#' @param sal Salinity
#' @return sulphate
calc_sulphate <- function(sal) {
  sulphate <- 0.14 * sal / 1.80655 / 96.062 # mol/kg-SW

  return(sulphate)
}

#' @title Calculate fluorine
#' @references From Dickson et al., 2007, Table 2, Note: Sal / 1.80655 = Chlorinity
#'
#' @param sal Salinity
#' @return fluorine
calc_fluorine <- function(sal) {
  fluorine <- 6.7e-5 * sal / 1.80655 / 18.9984 # mol/kg-SW

  return(fluorine)
}

#' List of all functions
K_fns <- list(
  K0 = calc_K0,
  K1 = calc_K1,
  K2 = calc_K2,
  KW = calc_KW,
  KB = calc_KB,
  KS = calc_KS,
  KspA = calc_Ksp,
  KspC = calc_Ksp,
  KP1 = calc_KP1,
  KP2 = calc_KP2,
  KP3 = calc_KP3,
  KSi = calc_KSi,
  KF = calc_KF
)
