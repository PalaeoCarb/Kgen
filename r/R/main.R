#' Kgen R polynomial function
#' @importFrom stats poly
#' @param TK Temperature (Kelvin)
#' @param S Salinity (PSU) 
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
kgen_poly <- function(S, TK, Mg, Ca) {

  # Create descriptor vector
  DX <- t(c(TK, log(TK), S, Mg, Ca))

  # Build poly matrix
  DY <- cbind(intercept = 1, poly(DX, 3, raw = TRUE))
  
  # Sort by index - according to python output
  index <- c(1,2,7,22,3,8,23,12,27,37,4,9,24,13,28,38,16,31,41,47,5,10,25,14,29,
             39,17,32,42,48,19,34,44,50,53,6,11,26,15,30,40,18,33,43,49,20,35,
             45,51,54,21,36,46,52,55,56)
  
  out <- DY[order(index)]

  return(out)
}

#' Calculate a specified stoichiometric equilibrium constant at given temperature, salinity and pressure.
#'
#' @param k K to be calculated
#' @param TC Temperature (Celsius)
#' @param S Salinity (PSU) 
#' @param P Pressure (Bar) (optional) 
#' @param Mg Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
#' @param Ca Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.
#' @param method Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (default = MyAMI).
#' @param Kcorrect TRUE = calculate corrections, FALSE = don't calculate corrections. 
#' @importFrom rjson fromJSON
#' @importFrom utils askYesNo
#' @return Specified K at the given conditions
#' @export
calc_K <- function(k, TC=25, S=35, Mg=0.0528171, Ca=0.0102821, P=NULL, method="MyAMI", Kcorrect=TRUE) {
  
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
  if(any(TC < 0) | any(TC > 40)) stop("Temperature must be between 0 and 40 degC.")
  if(any(S < 30) | any(S > 40)) stop("Salinity must be between 30 and 40 psu.")
  if(any(Mg < 0) | any(Mg > 0.06)) stop("Mg must be between 0 and 0.06 mol/kgsw.")
  if(any(Ca < 0) | any(Ca > 0.06)) stop("Ca must be between 0 and 0.06 mol/kgsw.")
  
  # Check vector length
  if(length(TC) != length(S) |
     length(TC) != length(Mg) |
     length(TC) != length(Ca)) {
    stop("Supplied values are not of the same length.")
  } 
  
  # Load K_calculation.json
  K_coefs <- fromJSON(file=system.file("coefficients/K_calculation.json", package="Kgen"))
  K_coefs <- K_coefs$coefficients
  
  # Load K_pressure_correction.json
  K_presscorr_coefs <- fromJSON(file=system.file("coefficients/K_pressure_correction.json", package="Kgen"))
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
  if(!is.null(P) & k != "KSi") {
     pc = fn_pc(p=K_presscorr_coefs[[k]], P=P, TC=TC)
     check_pc = ifelse(pc != 0, pc, 1)
     K = K * check_pc
  }
  
  # Calculate correction factor
  if(Kcorrect == TRUE){
    
    if(method == "MyAMI"){ 
      Fcorr = pymyami$calc_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
    } 
    if(method == "MyAMI_Polynomial"){
      Fcorr = pymyami$approximate_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
    }
    if(method == "R_Polynomial"){
      
      # Load K_pressure_correction.json
      poly_coefs <- fromJSON(file=system.file("coefficients/polynomial_coefficients.json", package="Kgen"))
      
      Fcorr <- list()
      tmp <- vector()
      for(k in names(poly_coefs)) {
        for(ii in 1:length(TC)) {
          tmp[ii] = poly_coefs[[k]] %*% kgen_poly(S=S[ii], TK=TK[ii], Mg=Mg[ii], Ca=Ca[ii])
          Fcorr[[k]] = tmp
        }
      }
    }

    # Apply correction
    KF = Fcorr[[k]]
    if(!is.null(KF)){
      check_KF = ifelse(KF != 0, KF, 1)
      K = K * check_KF
    }
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
#' @param method Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (default = MyAMI).
#' @importFrom rjson fromJSON
#' @importFrom utils askYesNo
#' @param k_list List of Ks to be calculated e.g., list("K0", "K1")
#' @return Dataframe of specified Ks at the given conditions
#' @export
calc_Ks <- function(k_list, TC=25, S=35, Mg=0.0528171, Ca=0.0102821, P=NULL, method="MyAMI") {

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
                           method=method,
                           Kcorrect=FALSE)
  }
    
  # Return data.frame
  Ks = data.frame(t(do.call(rbind, ks_list)))
  
  # Celsius to Kelvin
  TK = TC + 273.15
  
  # Calculate correction factor with MyAMI
  if(method == "MyAMI"){ 
    Fcorr = pymyami$calc_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
  } 
  if(method == "MyAMI_Polynomial") {
    Fcorr = pymyami$approximate_Fcorr(Sal=S, TempC=TC, Mg=Mg, Ca=Ca)
  }
  if(method == "R_Polynomial"){
    
    # Load K_pressure_correction.json
    poly_coefs <- fromJSON(file=system.file("coefficients/polynomial_coefficients.json", package="Kgen"))
    
    Fcorr <- list()
    tmp <- vector()
    for(k in names(poly_coefs)) {
      for(ii in 1:length(TC)) {
        tmp[ii] = poly_coefs[[k]] %*% kgen_poly(S=S[ii], TK=TK[ii], Mg=Mg[ii], Ca=Ca[ii])
        Fcorr[[k]] = tmp
      }
    }
  }
    
  # Apply correction
  for(k in unique(k_list)) {
    KF = Fcorr[[k]]
    if(!is.null(KF)){
      Ks[k] = Ks[k] * KF
    }
  }
  
  return(Ks)
}

