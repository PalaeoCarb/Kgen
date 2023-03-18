.onAttach <- function(lib, pkg) {
  packageStartupMessage(
    "Kgen v",
    utils::packageDescription("Kgen",
      fields = "Version"
    ),
    paste0(" // pyMyAMI v", pymyami_version),
    appendLF = TRUE
  )
}
