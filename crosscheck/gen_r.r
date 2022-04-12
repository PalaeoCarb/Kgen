library('tidyverse')
library('reticulate')

# Install local r-Miniconda environment
install_miniconda()
reticulate::use_miniconda("r-reticulate")
reticulate::py_install("pymyami", envname = "r-reticulate", pip=T)

# Load Kgen
library('Kgen')

# 1. Load test_conditions.csv
test_df <- read_csv("test_conditions.csv")

# 2. Calculate and approximate Ks
Ks_calc <- calc_Ks(TC = test_df$TempC,
                    S = test_df$Sal,
                    P = test_df$Pres, 
                   Mg = test_df$Mg, 
                   Ca = test_df$Ca,
                   MyAMI_calc = T)

Ks_approx <- calc_Ks(TC = test_df$TempC,
                   S = test_df$Sal,
                   P = test_df$Pres, 
                   Mg = test_df$Mg, 
                   Ca = test_df$Ca,
                   MyAMI_calc = F)

# 3. Save outputs to ./generated_Ks as r_{calculated, approximated}.csv
write_csv(Ks_calc, "generated_Ks/r_calculated.csv")
write_csv(Ks_approx, "generated_Ks/r_approximated.csv")
