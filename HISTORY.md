# KGen History.

## 0.3.0
### All
- Further harmonisation across languages
- Renamed all appropriate functions to start with 'calc_' prefix (e.g. calc_K0, calc_Ks, calc_pressure_correction)
- Moved to using temperature in Celcius (temp_c) as input to *all* functions, rather than sometimes temperature in Kelvin and other times temperature in Celcius

### Python
- Migrated calc_Ks -> calc_all_Ks. calc_Ks now calculates specified K*'s, while calc_all_Ks does all of them.
- All K functions now take three input arguments (coefficients, temp_c, and sal) instead of five (previously: p, temp_k, log(temp_k), sal, and sqrt(sal)).
- prescorr -> calc_pressure_correction
- Added wrapper function to calculate seawater correction using Kgen
- Ionic strength is now in a single function and called where needed (and available to call as needed)
- Docstring improvements/corrections

### R
- Migrated all relevant things to start with 'calc_' instead of 'fn_' (e.g. calc_K1 instead of fn_K1). These are not exported so have no impact on functionality.
- calc_Ks -> calc_all_Ks, calc_all_Ks gives all the K*'s, and calc_Ks must have the names of requested K*'s specified
- Added wrapper function to calculate seawater correction using Kgen

### Matlab
- Renaming parameters for consistency with other languages (no impact on functionality as inputs are positional not keywords)

## 0.2.0

- Initial release across all languages.
- Harmonised function and parameter names across languages.
- All comparison checks passing.
