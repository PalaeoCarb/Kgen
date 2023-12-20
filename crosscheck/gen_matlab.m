% Required steps:
% 
% 1. Load test_conditions.csv
% 2. Run kgen using those inputs
% 3. Save inputs to ./generated_Ks as matlab_{calculated, approximated}.csv - see ./generated/python_calculated.csv for file format.

crosscheck = readtable("./../crosscheck/test_conditions.csv");

kgen_full = kgen.kgen_static.calc_Ks(temp_c=crosscheck.temp_c,sal=crosscheck.sal,p_bar=crosscheck.p_bar,magnesium=crosscheck.magnesium,calcium=crosscheck.calcium,seawater_correction_method="MyAMI");
kgen_python = kgen.kgen_static.calc_Ks(temp_c=crosscheck.temp_c,sal=crosscheck.sal,p_bar=crosscheck.p_bar,magnesium=crosscheck.magnesium,calcium=crosscheck.calcium,seawater_correction_method="MyAMI_Polynomial");
kgen_matlab = kgen.kgen_static.calc_Ks(temp_c=crosscheck.temp_c,sal=crosscheck.sal,p_bar=crosscheck.p_bar,magnesium=crosscheck.magnesium,calcium=crosscheck.calcium,seawater_correction_method="Matlab_Polynomial");

for name = string(fieldnames(kgen_full))'
    kgen_full_vs_python.(name) = kgen_full.(name)-kgen_python.(name);
    kgen_full_vs_matlab.(name) = kgen_full.(name)-kgen_matlab.(name);
end

writetable(struct2table(kgen_full),"./generated_Ks/matlab_calculated.csv")
%writetable(struct2table(kgen_python),"./generated_Ks/matlab_python_approximated.csv")
writetable(struct2table(kgen_matlab),"./generated_Ks/matlab_approximated.csv")
