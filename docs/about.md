---
layout: default
title: About Kgen
nav_order: 2
permalink: /about
---

## What is Kgen?

**Kgen** provides a uniform and internally-consistent way of calculating stoichiometric equilibrium constants (Ks) in modern and palaeo seawater as a function of temperature, salinity, pressure and the concentration of Mg and Ca, using Matlab, Python, and R.

### Why does Kgen exist?

>*Determining the 'best' way to calculate Ks is not straightforward, and it is very easy to introduce typos and errors when manually implementing K calculation. **Kgen** solves this by providing an open-source, internally consistent way to calculate Ks across multiple languages.*

There are multiple tools available for calculating the speciation of carbon in seawater, implemented across multiple platforms and languages. These are used to calculate the state of carbon in modern seawater, and incorporated into routines used to construct records of carbon in palaeo-seawater by integrating proxy records. All of these approaches rely on Ks, which describe the dissociation of weak acids and bases in seawater as a function of pH.

The history of calculating seawater Ks is long and tortuous, plagued by generations of typos and inconsistencies. These have been gradually corrected over time, but these corrections are often done in the back-end of manually-maintained code repositories, where it is difficult to keep track of what has changed when.

This presents newcomers to the field seeking to calculate Ks with a daunting array of options and difficulties. How do they calculate Ks in seawater, and how do they know if their calculations are correct? 

This issue has been largely solved in modern seawater by publications such as the `Guide to Best Practices for Ocean CO<sub>2</sub> Measurement' ([Dickson, Sabine and Christian, 2007](https://cdiac.ess-dive.lbl.gov/ftp/oceans/Handbook_2007/Guide_all_in_one.pdf)), which provides a clear and concise description of K calculation along with 'check values' to confirm your implementation of them.

This issue is more complex in palaeo-seawater, where secular changes in seawater chemistry require the modification of Ks to account for these changes. This was elegantly accomplished using the MyAMI ion interaction model ([Hain et al., 2015](https://doi.org/10.1002/2014GB004986)), although initial debate over some parameters in the model, alongside errors in the K 'look up table' provided in the initial publication further muddied the waters here.

With Kgen, we aim to transparently address all these uncertainties, and present a single reference implementation for K calculation that can be used across multiple platforms and languages.

### What does Kgen do?

**Kgen** provides a single function (`calc_Ks`) in Matlab, Python, and R, which takes the temperature, salinity, pressure, [Mg] and [Ca] concentrations, and returns K<sub>0</sub>, K<sub>1</sub>, K<sub>2</sub>, K<sub>W</sub>, K<sub>B</sub>, K<sub>S</sub>, K<sub>spA</sub>, K<sub>spC</sub>, K<sub>P1</sub>, K<sub>P2</sub>, K<sub>P3</sub>, K<sub>Si</sub>, and K<sub>F</sub> at the specified conditions.
### How does Kgen do this?

For modern seawater, we use the reference formulae for K calculation and pressure corrections in [Dickson, Sabine and Christian (2007)](https://cdiac.ess-dive.lbl.gov/ftp/oceans/Handbook_2007/Guide_all_in_one.pdf). These functions have been manually implemented in each language, but all use a shared database of coefficients within these functions, ensuring that the Ks are consistent across all languages.

For Mg and Ca adjustment, we use a modified version of the MyAMI ion interaction model ([Hain et al., 2015](https://doi.org/10.1002/2014GB004986)), which is available as a standalone Python package [pymyami](https://github.com/PalaeoCarb/pymyami). This modification of MyAMI brings a number of improvements over the origina, most notably calculationg speed (2-4 orders of magnitude faster). For a full account of these differences, see the [MyAMI GitHub page](https://github.com/PalaeoCarb/MyAMI).

For cases where calculation speed is of particular concern, we also provide a polynomial approximation of the K correction factors calculated by MyAMI (accurate to ~0.25%), which can be used instead of the full MyAMI calculation.

Python and R directly use the [pymyami](https://github.com/PalaeoCarb/pymyami) package to correct Ks for Mg and Ca, and can use either the direct calculation method or the polynomial approximation. Matlab can only use the polynomial approximation.

### How do we ensure that the Ks are correct?

Kgen conducts a number of automated tests whenever the underlying code is changed, which ensure the long-term consistency and stability of the calculated values:

1. Calculated Ks and pressure correction factors for modern seawater are checked against the nominal values provided in [Dickson, Sabine and Christian (2007)](https://cdiac.ess-dive.lbl.gov/ftp/oceans/Handbook_2007/Guide_all_in_one.pdf).

[![Check K values - Matlab](https://github.com/PalaeoCarb/Kgen/workflows/Check%20K%20values%20-%20Matlab/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/matlab-tests.yml)
[![Check K values - Python](https://github.com/PalaeoCarb/Kgen/workflows/Check%20K%20values%20-%20Python/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/python-tests.yml)
[![Check K values - R](https://github.com/PalaeoCarb/Kgen/workflows/Check%20K%20values%20-%20R/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/r-tests.yml)

2. MyAMI correction factors for seawater Mg and Ca produced by the [pymyami](https://github.com/PalaeoCarb/pymyami) package are checked against values produced by the original model of [Hain et al., (2015)](https://doi.org/10.1002/2014GB004986), with modifications after [Zeebe & Tyrrel (2018)]( https://doi.org/10.1002/2017GB005786).

[![Check MyAMI Performance](https://github.com/PalaeoCarb/pymyami/workflows/Check%20MyAMI%20Performance/badge.svg)](https://github.com/PalaeoCarb/MyAMI/actions/workflows/test-myami.yml)

3. To ensure consistency between languages, we calculate Ks across the complete valid input range of temperature, salinity, pressure, Mg and Ca with each language, and conduct an inter-comparison between the Ks calculated by each language.

[![Crosscheck Methods](https://github.com/PalaeoCarb/Kgen/workflows/Crosscheck%20Methods/badge.svg)](https://github.com/PalaeoCarb/Kgen/actions/workflows/crosscheck.yml)

### A note on pH Scales

All the Ks calculated by Kgen are on the **Total** pH scale, assuming modern ocean SO<sub>4</sub> concentration.