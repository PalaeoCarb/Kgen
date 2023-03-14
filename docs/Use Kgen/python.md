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