"""
Functions for calculating and pressure correcting equilibrium constants using the coefficients in .json files within the 'coefficients' folder.

All functional forms are from Dickson, Sabine and Christian, 2007.

TODO: Think about pH scales!
"""
import numpy as np

def fn_K1K2(p, TK, lnTK, S):
    """Calculate K1 or K2 from given parameters

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    lnTK : arra-ylike
        natural log of temperature in kelvin
    S : arry-like
        Salinity

    Returns
    -------
    array-like
        K1 or K2 on XXXXX pH scale.
    """
    
    return np.power(10, 
        p[0] +
        p[1] / TK +
        p[2] * lnTK +
        p[3] * S +
        p[4] * S * S
    )
    
def fn_KW(p, TK, lnTK, S, sqrtS):
    """Calculate KW from given parameters.

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    lnTK : arra-ylike
        natural log of temperature in kelvin
    S : arry-like
        Salinity
    sqrtS : array-like
        square root of salinity
        
    Returns
    -------
    array-like
        KW on XXXXX pH scale.
    """
    return np.exp(
        p[0] +
        p[1] / TK +
        p[2] * lnTK +
        + (p[3] / TK + p[4] + p[5] * lnTK) * sqrtS +
        p[6] * S
    )
    
def fn_KB(p, TK, lnTK, S, sqrtS):
    """Calculate KB from given parameters.

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    lnTK : array-like
        natural log of temperature in kelvin
    S : arry-like
        Salinity
    sqrtS : array-like
        square root of salinity
        
    Returns
    -------
    array-like
        KB on XXXXX pH scale.
    """
    return np.exp(
        (
            p[0] +
            p[1] * sqrtS +
            p[2] * S +
            p[3] * S * sqrtS +
            p[4] * S * S
        )
        / TK +
        (p[5] + p[6] * sqrtS + p[7] * S) +
        (p[8] + p[9] * sqrtS + p[10] * S) * lnTK +
        p[11] * sqrtS * TK
    )
    
def fn_K0(p, TK, S):
    """Calculate K0 from given parameters.

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    S : arry-like
        Salinity
            
    Returns
    -------
    array-like
        K0 on XXXXX pH scale.
    """
    return np.exp(
        p[0] +
        p[1] / TK +
        p[2] * np.log(TK / 100) +
        S * (p[3] - p[4] * TK + p[5] * TK * TK)
    )

def fn_KHSO4(p, TK, lnTK, S):
    Istr = (
        19.924 * S / (1000 - 1.005 * S)
    )
    # Ionic strength after Dickson 1990a; see Dickson et al 2007
    
    return np.exp(
        p[0]
        + p[1] / TK
        + p[2] * lnTK
        + np.sqrt(Istr)
        * (p[3] + p[4] / TK + p[5] * lnTK)
        + Istr
        * (p[6] + p[7] / TK + p[8] * lnTK)
        + p[9] / TK * Istr * np.sqrt(Istr)
        + p[10] / TK * Istr ** 2
        + np.log(1 - 0.001005 * S)
    )
    
def fn_Ksp(p, TK, S, sqrtS):
    """Calculate Ksp from given parameters

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    S : arry-like
        Salinity
    sqrtS : array-like
        square root of salinity

    Returns
    -------
    array-like
        KspA or KspC on XXXXX pH scale.
    """

    return np.power(
        10,
        (
            p[0] + 
            p[1] * TK +
            p[2] / TK +
            p[3] * np.log10(TK) +
            (p[4] + p[5] * TK + p[6] / TK) * sqrtS +
            p[7] * S +
            p[8] * S * sqrtS
        ),
    )

def fn_KP(p, TK, lnTK, S, sqrtS):
    """Calculate KP(s) from given parameters

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    lnTK : array-like
        natural log of temperature in kelvin
    S : arry-like
        Salinity
    sqrtS : array-like
        square root of salinity

    Returns
    -------
    array-like
        KP1, KP2 or KP3 on XXXXX pH scale.
    """

    return np.exp(
        p[0] / TK
        + p[1]
        + p[2] * lnTK
        + (p[3] / TK + p[4]) * sqrtS
        + (p[5] / TK + p[6]) * S
    )

def fn_KSi(p, TK, S):
    """Calculate KSi from given parameters

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    S : arry-like
        Salinity

    Returns
    -------
    array-like
        KSi on XXXXX pH scale.
    """

    Istr = 19.924 * S / (1000 - 1.005 * S)

    return np.exp(
        p[0] / TK + 
        p[1] +
        p[2] * np.log(TK) +
        (p[3] / TK + p[4]) * Istr ** 0.5 +
        (p[5] / TK + p[6]) * Istr +
        (p[7] / TK + p[8]) * Istr ** 2
    ) * (1 - 0.001005 * S)

def fn_KF(p, TK, S):
    """Calculate KSi from given parameters

    Parameters
    ----------
    p : array-like
        parameters for K calculation
    TK : array-like
        Temperature in Kelvin
    S : arry-like
        Salinity

    Returns
    -------
    array-like
        KF on XXXXX pH scale.
    """

    Istr = 19.924 * S / (1000 - 1.005 * S)

    return np.exp(p[0] / TK + p[1] + p[2] * Istr ** 0.5) * (1 - 0.001005 * S)

def prescorr(p, P, TC):
    """Calculate pressore correction factor for thermodynamic Ks.

    From Millero et al (2007, doi:10.1021/cr0503557)
    Eqns 38-40

    Usage:
    K_corr / K_orig = [output]
    Kcorr = [output] * K_orig

    Parameters
    ----------
    p : array-like
        parameters to calculate pressure correction factors (Kcorr).
    TC : array-like
        Temperature in Celcius
    S : arry-like
        Salinity
    """
    a0, a1, a2, b0, b1 = p
    dV = a0 + a1 * TC + a2 * TC ** 2
    dk = (b0 + b1 * TC)  # NB: there is a factor of 1000 in CO2sys, which has been incorporated into the coefficients for the function.    
    RT = 83.1451 * (TC + 273.15)
    return np.exp((-dV + 0.5 * dk * P) * P / RT)