# Kgen
Coefficients for consistently calculating and pressure correcting Ks for carbon calculation.

## How this is intended to be used:

The coefficients and functions provided here may be directly imported by scripts used for calculating carbon chemistry of seawater.
The hope is to unify the outputs of these scripts by ensuring that they are using the same underlying parameters.

Eventually, we hope these constants will be implemented in:
- cbsyst (Python)
- csys/BuCC (Matlab)
- seacarb(?)/seacarbx (R)