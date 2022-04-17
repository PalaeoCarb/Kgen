# Kgen
Coefficients for consistently calculating and pressure correcting Ks for carbon calculation.

### Tests

[![Check K values - Matlab](https://github.com/PalaeoCarb/Kgen/workflows/Check%20K%20values%20-%20Matlab/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/matlab-tests.yml)
[![Check K values - Python](https://github.com/PalaeoCarb/Kgen/workflows/Check%20K%20values%20-%20Python/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/python-tests.yml)
[![Check K values - R](https://github.com/PalaeoCarb/Kgen/workflows/Check%20K%20values%20-%20R/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/r-tests.yml)

[![Crosscheck Methods](https://github.com/PalaeoCarb/Kgen/workflows/Crosscheck%20Methods/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/crosscheck.yml)

## Availability
- **Python** via the 'Kgen' python package [![PyPI version](https://badge.fury.io/py/Kgen.svg)](https://badge.fury.io/py/Kgen)

- **R**: Download the Kgen R package directly from this repository with devtools `devtools::install_github('PalaeoCarb/Kgen/r')`

## How this is intended to be used:

The coefficients and functions provided here may be directly imported by scripts used for calculating carbon chemistry of seawater.
The hope is to unify the outputs of these scripts by ensuring that they are using the same underlying parameters.

Eventually, we hope these constants will be implemented in:
- cbsyst (Python)
- csys/BuCC (Matlab)
- seacarb(?)/seacarbx (R)
