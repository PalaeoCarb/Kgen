library('tidyverse')
library('reticulate')

# Load Kgen
if("Kgen" %in% (.packages())){
  detach("package:Kgen", unload=TRUE) 
}
devtools::install_local("../r", force=T)
library('Kgen')

# 1. Load test_conditions.csv
test_df <- read_csv("test_conditions.csv")
python_df <- read_csv("generated_Ks/python_calculated.csv")

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
