# Specify pymyami version 
pymyami_version <- "2.0a3"

# Check if OS is Windows
is_windows <- function(){
  Sys.info()["sysname"] == "Windows"
}

# Check if OS is OSX
is_osx <- function(){
  Sys.info()["sysname"] == "Darwin"
}

# Check if OS is Linux
is_linux <- function(){
  Sys.info()["sysname"] == "Linux"
}

# Get miniconda path
miniconda_path <- function() {
  Sys.getenv("RETICULATE_MINICONDA_PATH", unset = miniconda_path_default())
}

# Get miniconda default path
miniconda_path_default <- function() {
  
  if (is_osx()) {
    
    # on macOS, use different path for arm64 miniconda
    path <- if (Sys.info()[["machine"]] == "arm64")
      "~/Library/r-miniconda-arm64"
    else
      "~/Library/r-miniconda"
    
    return(path.expand(path))
    
  }
  
  # otherwise, use rappdirs default
  root <- normalizePath(rappdirs::user_data_dir(), winslash = "/", mustWork = FALSE)
  file.path(root, "r-miniconda")
  
}

# Check if miniconda is installed
miniconda_conda <- function(path = miniconda_path()) {
  exe <- if (is_windows()) "condabin/conda.bat" else "bin/conda"
  file.path(path, exe)
}

mc_exists <- function(path = miniconda_path()) {
  conda <- miniconda_conda(path)
  file.exists(conda)
}

#' Check if pymyami is installed
#'
#' @importFrom reticulate py_list_packages
pymyami_exists <- function() {
  check_version <- reticulate::py_list_packages()
  ifelse(paste0("pymyami=", pymyami_version) %in% check_version$requirement, TRUE, FALSE)
}

#' Install MyAMI from pypi
#'
#' @importFrom reticulate install_miniconda
#' @importFrom reticulate py_install
#' @importFrom reticulate use_miniconda
#' @importFrom reticulate import
install_pymyami <- function() {

  # Check if miniconda is installed 
  ifelse(mc_exists(), "Miniconda is already installed.", install_miniconda())
  
  # Select python environment
  reticulate::use_miniconda("r-reticulate")
  
  # Install required version of pyMyAMI
  reticulate::py_install(paste0("pymyami==", pymyami_version), envname = "r-reticulate", pip=T)
  
  # Import pyMyAMI
  reticulate::import("pymyami")
}
