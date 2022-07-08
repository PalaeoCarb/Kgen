# 1. Load test_conditions.csv
test_df <- read.csv("test_conditions.csv")

# 2. Calculate and approximate Ks
Ks_calc <- Kgen::calc_Ks(TC = test_df$TempC,
                    S = test_df$Sal,
                    P = test_df$Pres,
                   Mg = test_df$Mg,
                   Ca = test_df$Ca,
                   method = "MyAMI")

Ks_approx <- Kgen::calc_Ks(TC = test_df$TempC,
                   S = test_df$Sal,
                   P = test_df$Pres,
                   Mg = test_df$Mg,
                   Ca = test_df$Ca,
                   method = "R_Polynomial")

# 3. Save outputs to ./generated_Ks as r_{calculated, approximated}.csv
write.csv(Ks_calc, "generated_Ks/r_calculated.csv", row.names = F)
write.csv(Ks_approx, "generated_Ks/r_approximated.csv", row.names = F)