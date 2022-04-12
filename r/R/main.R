#' Calculate a specified stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @param k K to be calculated
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU) 
#' @param P Pressure (Bar) (optional) 
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param MyAMI_calc TRUE/FALSE 
#' @importFrom rjson fromJSON
#' @importFrom utils askYesNo
#' @return Specified K at the given conditions
#' @examples
#' calc_K("K0", 25, 35)
#' @export
calc_K <- function(k, TC=25, S=35, Mg=0.0528171, Ca=0.0102821, P=0, MyAMI_calc=TRUE) {
  
  # Check if miniconda is installed 
  if(!mc_exists()){
    print("Kgen requires r-Miniconda which appears to not exist on your system.")
    install_confirm <- askYesNo("Would you like to install it now?")
    if(install_confirm == TRUE) {
        install_pymyami()
    } else {
      print("Closing Kgen.")
    }
  }
  
  # Check input values
  if(TC < 0 | TC > 40){stop("Temperature must be between 0 and 40 degC.")}
  if(S < 30 | S > 40){stop("Salinity must be between 30 and 40 psu.")}
  if(Mg < 0 | Mg > 0.06){stop("Mg must be between 0 and 0.06 mol/kgsw.")}
  if(Ca < 0 | Ca > 0.06){stop("Ca must be between 0 and 0.06 mol/kgsw.")}
  
  # Load K_calculation.json
  K_coefs <- fromJSON(file=system.file("K_calculation.json", package="Kgen"))
  K_coefs <- K_coefs$coefficients
  
  # Load K_pressure_correction.json
  K_presscorr_coefs <- fromJSON(file=system.file("K_pressure_correction.json", package="Kgen"))
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
  if(P != 0) {
    pc = fn_pc(p=K_presscorr_coefs[[k]], P=P, TC=TC)
    if(pc != 0) {
      Ks_list[[k]] = Ks_list[[k]] * pc
    }
  }
  
  # Calculate correction factor with MyAMI
  if(MyAMI_calc == TRUE){ 
    Fcorr = pymyami$calc_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
  } else {
    Fcorr = pymyami$approximate_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
  }
  
  # Apply correction
  KF = Fcorr[[k]]
  if(!is.null(KF)){
    K = K * KF
  }

  return(K)
}

#' Calculate a specified stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU) 
#' @param P Pressure (Bar) (optional)
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param MyAMI_calc TRUE/FALSE 
#' @importFrom rjson fromJSON
#' @importFrom utils askYesNo
#' @param K_list List of Ks to be calculated e.g., list("K0", "K1")
#' @return Dataframe of specified Ks at the given conditions
#' @examples
#' calc_Ks(25, 35, K_list = c("K0", "K1"))
#' @export
calc_Ks <- function(TC=25, S=35, Mg=0.0528171, Ca=0.0102821, P=0, MyAMI_calc=TRUE, K_list) {

  # Check if miniconda is installed 
  if(!mc_exists()){
    print("Kgen requires r-Miniconda which appears to not exist on your system.")
    install_confirm <- askYesNo("Would you like to install it now?")
    if(install_confirm == TRUE) {
      install_pymyami()
    } else {
      print("Closing Kgen.")
    }
  }
  
  # Check input values
  if(TC < 0 | TC > 40){stop("Temperature must be between 0 and 40 degC.")}
  if(S < 30 | S > 40){stop("Salinity must be between 30 and 40 psu.")}
  if(Mg < 0 | Mg > 0.06){stop("Mg must be between 0 and 0.06 mol/kgsw.")}
  if(Ca < 0 | Ca > 0.06){stop("Ca must be between 0 and 0.06 mol/kgsw.")}
  
  # Load K_calculation.json
  K_coefs <- fromJSON(file=system.file("K_calculation.json", package="Kgen"))
  K_coefs <- K_coefs$coefficients
  
  # Load K_pressure_correction.json
  K_presscorr_coefs <- fromJSON(file=system.file("K_pressure_correction.json", package="Kgen"))
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
  for(k in unique(K_list)) {
    
    # Select function and run calculation
    K_fn = K_fns[[k]]
    Ks_list[k] = K_fn(p=K_coefs[[k]], TK=TK, S=S)
    
    # Pressure correction?
     if(P != 0) {
       if(k %in% names(K_presscorr_coefs)) {
         pc = fn_pc(p=K_presscorr_coefs[[k]], P=P, TC=TC)
         if(pc != 0) {
           Ks_list[k] = Ks_list[[k]] * pc
         }
       }
     }
  }
  
  # Calculate correction factor with MyAMI
  if(MyAMI_calc == TRUE){
    Fcorr = pymyami$calc_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
  } else {
    Fcorr = pymyami$approximate_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
  }

  # Apply correction
  for(k in names(Ks_list)) {
    K = Ks_list[[k]]
    KF = Fcorr[[k]]

    if(!is.null(KF)){
      Ks_list[[k]] = K * KF
    }
  }
    
  # Return data.frame
  Ks = data.frame(do.call(rbind, Ks_list))
  names(Ks)[1] <- "values"
  
  return(Ks)
}
