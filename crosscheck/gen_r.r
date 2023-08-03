# 1. Load test_conditions.csv
test_df <- read.csv("test_conditions.csv")

# 2. Calculate and approximate Ks
Ks_calc <- kgen::calc_Ks(
  temp_c = test_df$temp_c,
  sal = test_df$sal,
  p_bar = test_df$p_bar,
  magnesium = test_df$magnesium,
  calcium = test_df$calcium,
  method = "MyAMI"
)

Ks_approx <- kgen::calc_Ks(
  temp_c = test_df$temp_c,
  sal = test_df$sal,
  p_bar = test_df$p_bar,
  magnesium = test_df$magnesium,
  calcium = test_df$calcium,
  method = "R_Polynomial"
)

# 3. Save outputs to ./generated_Ks as r_{calculated, approximated}.csv
write.csv(Ks_calc, "generated_Ks/r_calculated.csv", row.names = F)
write.csv(Ks_approx, "generated_Ks/r_approximated.csv", row.names = F)
