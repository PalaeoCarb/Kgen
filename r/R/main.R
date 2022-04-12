#' Calculate a specified stoichiometric equilibrium constant at given temperature, salinity and pressure.
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
calc_K <- function(k, TC=25, S=35, Mg=0.0528171, Ca=0.0102821, P=NULL, MyAMI_calc=TRUE) {
  
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
  TC_check = ifelse(TC < 0 | TC > 40, "out", "in")
  if("out" %in% TC_check) stop("Temperature must be between 0 and 40 degC.")
  
  S_check = ifelse(S < 30 | S > 40, "out", "in")
  if("out" %in% S_check) stop("Salinity must be between 30 and 40 psu.")
  
  Mg_check = ifelse(Mg < 0 | Mg > 0.06, "out", "in")
  if("out" %in% Mg_check) stop("Mg must be between 0 and 0.06 mol/kgsw.")
  
  Ca_check = ifelse(Ca < 0 | Ca > 0.06, "out", "in")
  if("out" %in% Ca_check) stop("Ca must be between 0 and 0.06 mol/kgsw.")
  
  # Load K_calculation.json
  K_coefs <- fromJSON(file=system.file("K_calculation.json", package="Kgen"))
  K_coefs <- K_coefs$coefficients
  
  # Load K_pressure_correction.json
  K_presscorr_coefs <- fromJSON(file=system.file("K_pressure_correction.json", package="Kgen"))
  K_presscorr_coefs <- K_presscorr_coefs$coefficients
  
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
  if(!is.null(P)) {
    
    pc = fn_pc(p=K_presscorr_coefs[[k]], P=P, TC=TC)
    check_pc = ifelse(pc != 0, pc, 1)
    K = K * check_pc
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
    check_KF = ifelse(KF != 0, KF, 1)
    K = K * check_KF
  }

  return(K)
}

#' Wrapper to calculate multiple stoichiometric equilibrium constants at given temperature, salinity and pressure.
#'
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU) 
#' @param P Pressure (Bar) (optional)
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample. Used to correct the Ks using MyAMI.
#' @param MyAMI_calc TRUE/FALSE 
#' @importFrom rjson fromJSON
#' @importFrom utils askYesNo
#' @param k_list List of Ks to be calculated e.g., list("K0", "K1")
#' @return Dataframe of specified Ks at the given conditions
#' @examples
#' calc_Ks(25, 35, k_list = c("K0", "K1"))
#' @export
calc_Ks <- function(k_list, TC=25, S=35, Mg=0.0528171, Ca=0.0102821, P=NULL, MyAMI_calc=TRUE) {

  # Check if k_list is supplied, use K_fns as default
  if(missing(k_list)){
    k_list = names(K_fns)
  }
  
  # Iterate through k_list 
  ks_list = list()
  for(k in unique(k_list)) {
    ks_list[[k]] <- calc_K(k = k, TC=TC,
                           S=S, Mg=Mg, 
                           Ca=Ca, P=P, 
                           MyAMI_calc=MyAMI_calc)
  }
    
  # Return data.frame
  Ks = data.frame(t(do.call(rbind, ks_list)))
  return(Ks)
}

