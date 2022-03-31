#' Calculate a specified stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @param k K to be calculated
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU) 
#' @param P Pressure (Bar) (optional) 
#' @importFrom rjson fromJSON
#' @return Specified K at the given conditions
#' @examples
#' calc_K("K0", 25, 35)
#' @export
calc_K <- function(k, TC=25, S=35, P=NA) {

  # File path to coefficients
  file_path <- "data/"
  
  # Load K_calculation.json
  K_coefs <- fromJSON(file=paste0(file_path,"K_calculation.json"))
  K_coefs <- K_coefs$coefficients
  
  # Load K_pressure_correction.json
  K_presscorr_coefs <- fromJSON(file=paste0(file_path,"K_pressure_correction.json"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients
  
  # Import all K_functions to list
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
  
  # Check if selected function exists
  if(!k %in% names(K_fns)){ 
    stop(paste(k,"does not exist."))
  }
  
  # Celsius to Kelvin
  TK = TC + 273.15
  
  # Select function and run calculation
  K_fn = K_fns[[k]]
  K = K_fn(p=K_coefs[[k]], TK=TK, S=S)
  
  # Pressure correction?
  if(!is.na(P)) {
    K = K * fn_pc(p=K_presscorr_coefs[[k]], P=P, TC=TC)
  }
  
  return(K)
}

#' Calculate a specified stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU) 
#' @param P Pressure (Bar) (optional)
#' @importFrom rjson fromJSON
#' @param K_list List of Ks to be calculated e.g., list("K0", "K1")
#' @return Dataframe of specified Ks at the given conditions
#' @examples
#' calc_Ks(25, 35, K_list = c("K0", "K1"))
#' @export
calc_Ks <- function(TC=25, S=35, P=NA, K_list) {

  # File path to coefficients
  file_path <- "data/"
  
  # Load K_calculation.json
  K_coefs <- fromJSON(file=paste0(file_path,"K_calculation.json"))
  K_coefs <- K_coefs$coefficients
  
  # Load K_pressure_correction.json
  K_presscorr_coefs <- fromJSON(file=paste0(file_path,"K_pressure_correction.json"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients
  
  # Import all functions to list
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
  
  # Check if K_list is supplied, use K_fns as default
  if(missing(K_list)){
     K_list = names(K_fns)
  }
  
  # Celsius to Kelvin
  TK = TC + 273.15
  
  # Iterate through K_list 
  Ks_list = list()
  for(k in unique(K_list)){
    
    # Select function and run calculation
    K_fn = K_fns[[k]]
    Ks_list[k] = K_fn(p=K_coefs[[k]], TK=TK, S=S)
    
    # Pressure correction?
    if(!is.na(P)){
      if(k %in% names(K_presscorr_coefs)) {
        Ks_list[k] = Ks_list[[k]] * fn_pc(p=K_presscorr_coefs[[k]], P=P, TC=TC)
      }
    }
  }
  # Return data.frame
  Ks = data.frame(do.call(rbind, Ks_list))
  names(Ks)[1] <- "values"
  
  return(Ks)
}

