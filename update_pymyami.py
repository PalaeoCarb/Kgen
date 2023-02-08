"""
Script that updates all resources and version numbers in Python, R and Matlab to ensure that they are in sync.
"""
import urllib.request
from glob import glob

# specify which pymyami version to use throughout Kgen
pymyami_version = '2.0.1'

# path to file containing polynomial coefficients
polynomial_coefficient_path = f'https://raw.githubusercontent.com/PalaeoCarb/pymyami/{pymyami_version}/pymyami/parameters/Fcorr_approx.json'


###########################
# Python
###########################

# update requirements.txt
with open('python/requirements.txt', 'r+') as f:
    requires = f.readlines()

    for i, req in enumerate(requires):
        if 'pymyami' in req:
            requires[i] = f"pymyami=={pymyami_version}\n"
    
    f.seek(0)
    f.write(''.join(requires))
    f.truncate()

###########################
# Matlab
###########################

# update polynomial_coefficients.json

urllib.request.urlretrieve(polynomial_coefficient_path, "matlab/polynomial_coefficients.json")

###########################
# R
###########################

# update polynomial_coefficients.json
urllib.request.urlretrieve(polynomial_coefficient_path, "r/inst/coefficients/polynomial_coefficients.json")

# update pymyami version
with open('r/R/pymyami.R', 'r+') as f:
    lines = f.readlines()
    
    for i, line in enumerate(lines):
        if 'pymyami_version <-' in line:
            lines[i] = f'pymyami_version <- "{pymyami_version}"\n'

    f.seek(0)
    f.write(''.join(lines))
    f.truncate()

# update pymyami version in Github Actions

actions = glob('.github/workflows/*.yml')

new_install = f'reticulate::py_install("pymyami=={pymyami_version}", envname = "r-reticulate", pip=T)'

for action in actions:
    with open(action, 'r+') as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if 'reticulate::py_install("pymyami' in line:
                lines[i] = ' ' * line.find('reticulate') + new_install + '\n'
        f.seek(0)
        f.write(''.join(lines))
        f.truncate()