# Load pyAMI on package load
pymyami <- NULL

.onLoad <- function(libname, pkgname){
  pymyami <<- reticulate::import("pymyami", delay_load = TRUE)
}