---
layout: default
parent: Use Kgen
title: R
permalink: use_kgen/r
---

# R

Documentation to start using Kgen in R.
{: .fs-6 .fw-300 }


## Installation

Kgen is available for installation from CRAN:
`install.packages('Kgen')`
or directly from Github using remotes/devtools: 
`devtools::install_github('PalaeoCarb/Kgen/r')`

This will install Kgen and its dependencies.

## Getting Started

Two functions are available, `calc_Ks()` for returning all available Ks and `calc_K()` for returning a single K. To allow for the best possible cross-compatibility between languages, Kgen for R relies on `pymyami` to calculate [Mg] and [Ca] correction factors. Upon first use, Kgen will ask to automatically install a local version of `r-Miniconda` along with `pymyami`. This step should not require more than 5 minutes on modern systems.   

```R
library('Kgen')

calc_K(k, TC, S, Mg, Ca, P, MyAMI_calc, run_MyAMI)
calc_Ks(k_list, TC, S, Mg, Ca, P, MyAMI_calc)
```

## Arguments

- **k**: Coefficient to calculate, i.e., K<sub>0</sub>, K<sub>1</sub>, K<sub>2</sub>, K<sub>W</sub>, K<sub>B</sub>, K<sub>S</sub>, K<sub>spA</sub>, K<sub>spC</sub>, K<sub>P1</sub>, K<sub>P2</sub>, K<sub>P3</sub>, K<sub>Si</sub>, or K<sub>F</sub>

- **k_list**: List of coefficients, e.g.,  `list("K0", "K1")`, if no list is defined **k_list** will default to include all coefficients.

- **TC**: Temperature in degree Celsius

- **S**: Salinity in PSU

- **Mg**: Magnesium concentration in mol kg<sup>-1</sup> 

- **Ca**: Calcium concentration in mol kg<sup>-1</sup> 

- **P**: Pressure in bar

- **MyAMI_calc**: If set to `TRUE`, Kgen will calculate Mg and Ca correction factors directly using `pymyami`. If set to `FALSE` Kgen will approximate the correction factors using a polynomial approximation in `pymyami`. 

- **run_MyAMI**: Option in `calc_K()` specifying if `pymyami` is used to calculate or approximate Mg and Ca correction factors. Defaults to `TRUE` and should not be changed unless you know what you do. 

The inputs to **TC**, **S**, **Mg**, **Ca**, **Mg**, and **P** may be single numbers or arrays of numbers, but where they are arrays, the shape of the array must be the same. If any value is not specified, it defaults back to 'standard' conditions of 25 °C, 35 PSU, and 0 bar, with Mg and Ca at modern ocean concentrations (0.0528171 and 0.0102821 mol kg<sup>-1</sup>).

## Details
For ease of use, Kgen will automatically install an `r-Miniconda` version in an isolated namespace location, required to run `pymyami` in R upon the first time `calc_K()` or `calc_Ks()`is called. This installation requires minimum disk space (~400 MB) and will not interfere with other Python versions on the operating system. 

Kgen installation and operation example:

```R
# Recommended installation through CRAN
> install.packages('Kgen')

# Load library
> library('Kgen')

# Test coefficient calculation using default values
> calc_K('K0')

[1] "Kgen requires r-Miniconda, which appears to not exist on your system."
Would you like to install it now? (Yes/no/abbrechen) 

# Confirm installation
> yes

> calc_K('K0')
[1] 0.02839188
```

## See also
Refer to [pyMyAMI on PyPi](https://pypi.org/project/pymyami/) to learn how Mg and Ca concentration factors are calculated.  Refer to [Reticulate](https://rstudio.github.io/reticulate/index.html) to learn more about how the Python integration in Kgen for R works.

