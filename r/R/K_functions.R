#' Ionic strength after Dickson (1990a); see Dickson et al. (2007)
#'
#' @param S Salinity
#' @return Ionic strength
fn_Istr <- function(S){ 

  Istr = 19.924 * S / (1000 - 1.005 * S)

  return(Istr)
}

#' Calculate K1
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return K1
fn_K1 <- function(p, TK, S){ 

  K1 = 10 ^ (p[1] +
         p[2] / TK +
         p[3] * log(TK) +
         p[4] * S +
         p[5] * S^2)
  
  return(K1)
}

#' Calculate K2
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return K2
fn_K2 <- function(p, TK, S){ 
  
  K2 = 10 ^ (p[1] +
             p[2] / TK +
             p[3] * log(TK) +
             p[4] * S +
             p[5] * S^2)
  
  return(K2)
}

#' Calculate KW
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KW
fn_KW <- function(p, TK, S){

  KW =  exp(p[1] +
        p[2] / TK +
        p[3] * log(TK) +
       (p[4] / TK + p[5] + p[6] * log(TK)) * sqrt(S) +
        p[7] * S)
  
  return(KW)
}

#' Calculate KB
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KB
fn_KB <- function(p, TK, S){

  KB = exp((p[1] + 
            p[2] * sqrt(S) + 
            p[3] * S) + 
           (p[4] +
            p[5] * sqrt(S) +
            p[6] * S +
            p[7] * S * sqrt(S) +
            p[8] * S * S) / TK +
           (p[9] + p[10] * sqrt(S) + p[11] * S) * log(TK)+ +
            p[12] * sqrt(S) * TK)
  
  return(KB)

}

#' Calculate K0
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return K0
fn_K0 <- function(p, TK, S){

  K0 = exp(p[1] + 
       p[2] * 100 / TK + 
       p[3] * log(TK / 100) +
       S * (p[4] + p[5] * TK / 100 + p[6] * (TK / 100) * (TK / 100)))
    
    return(K0)
}

#' Calculate KS
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KS
fn_KS <- function(p, TK, S){

  Istr = fn_Istr(S) 
  KS = exp(p[1] + 
       p[2] / TK + 
       p[3] * log(TK) +
       sqrt(Istr) * (p[4] / TK + p[5] + p[6] * log(TK)) +
       Istr * (p[7] / TK + p[8] + p[9] * log(TK)) +
       p[10] / TK * Istr * sqrt(Istr) + 
       p[11] / TK * Istr ^ 2 +
       log(1 - 0.001005 * S))

  return(KS)
}

#' Calculate Ksp
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return Ksp
fn_Ksp <- function(p, TK, S){

    Ksp = 10^(p[1] + 
          p[2] * TK +
          p[3] / TK +
          p[4] * log10(TK) +
         (p[5] + p[6] * TK + p[7] / TK) * sqrt(S) +
          p[8] * S +
          p[9] * S * sqrt(S))

  return(Ksp)
  
}

#' Calculate KP1
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KP1
fn_KP1 <- function(p, TK, S){

  KP = exp(p[1] / TK + 
       p[2] + 
       p[3] * log(TK) + 
      (p[4] / TK + p[5]) * sqrt(S) +
      (p[6] / TK + p[7]) * S)

  return(KP)
}

#' Calculate KP2
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KP2
fn_KP2 <- function(p, TK, S){
  
  KP = exp(p[1] / TK + 
             p[2] + 
             p[3] * log(TK) + 
             (p[4] / TK + p[5]) * sqrt(S) +
             (p[6] / TK + p[7]) * S)
  
  return(KP)
}

#' Calculate KP3
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KP3
fn_KP3 <- function(p, TK, S){

  KP3 = exp(p[1] / TK + 
        p[2] + 
       (p[3] / TK + p[4]) * sqrt(S) + 
       (p[5] / TK + p[6]) * S)

  return(KP3)
}

#' Calculate KSi
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KSi
fn_KSi <- function(p, TK, S){

  Istr = fn_Istr(S) 
  tmp = exp(p[1] / TK + 
        p[2] +
        p[3] * log(TK) +
        (p[4] / TK + p[5]) * Istr ^ 0.5 +
        (p[6] / TK + p[7]) * Istr +
        (p[8] / TK + p[9]) * Istr ^ 2)

  KSi = tmp * (1 - 0.001005 * S)
  
  return(KSi)
}

#' Calculate KF
#'
#' @param p Parameters for K calculation
#' @param TK Temperature (Kelvin)
#' @param S Salinity
#' @return KF
fn_KF <- function(p, TK, S){

  KF = exp(p[1] / TK + 
       p[2] + 
       p[3] * sqrt(S))

  return(KF)
}


#' Calculate TS
#'
#' @param S Salinity
#' @return TS
calc_TS <- function(S){
  # From Dickson et al., 2007, Table 2
  # Note: Sal / 1.80655 = Chlorinity
  TS = 0.14 * S / 1.80655 / 96.062 # mol/kg-SW

  return(TS)
}

#' Calculate TF
#'
#' @param S Salinity
#' @return TF
calc_TS <- function(S){
  # From Dickson et al., 2007, Table 2
  # Note: Sal / 1.80655 = Chlorinity
  TF = 6.7e-5 * S / 1.80655 / 18.9984 # mol/kg-SW

  return(TF)
}


#' Calculate pressure correction factor for Ks
#' From Millero et al. (2007, doi:10.1021/cr0503557)
#' Eqns 38-40
#' 
#' @param p Parameters for K calculation
#' @param P Pressure
#' @param TC Temperature (Celsius)
#' @return Pressure correction factor
fn_pc <- function(p, P, TC) {
  
  a0 = p[1] 
  a1 = p[2] 
  a2 = p[3] 
  b0 = p[4]
  b1 = p[5] 
  
  dV = a0 + a1 * TC + a2 * TC ^ 2
  
  dk = (b0 + b1 * TC)
  
  RT = 83.1451 * (TC + 273.15)
  
  prescorr = exp((-dV + 0.5 * dk * P) * P / RT)
  
  return(prescorr)
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
  KF = fn_KF)