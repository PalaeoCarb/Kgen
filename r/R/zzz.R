# Load pyAMI on package load
.onLoad <- function(libname, pkgname){
  assign('pymyami', load_pymyami(), envir = topenv())
}