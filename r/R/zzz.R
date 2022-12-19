# Load pyAMI on package load
pymyami <- NULL

# Select pyAMI version
pymyami_version <- "2.0a6"

.onLoad <- function(libname, pkgname) {
  if (mc_exists()) {
    if (!pymyami_exists()) {
      reticulate::use_miniconda("r-reticulate")

      reticulate::py_install(paste0("pymyami==", pymyami_version),
        pip = TRUE
      )
    }
  }
}
