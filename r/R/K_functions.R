#' Ionic strength after Dickson (1990a); see Dickson et al. (2007)
#'
#' @param sal Salinity
#' @return Ionic strength
fn_Istr <- function(sal) {
  Istr <- 19.924 * sal / (1000 - 1.005 * sal)

  return(Istr)
}

#' Calculate K1
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return K1
fn_K1 <- function(p, temp_k, sal) {
  K1 <- 10^(p[1] +
    p[2] / temp_k +
    p[3] * log(temp_k) +
    p[4] * sal +
    p[5] * sal^2)

  return(K1)
}

#' Calculate K2
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return K2
fn_K2 <- function(p, temp_k, sal) {
  K2 <- 10^(p[1] +
    p[2] / temp_k +
    p[3] * log(temp_k) +
    p[4] * sal +
    p[5] * sal^2)

  return(K2)
}

#' Calculate KW
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KW
fn_KW <- function(p, temp_k, sal) {
  KW <- exp(p[1] +
    p[2] / temp_k +
    p[3] * log(temp_k) +
    (p[4] / temp_k + p[5] + p[6] * log(temp_k)) * sqrt(sal) +
    p[7] * sal)

  return(KW)
}

#' Calculate KB
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KB
fn_KB <- function(p, temp_k, sal) {
  KB <- exp((p[1] +
    p[2] * sqrt(sal) +
    p[3] * sal) +
    (p[4] +
      p[5] * sqrt(sal) +
      p[6] * sal +
      p[7] * sal * sqrt(sal) +
      p[8] * sal * sal) / temp_k +
    (p[9] + p[10] * sqrt(sal) + p[11] * sal) * log(temp_k) + +
      p[12] * sqrt(sal) * temp_k)

  return(KB)
}

#' Calculate K0
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return K0
fn_K0 <- function(p, temp_k, sal) {
  K0 <- exp(p[1] +
    p[2] * 100 / temp_k +
    p[3] * log(temp_k / 100) +
    sal * (p[4] + p[5] * temp_k / 100 + p[6] * (temp_k / 100) * (temp_k / 100)))

  return(K0)
}

#' Calculate KS
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KS
fn_KS <- function(p, temp_k, sal) {
  Istr <- fn_Istr(sal)
  KS <- exp(p[1] +
    p[2] / temp_k +
    p[3] * log(temp_k) +
    sqrt(Istr) * (p[4] / temp_k + p[5] + p[6] * log(temp_k)) +
    Istr * (p[7] / temp_k + p[8] + p[9] * log(temp_k)) +
    p[10] / temp_k * Istr * sqrt(Istr) +
    p[11] / temp_k * Istr^2 +
    log(1 - 0.001005 * sal))

  return(KS)
}

#' Calculate Ksp
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return Ksp
fn_Ksp <- function(p, temp_k, sal) {
  Ksp <- 10^(p[1] +
    p[2] * temp_k +
    p[3] / temp_k +
    p[4] * log10(temp_k) +
    (p[5] + p[6] * temp_k + p[7] / temp_k) * sqrt(sal) +
    p[8] * sal +
    p[9] * sal * sqrt(sal))

  return(Ksp)
}

#' Calculate KP1
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KP1
fn_KP1 <- function(p, temp_k, sal) {
  KP <- exp(p[1] / temp_k +
    p[2] +
    p[3] * log(temp_k) +
    (p[4] / temp_k + p[5]) * sqrt(sal) +
    (p[6] / temp_k + p[7]) * sal)

  return(KP)
}

#' Calculate KP2
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KP2
fn_KP2 <- function(p, temp_k, sal) {
  KP <- exp(p[1] / temp_k +
    p[2] +
    p[3] * log(temp_k) +
    (p[4] / temp_k + p[5]) * sqrt(sal) +
    (p[6] / temp_k + p[7]) * sal)

  return(KP)
}

#' Calculate KP3
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KP3
fn_KP3 <- function(p, temp_k, sal) {
  KP3 <- exp(p[1] / temp_k +
    p[2] +
    (p[3] / temp_k + p[4]) * sqrt(sal) +
    (p[5] / temp_k + p[6]) * sal)

  return(KP3)
}

#' Calculate KSi
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KSi
fn_KSi <- function(p, temp_k, sal) {
  Istr <- fn_Istr(sal)
  tmp <- exp(p[1] / temp_k +
    p[2] +
    p[3] * log(temp_k) +
    (p[4] / temp_k + p[5]) * Istr^0.5 +
    (p[6] / temp_k + p[7]) * Istr +
    (p[8] / temp_k + p[9]) * Istr^2)

  KSi <- tmp * (1 - 0.001005 * sal)

  return(KSi)
}

#' Calculate KF
#'
#' @param p Parameters for K calculation
#' @param temp_k Temperature (Kelvin)
#' @param sal Salinity
#' @return KF
fn_KF <- function(p, temp_k, sal) {
  KF <- exp(p[1] / temp_k +
    p[2] +
    p[3] * sqrt(sal))

  return(KF)
}

#' Calculate pressure correction factor for Ks
#' From Millero et al. (2007, doi:10.1021/cr0503557)
#' Eqns 38-40
#'
#' @param p Parameters for K calculation
#' @param temp_c Temperature (Celsius)
#' @param p_bar Pressure
#' @return Pressure correction factor
fn_pc <- function(p, temp_c, p_bar) {
  a0 <- p[1]
  a1 <- p[2]
  a2 <- p[3]
  b0 <- p[4]
  b1 <- p[5]

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
  K0 = fn_K0,
  K1 = fn_K1,
  K2 = fn_K2,
  KW = fn_KW,
  KB = fn_KB,
  KS = fn_KS,
  KspA = fn_Ksp,
  KspC = fn_Ksp,
  KP1 = fn_KP1,
  KP2 = fn_KP2,
  KP3 = fn_KP3,
  KSi = fn_KSi,
  KF = fn_KF
)
