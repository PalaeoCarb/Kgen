.onAttach <- function(lib, pkg) {
  packageStartupMessage(
    "Kgen v",
    utils::packageDescription("Kgen",
      fields = "Version"
    ),
    ifelse(
      pymyami_exists(),
      paste0(" // pyMyAMI v", pymyami_version),
      " // pyMyAMI not installed or incompatible version.\nPlease run `install_pymyami()` to install pyMyAMI."
    ),
    appendLF = TRUE
  )
}
