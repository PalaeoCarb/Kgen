import json
import os
import pkg_resources as pkgrs

coef_path = pkgrs.resource_filename('kgen', 'coefficients')

with open(os.path.join(coef_path, 'K_calculation.json'), 'r') as f:
    K_coefs = json.load(f)['coefficients']

with open(os.path.join(coef_path, 'K_pressure_correction.json'), 'r') as f:
    K_presscorr_coefs = json.load(f)['coefficients']
