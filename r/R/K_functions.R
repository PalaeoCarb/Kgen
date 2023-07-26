#' Ionic strength after Dickson (1990a); see Dickson et al. (2007)
#'
#' @param sal Salinity
#' @return Ionic strength
calc_ionic_strength <- function(sal) {
  Istr <- 19.924 * sal / (1000 - 1.005 * sal)

  return(Istr)
}

#' Calculate K1
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return K1
calc_K1 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  K1 <- 10^(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    coefficients[4] * sal +
    coefficients[5] * sal^2)

  return(K1)
}

#' Calculate K2
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return K2
calc_K2 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  K2 <- 10^(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    coefficients[4] * sal +
    coefficients[5] * sal^2)

  return(K2)
}

#' Calculate KW
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KW
calc_KW <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  KW <- exp(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5] + coefficients[6] * log(temp_k)) * sqrt(sal) +
    coefficients[7] * sal)

  return(KW)
}

#' Calculate KB
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KB
calc_KB <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  KB <- exp((coefficients[1] +
    coefficients[2] * sqrt(sal) +
    coefficients[3] * sal) +
    (coefficients[4] +
      coefficients[5] * sqrt(sal) +
      coefficients[6] * sal +
      coefficients[7] * sal * sqrt(sal) +
      coefficients[8] * sal * sal) / temp_k +
    (coefficients[9] + coefficients[10] * sqrt(sal) + coefficients[11] * sal) * log(temp_k) + +
      coefficients[12] * sqrt(sal) * temp_k)

  return(KB)
}

#' Calculate K0
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return K0
calc_K0 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  K0 <- exp(coefficients[1] +
    coefficients[2] * 100 / temp_k +
    coefficients[3] * log(temp_k / 100) +
    sal * (coefficients[4] + coefficients[5] * temp_k / 100 + coefficients[6] * (temp_k / 100) * (temp_k / 100)))

  return(K0)
}

#' Calculate KS
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KS
calc_KS <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  Istr <- calc_ionic_strength(sal)
  KS <- exp(coefficients[1] +
    coefficients[2] / temp_k +
    coefficients[3] * log(temp_k) +
    sqrt(Istr) * (coefficients[4] / temp_k + coefficients[5] + coefficients[6] * log(temp_k)) +
    Istr * (coefficients[7] / temp_k + coefficients[8] + coefficients[9] * log(temp_k)) +
    coefficients[10] / temp_k * Istr * sqrt(Istr) +
    coefficients[11] / temp_k * Istr^2 +
    log(1 - 0.001005 * sal))

  return(KS)
}

#' Calculate Ksp
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return Ksp
calc_Ksp <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  Ksp <- 10^(coefficients[1] +
    coefficients[2] * temp_k +
    coefficients[3] / temp_k +
    coefficients[4] * log10(temp_k) +
    (coefficients[5] + coefficients[6] * temp_k + coefficients[7] / temp_k) * sqrt(sal) +
    coefficients[8] * sal +
    coefficients[9] * sal * sqrt(sal))

  return(Ksp)
}

#' Calculate KP1
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KP1
calc_KP1 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  KP <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5]) * sqrt(sal) +
    (coefficients[6] / temp_k + coefficients[7]) * sal)

  return(KP)
}

#' Calculate KP2
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KP2
calc_KP2 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  KP <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5]) * sqrt(sal) +
    (coefficients[6] / temp_k + coefficients[7]) * sal)

  return(KP)
}

#' Calculate KP3
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KP3
calc_KP3 <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  KP3 <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    (coefficients[3] / temp_k + coefficients[4]) * sqrt(sal) +
    (coefficients[5] / temp_k + coefficients[6]) * sal)

  return(KP3)
}

#' Calculate KSi
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KSi
calc_KSi <- function(coefficients, temp_c, sal) {
  Istr <- calc_ionic_strength(sal)
  temp_k <- temp_c+273.15
  tmp <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * log(temp_k) +
    (coefficients[4] / temp_k + coefficients[5]) * Istr^0.5 +
    (coefficients[6] / temp_k + coefficients[7]) * Istr +
    (coefficients[8] / temp_k + coefficients[9]) * Istr^2)

  KSi <- tmp * (1 - 0.001005 * sal)

  return(KSi)
}

#' Calculate KF
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celcius)
#' @param sal Salinity
#' @return KF
calc_KF <- function(coefficients, temp_c, sal) {
  temp_k <- temp_c+273.15
  KF <- exp(coefficients[1] / temp_k +
    coefficients[2] +
    coefficients[3] * sqrt(sal))

  return(KF)
}

#' Calculate pressure correction factor for Ks
#' From Millero et al. (2007, doi:10.1021/cr0503557)
#' Eqns 38-40
#'
#' @param coefficients Coefficients for K calculation
#' @param temp_c Temperature (Celsius)
#' @param p_bar Pressure
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

#' Calculate sulphate
#' From Dickson et al., 2007, Table 2
#' Note: Sal / 1.80655 = Chlorinity#'
#'
#' @param sal Salinity
#' @return sulphate
calc_sulphate <- function(sal) {
  sulphate <- 0.14 * sal / 1.80655 / 96.062 # mol/kg-SW

  return(sulphate)
}

#' Calculate fluorine
#' From Dickson et al., 2007, Table 2
#' Note: Sal / 1.80655 = Chlorinity
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
