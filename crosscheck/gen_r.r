library('tidyverse')
library('Kgen')

# 1. Load test_conditions.csv
test_df <- read_csv("test_conditions.csv")

# 2. Run Kgen with MyAMI calculations
Ks_calc_list <- list()
for(ii in 1:nrow(test_df)) {
        tmp <- test_df[ii,]
        tmp_Ks_calc <- calc_Ks(TC = tmp$TempC,
                                S = tmp$Sal,
                                P = tmp$Pres, 
                                Mg = tmp$Mg, 
                                Ca = tmp$Ca,
                                MyAMI_calc = T)

        Ks_calc_list[[ii]] <- tmp_Ks_calc$values
}
Ks_calc <- do.call(rbind.data.frame, Ks_calc_list)
colnames(Ks_calc) <- rownames(tmp_Ks_calc)

# 2. Run Kgen with MyAMI approximations
Ks_approx_list <- list()
for(ii in 1:nrow(test_df)) {
        tmp <- test_df[ii,]
        tmp_Ks_approx <- calc_Ks(TC = tmp$TempC,
                               S = tmp$Sal,
                               P = tmp$Pres, 
                               Mg = tmp$Mg, 
                               Ca = tmp$Ca,
                               MyAMI_calc = F)
        
        Ks_approx_list[[ii]] <- tmp_Ks_approx$values
}
Ks_approx <- do.call(rbind.data.frame, Ks_approx_list)
colnames(Ks_approx) <- rownames(tmp_Ks_approx)

# 3. Save outputs to ./generated_Ks as r_{calculated, approximated}.csv
write_csv(Ks_calc, "generated_Ks/r_calculated.csv")
write_csv(Ks_approx, "generated_Ks/r_approximated.csv")
