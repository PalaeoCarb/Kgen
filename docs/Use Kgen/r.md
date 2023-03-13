---
layout: default
parent: Use Kgen
title: R
permalink: use_kgen/r
---

# R

Documentation to start using Kgen in R.
{: .fs-6 .fw-300 }

[![CRAN status](https://www.r-pkg.org/badges/version/Kgen)](https://CRAN.R-project.org/package=Kgen)
[![CRANLOGS downloads](https://cranlogs.r-pkg.org/badges/Kgen)](https://cran.r-project.org/package=Kgen)

## Installation

Kgen is available for installation from CRAN:
`install.packages('Kgen')`
or directly from Github using remotes/devtools: 
`devtools::install_github('PalaeoCarb/Kgen/r')`

This will install Kgen and its dependencies.

## Getting Started

Two functions are exported, `calc_Ks()` for returning all available Ks, and `calc_pressure_correction()` for returning a K-specific pressure correction factor. To allow for the best possible cross-compatibility between languages, Kgen for R relies on `pymyami` to calculate [Mg] and [Ca] correction factors. Upon first use, Kgen will ask to automatically install a local version of `r-Miniconda` along with `pymyami`. This step should not require more than 5 minutes on modern systems. If you prefer to install r-Miniconda to a specific path on your system, stop the installer and install r-Miniconda manually using [reticulate](https://rstudio.github.io/reticulate/). 

```R
library('Kgen')

calc_Ks(ks, temp_c, sal, p_bar, magnesium, calcium, sulphate, fluorine, method)

calc_pressure_correction(k, temp_c, p_bar)
```

## Arguments

- **ks**: Character vector of coefficients, i.e., K<sub>0</sub>, K<sub>1</sub>, K<sub>2</sub>, K<sub>W</sub>, K<sub>B</sub>, K<sub>S</sub>, K<sub>spA</sub>, K<sub>spC</sub>, K<sub>P1</sub>, K<sub>P2</sub>, K<sub>P3</sub>, K<sub>Si</sub>, and K<sub>F</sub> if `NULL` all coefficients will be calculated.

- **temp_c**: Temperature in degree Celsius

- **sal**: Salinity

- **p_bar**: Pressure in bar

- **magnesium**: Magnesium concentration in mol kg<sup>-1</sup> 

- **calcium**: Calcium concentration in mol kg<sup>-1</sup> 

- **sulphate**: Sulphate concentration in mol/kgsw. Calculated from salinity if not given.
- 
- **fluorine**: Fluorine concentration in mol/kgsw. Calculated from salinity if not given.

- **method**: Options: `R_Polynomial`, `MyAMI_Polynomial` , `MyAMI` (defaults to "MyAMI"). If set to `MyAMI`, Kgen will calculate Mg and Ca correction factors directly using `pymyami`. If set to `MyAMI_Polynomial` Kgen will approximate the correction factors using a polynomial approximation in `pymyami`. If set to `R_Polynomial` Kgen will approximate the correction factors using a built in polynomial approximation function. 

The inputs to **temp_c**, **p_bar**, **sal**, **magnesium**, **calcium**, **sulphate**, and **fluorine** may be single numbers or numeric vectors, but where they are vectors, the lengt of the vectors must be the same. If any value is not specified, it defaults back to 'standard' conditions of temp_c = 25 °C, sal = 35, and p_bar = 0 bar, with Mg and Ca at modern ocean concentrations (0.0528171 and 0.0102821 mol kg<sup>-1</sup>).

## Details
For ease of use, Kgen will automatically install an `r-Miniconda` version in an isolated namespace location, required to run `pymyami` in R upon the first time `calc_Ks()`is called. This installation requires minimum disk space (~400 MB) and will not interfere with other Python versions on the operating system. However, if you prefer to install r-Miniconda to a specific path on your system (not recommended), install r-Miniconda manually using [reticulate](https://rstudio.github.io/reticulate/) before starting Kgen. When updated to a newer package version, Kgen ay ask the user to also perform a version update of pymyami. This is done to ensure that the version of pymyami remains constant between Kgen in R, Python, and Matlab.

Kgen installation and operation example:

```R
# Recommended installation through CRAN
> install.packages('Kgen')

# Load library
> library('Kgen')

# Test coefficient calculation using default values
> calc_Ks('K0')

[1] "Kgen requires r-Miniconda, which appears to not exist on your system."
Would you like to install it now? (Yes/no/abbrechen) 

# Confirm installation
> yes

> calc_Ks('K0')
[1] 0.02839188
```

## See also
Refer to [pyMyAMI on PyPi](https://pypi.org/project/pymyami/) to learn how Mg and Ca concentration factors are calculated.  Refer to [Reticulate](https://rstudio.github.io/reticulate/index.html) to learn more about how the Python integration in Kgen for R works.

