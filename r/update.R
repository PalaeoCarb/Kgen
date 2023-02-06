# Simple helper script to check Kgen for R pre deployment.
# This script is meant to be executed locally. 

# Required packages
# install.packages("devtools")
# install.packages("rhub")

# Check and copy coefficients to "inst/coefficients"
diff <- system('diff -r --exclude=".*" ../coefficients inst/coefficients')
if(diff != 0){
  system('rsync -av ../coefficients/ inst/coefficients/')
  message("New coefficient files. Syncing files to inst/coefficients directory.")
}

# Check and copy check_values to "inst/check_values"
diff <- system('diff -r --exclude=".*" ../check_values inst/check_values')
if(diff != 0){
  system('rsync -av ../check_values/ inst/check_values/')
  message("New check values files. Syncing files to inst/check_values directory.")
}

# Write Documentation and NAMESPACE and check package integrity
roxygen2::roxygenise()
dev_checks <- devtools::check()

# Stop script if devtools::check already returns an error.
if(!identical(dev_checks$errors, character(0))) stop("At least one error in devtools::check")
if(!identical(dev_checks$warnings, character(0))) stop("At least one warning in devtools::check")
if(!identical(dev_checks$notes, character(0))) stop("At least one note in devtools::check")

# Check against CRAN requirements
devtools::build("r")
Kgen_tar <- list.files()[grep("*.tar.gz",list.files())]
rhub::check_for_cran(Kgen_tar, platforms = "macos-highsierra-release-cran") 
system(paste('rm ', Kgen_tar))

# Commit
gert::git_commit_all("auto commit", author = "Dennis Mayk")




