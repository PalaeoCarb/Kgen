---
layout: default
parent: Use Kgen
title: Matlab
permalink: use_kgen/matlab
---

# Matlab

Documentation to start using Kgen in Matlab.

## Installation

Simplest:
Download the code from the [Matlab file exchange](https://uk.mathworks.com/matlabcentral/fileexchange/126170-kgen) and install

If using git:
```
git init
git remote add origin https://github.com/PalaeoCarb/Kgen
git fetch
git checkout main
```

If not using git, but you require the code files:
- Navigate to the [GitHub repository](https://github.com/PalaeoCarb/Kgen/)
- Click the green Code button
- Download ZIP
- Extract the ZIP to the chosen location

Using either of the latter methods, you must then add the [matlab folder](./../../matlab/) to the path in matlab, by right clicking and chosing Add To Path -> Selected Folders.

## Getting Started
The implementation in Matlab is different to other languages in this repository due to Matlab restrictions of one external function per file, and lack of package manager. To have a similar interface for the various languages, functions have been packaged as static methods of a class. If you're unfamiliar with object oriented programming, what that means is the functions have been collected into a single file by giving them a namespace (kgen_static).

Once the +kgen folder is on the path, there are four important functions that will be available.
`calc_Ks` for returning a some or all K*'s, `calc_K` for returning a single K*, `calc_pressure_correction` for calculating the effect of pressure on equilibrium constants, and `calc_seawater_correction` for calculating the adjustment necessary for different seawater magnesium and calcium concentrations.

All functions use the new [Matlab keyword argument syntax](https://uk.mathworks.com/help/matlab/matlab_prog/namevalue-in-function-calls.html) (available from Matlab 2021a). These allow the inputs to be given in any order, and to be labelled with keywords. The syntax in Matlab can then exactly match the syntax for Python and R implementations.
 
The general pattern is as follows:
```matlab
kgen.kgen_static.calc_K(name="name",temp_c=[temperature],sal=[salinity],p_bar=[pressure],magnesium=[magnesium],calcium=[calcium]);

kgen.kgen_static.calc_Ks(names=["names"],temp_c=[temperature],sal=[salinity],p_bar=[pressure],magnesium=[magnesium],calicum=[calcium]);

kgen.kgen_static.calc_Ks(temp_c=[temperature],sal=[salinity],p_bar=[pressure],magnesium=[magnesium],calcium=[calcium]);
```
For example:
```matlab
kgen.kgen_static.calculate_K(name="K1",temp_c=20,sal=35,p_bar=0,magnesium=0.05,calcium=0.01); % Gives K*1 at the chosen conditions

kgen.kgen_static.calculate_Ks(names=["K1","K2"],temp_c=20,sal=35,p_bar=0,magnesium=0.05,calcium=0.01); % Gives both K*1 and K*2 at the chosen conditions

kgen.kgen_static.calculate_Ks(temp_c=20,sal=35,p_bar=0,magnesium=0.05,calcium=0.01); % Gives all K*'s at the chosen conditions
```

Where `temperature` is the temperature in degrees Celsius, `salinity` is the salinity in PSU, `pressure` is the pressure in bars, and `magnesium` and `calcium` are the magnesium and calcium concentrations in average seawater in mol/kg. `name` is the name of the equilibrium constant, either as a string or an array of strings. The options are: `K0`, `K1`, `K2`, `KB`, `KW`, `KS`, `KF`, `KspC`, `KspA`, `KP1`, `KP2`, `KP3`, or `KSi`.

The inputs to these parameters may be single numbers or arrays of numbers, but where they are arrays the shape of the arrays must be the same.

If any value is not specified, or is `NaN`, it defaults back to 'standard' conditions of 25&deg;Celcius, 35 PSU, and 0 bar, with Mg and Ca at modern ocean concentrations (0.0528171 and 0.0102821 mol/kg).

## Correction Factors
### Pressure
The pressure correction works as follows:
```matlab
kgen.kgen_static.calc_pressure_correction(name=name,temp_c=temperature,p_bar=pressure);

kgen.kgen_static.calc_pressure_correction(name="K1",temp_c=25,p_bar=10);
```
Where `name` is a string describing which K value is requested (e.g. `K1` or `K2`), `temperature` is the temperature in degrees Celsius, and `pressure` is the pressure in bars. `temperature` and `pressure` can be arrays, so long as they are of equivalent length,`name` must be a single string.

### Seawater Composition (Magnesium and Calcium Concentrations)
There are three ways to calculate the seawater composition correction factor, with the general calling pattern of:
```matlab
calculate_seawater_correction([names],[temperature],[salinity],[magensium],[calcium],method)
```
Where `names` is an array of strings containing equilibrium constant names from the options listed above, `temperature` is the temperature in degrees Celcius, `salinity` is the salinity in PSU, and `magnesium` and `calcium` are the magnesium and calcium concentrations given in mol/kg. `method` is a single string which can be `Matlab_Polynomial`, `MyAMI_Polynomial`, or `MyAMI` (the default).

1. Directly within Matlab using a polynomial approximation
```matlab
kgen.kgen_static.calc_seawater_correction(names=[names],temp_c=[temperature],sal=[salinity],magnesium=[magnesium],calcium=[calcium],method="Matlab_Polynomial")

kgen.kgen_static.calc_seawater_correction(names=["K1,K2"],temp_c=20,sal=35,magnesium=0.05,calcium=0.02,method="Matlab_Polynomial")

```
This has no external dependencies and uses coefficients from a polynomial fit performed in python to calculate equilibrium constrant correction factors for different seawater calcium and magnesium concentrations.

2. Using Matlab to call a Python routine for polynomial approximation
3. Using Matlab to call a Python routine for full MyAMI calculation

Both of the other options require an installation of python, which will be run through Matlab. If using Windows, the procedure is as follows:
- Download python for Windows from [python.org](https://www.python.org/downloads/). Only certain versions are compatible with Matlab - we recommend python version 3.9.
- Use your terminal to create a virtual environment
```
python3 -m venv .environment
```
- Activate the virtual environment
```
.environment\Scripts\activate
```
- Install the dependencies using the requirements.txt file in the python folder of this repository
```
pip install -r requirements.txt
```
- Open Matlab and set the python interpreter to the virtual environment you just created
```
pe = pyenv(Version=".environment/bin/python")
```

If all these steps are successful, Matlab should now be able to call python code. This will allow you to run:
```matlab
kgen.kgen_static.calc_seawater_correction(names=[names],temp_c=[temperature],sal=[salinity],magnesium=[magnesium],calcium=[calcium],method="MyAMI_Polynomial")
kgen.kgen_static.calc_seawater_correction(names=["K1","K2"],temp_c=20,sal=35,magnesium=0.05,calcium=0.02,method="MyAMI_Polynomial")

kgen.kgen_static.calc_seawater_correction(names=[names],temp_c=[temperature],sal=[salinity],magnesium=[magnesium],calcium=[calcium],method="MyAMI")
kgen.kgen_static.calc_seawater_correction(names=["K1","K2"],temp_c=20,sal=35,magnesium=0.05,calcium=0.02,method="MyAMI")
```

`MyAMI_Polynomial` runs the same polynomial approximation as is available in Matlab, but through python. `MyAMI` runs the full calculation, and is the default behaviour.