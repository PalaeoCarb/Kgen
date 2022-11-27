# Load pyAMI on package load
pymyami <- NULL

.onLoad <- function(pymyami_version = "2.0a4"){
  
  if(mc_exists()){ 
    if(!pymyami_exists()){ 
      reticulate::py_install(paste0("pymyami==", pymyami_version), envname = "r-reticulate", pip=T)
    }
  }
  
  pymyami <<- reticulate::import("pymyami", delay_load = TRUE)
  
}