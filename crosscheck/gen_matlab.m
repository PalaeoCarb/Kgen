% Required steps:
% 
% 1. Load test_conditions.csv
% 2. Run kgen using those inputs
% 3. Save inputs to ./generated_Ks as MATAB_{calculated, approximated}.csv - see ./generated/python_calculated.csv for file format.

crosscheck = readtable("./../crosscheck/test_conditions.csv");

kgen_full = kgen.kgen_static.calculate_all_Ks(crosscheck.TempC,crosscheck.Sal,crosscheck.Pres,crosscheck.Mg,crosscheck.Ca,"MyAMI");
kgen_python = kgen.kgen_static.calculate_all_Ks(crosscheck.TempC,crosscheck.Sal,crosscheck.Pres,crosscheck.Mg,crosscheck.Ca,"MyAMI_Polynomial");
kgen_matlab = kgen.kgen_static.calculate_all_Ks(crosscheck.TempC,crosscheck.Sal,crosscheck.Pres,crosscheck.Mg,crosscheck.Ca,"Matlab_Polynomial");

for name = string(fieldnames(kgen_full))'
    kgen_full_vs_python.(name) = kgen_full.(name)-kgen_python.(name);
    kgen_full_vs_matlab.(name) = kgen_full.(name)-kgen_matlab.(name);
end