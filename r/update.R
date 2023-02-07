# Simple helper script to check Kgen for R pre deployment.
# This script is meant to be executed locally.

# Required packages
# https://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
list.of.packages <- c("devtools", "gert")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Check and copy coefficients to "inst/coefficients"
diff <-
  system('diff -r --exclude=".*" ../coefficients inst/coefficients')
if (diff != 0) {
  system('rsync -av ../coefficients/ inst/coefficients/')
  message("New coefficient files. Syncing files to inst/coefficients directory.")
}

# Check and copy check_values to "inst/check_values"
diff <-
  system('diff -r --exclude=".*" ../check_values inst/check_values')
if (diff != 0) {
  system('rsync -av ../check_values/ inst/check_values/')
  message("New check values files. Syncing files to inst/check_values directory.")
}

# Write Documentation and NAMESPACE and check package integrity
roxygen2::roxygenise() # Not realy necessary but I prefer it that way.
dev_checks <- devtools::check()

# Stop script if devtools::check already returns an error.
if (!identical(dev_checks$errors, character(0)))
  stop("At least one error in devtools::check")
if (!identical(dev_checks$warnings, character(0)))
  stop("At least one warning in devtools::check")
if (!identical(dev_checks$notes, character(0)))
  stop("At least one note in devtools::check")

# Commit
if (nrow(gert::git_status()) > 0) {
  gert::git_add("*")
  gert::git_commit_all("auto commit")
}

# Style
usethis::use_tidy_style()

# Bump version
usethis::use_version()

# Commit + Push
if (nrow(gert::git_status()) > 0) {
  gert::git_add("*")
  gert::git_commit_all("auto commit")
}
gert::git_push()

# Submit to CRAN?
answ <- askYesNo("Submit pkg to CRAN?")
if (answ) {
  devtools::release(pkg = ".", check = TRUE)
}
