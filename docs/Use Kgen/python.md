---
layout: default
parent: Use Kgen
title: Python
permalink: use_kgen/python
---

# Python

Documentation to start using Kgen in Python.
{: .fs-6 .fw-300 }


## Installation

<div align="right">
<a href="https://badge.fury.io/py/kgen"><img src="https://badge.fury.io/py/kgen.svg" alt="PyPI version" height="18"></a>
</div>

Kgen is available for installation from the PyPI package manager:

```bash
pip install Kgen
```

This will install Kgen and its dependencies, including `pymyami`.

## Getting Started

Two functions are available in Python, `calc_Ks` for returning all available Ks, and `calc_K` for returning a single K.
 
```python
from kgen import calc_Ks, calc_K

calc_Ks(TempC=20, Salinity=35, Pressure=0, Mg=0.3, Ca=None)
```

Where `TempC` is the temperature in degrees Celsius, `Salinity` is the salinity in PSU, `Pressure` is the pressure in bars, and `Mg` and `Ca` are the magnesium and calcium concentrations in average seawater in mol kg<sup>-1</sup>.

The inputs to these parameters may be single numbers or arrays of numbers, but where they are arrays the shape of the array must be the same.

If any value is not specified, or is `None`, it defaults back to 'standard' conditions of 25 Celcius, 35 PSU, and 0 bar, with Mg and Ca at modern ocean concentrations (0.0528171 and 0.0102821 mol kg<sup>-1</sup>).

You can specify whether to calculate Mg and Ca correction factors directly or use the polynomial approximation by specifying the `MyAMI_mode` parameter to either `'calculate'` or `'approximate'`.

## Using Kgen with PyCO2SYS

Kgen can also provide the equilibrium constants and other variables in the format and units required for further marine carbonate system calculations with [PyCO2SYS](https://PyCO2SYS.readthedocs.io).

```python
from kgen import calk_Ks_PyCO2SYS
import PyCO2SYS as pyco2

# First, use Kgen to calculate equilibrium constants etc.
kgen_constants = calc_Ks_PyCO2SYS(TempC=20, Salinity=35, Pressure=0, Mg=0.3, Ca=None)

# Then, put these into PyCO2SYS, along with whatever else you need, e.g.:
results = pyco2.sys(par1=2300, par2=2100, par1_type=1, par2_type=2, **kgen_constants)
# See the PyCO2SYS docs for an explanation of par1, par2 etc.
```

The arguments to `calc_Ks_PyCO2SYS` are identical to those for `calc_Ks` described above.

In the above code, PyCO2SYS will use the equilibrium constants and total salt concentrations calculated by Kgen for all its calculations, instead of evaluating them internally.

Note that `kgen_constants` includes the values provided to `calc_Ks_PyCO2SYS` (or the Kgen defaults if none provided) for temperature, salinity, pressure, pH scale, and total sulfate, fluoride and calcium, so these cannot be provided separately to `pyco2.sys()`.
