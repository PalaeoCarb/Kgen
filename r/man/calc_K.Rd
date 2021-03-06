% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{calc_K}
\alias{calc_K}
\title{Calculate a specified stoichiometric equilibrium constant at given temperature, salinity and pressure.}
\usage{
calc_K(
  k,
  TC = 25,
  S = 35,
  Mg = 0.0528171,
  Ca = 0.0102821,
  P = NULL,
  method = "MyAMI",
  Kcorrect = TRUE
)
}
\arguments{
\item{k}{K to be calculated}

\item{TC}{Temperature (Celsius)}

\item{S}{Salinity (PSU)}

\item{Mg}{Mg concentration in mol/kgsw. If None, modern is assumed (0.0528171). Should be the average Mg concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.}

\item{Ca}{Ca concentration in mol/kgsw. If None, modern is assumed (0.0102821). Should be the average Ca concentration in seawater - a salinity correction is then applied to calculate the Mg concentration in the sample.}

\item{P}{Pressure (Bar) (optional)}

\item{method}{Options: \code{R_Polynomial}, \code{MyAMI_Polynomial} , \code{MyAMI} (default = MyAMI).}

\item{Kcorrect}{TRUE = calculate corrections, FALSE = don't calculate corrections.}
}
\value{
Specified K at the given conditions
}
\description{
Calculate a specified stoichiometric equilibrium constant at given temperature, salinity and pressure.
}
