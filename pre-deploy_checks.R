# Simple helper script to check Kgen for R pre deployment.
# This script is meant to be executed locally. 

# Required packages
# install.packages("devtools")
# install.packages("rhub")

# Install newest version fo Kgen from source
devtools::unload("Kgen")
devtools::install_local("r", force=T)

# (1) Check and copy coefficients to "r/inst/"
diff <- system('diff -r --exclude=".*" coefficients r/inst/coefficients')
if(diff != 0){
  system('rsync -av coefficients r/inst/')
  message("New coefficient files. Syncing files to r/inst/coefficients directory.")
}

# (2) Check and copy check_values to "r/tests/check_values"
diff <- system('diff -r --exclude=".*" check_values r/tests/check_values')
if(diff != 0){
  system('rsync -av check_values r/inst/')
  message("New check values files. Syncing files to r/tests/check_values directory.")
}

# (3) Write Documentation and NAMESPACE and check package integrity
roxygen2::roxygenise("r")
dev_checks <- devtools::check("r")

# Stop script if devtools::check already returns an error.
if(!identical(dev_checks$errors, character(0))) stop("At least one error in devtools::check")
if(!identical(dev_checks$warnings, character(0))) stop("At least one warning in devtools::check")
if(!identical(dev_checks$notes, character(0))) stop("At least one note in devtools::check")

# (4) Load and test Kgen
library('Kgen')
calc_Ks()

# (5) Check against CRAN requirements
devtools::build("r")
Kgen_tar <- list.files()[grep("*.tar.gz",list.files())]
rhub::check_for_cran(Kgen_tar) 
system(paste('rm ', Kgen_tar))






