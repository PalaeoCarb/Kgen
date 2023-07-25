"""
Functions for calculating and pressure correcting equilibrium constants using the coefficients in .json files within the 'coefficients' folder.

All functional forms are from Dickson, Sabine and Christian, 2007.

TODO: Think about pH scales!
"""
import numpy as np
from .coefs import K_coefs, K_presscorr_coefs
from pymyami import calculate_seawater_correction, approximate_seawater_correction

def fn_K1K2(p, TK, lnTK, S, sqrtS):
    """Calculate K1 or K2 from given parameters

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
        (p[0] + p[1] * sqrtS + p[2] * S) + 
        (
            p[3] +
            p[4] * sqrtS +
            p[5] * S +
            p[6] * S * sqrtS +
            p[7] * S * S
        ) / TK +
        (p[8] + p[9] * sqrtS + p[10] * S) * lnTK +
        p[11] * sqrtS * TK
    )
    
def fn_K0(p, TK, lnTK, S, sqrtS):
    """Calculate K0 from given parameters.

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
        K0 on XXXXX pH scale.
    """
    return np.exp(
        p[0] +
        p[1] * 100 / TK +
        p[2] * np.log(TK / 100) +
        S * (p[3] + p[4] * TK / 100 + p[5] * (TK / 100) * (TK / 100))
    )

def fn_KS(p, TK, lnTK, S, sqrtS):
    Istr = (
        19.924 * S / (1000 - 1.005 * S)
    )
    # Ionic strength after Dickson 1990a; see Dickson et al 2007
    
    return np.exp(
        p[0]
        + p[1] / TK
        + p[2] * lnTK
        + np.sqrt(Istr) * (p[3] / TK + p[4] + p[5] * lnTK)
        + Istr * (p[6] / TK + p[7] + p[8] * lnTK)
        + p[9] / TK * Istr * np.sqrt(Istr)
        + p[10] / TK * Istr ** 2
        + np.log(1 - 0.001005 * S)
    )
    
def fn_Ksp(p, TK, lnTK, S, sqrtS):
    """Calculate Ksp from given parameters

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

def fn_KP3(p, TK, lnTK, S, sqrtS):
    """Calculate KP3(s) from given parameters
    
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
        KP3 on XXXXX pH scale.
    """

    return np.exp(
        p[0] / TK
        + p[1]
        + (p[2] / TK + p[3]) * sqrtS
        + (p[4] / TK + p[5]) * S
    )

def fn_KSi(p, TK, lnTK, S, sqrtS):
    """Calculate KSi from given parameters

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

def fn_KF(p, TK, lnTK, S, sqrtS):
    """Calculate KSi from given parameters

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
        KF on XXXXX pH scale.
    """
    return np.exp(
        p[0] / TK + 
        p[1] + 
        p[2] * sqrtS
    )

K_fns = {
    "K0": fn_K0,
    "K1": fn_K1K2,
    "K2": fn_K1K2,
    "KW": fn_KW,
    "KB": fn_KB,
    "KS": fn_KS,
    "KspA": fn_Ksp,
    "KspC": fn_Ksp,
    "KP1": fn_KP,
    "KP2": fn_KP,
    "KP3": fn_KP3,
    "KSi": fn_KSi,
    "KF": fn_KF
}    

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

def calc_sulphate(sal):
    """
    Calculate total Sulphur in mol/kg-SW- lifted directly from CO2SYS.m

    From Dickson et al., 2007, Table 2
    Note: sal / 1.80655 = Chlorinity
    """
    return 0.14 * sal / 1.80655 / 96.062 # mol/kg-SW


def calc_fluorine(sal):
    """
    Calculate total Fluorine in mol/kg-SW

    From Dickson et al., 2007, Table 2
    Note: sal / 1.80655 = Chlorinity
    """
    return 6.7e-5 * sal / 1.80655 / 18.9984 # mol/kg-SW

def calc_K(K, temp_c=25., sal=35., p_bar=None, magnesium=None, calcium=None, sulphate=None, fluorine=None, MyAMI_mode='calculate'):
    """
    Calculate a specified stoichiometric equilibrium constant at given
    temperature, salinity and pressure.

    TODO: document pH scales.

    Parameters
    ----------
    k : string
        The name of the K you want to calculate, e.g. 'K1'
    temp_c : array-like
        Temperature in Celcius
    sal : array-like
        Salinity in PSU
    p_bar : array-like
        Pressure in bar
    magnesium : array-like
        magnesium concentration in mol/kgsw. If None, modern is assumed
        (0.0528171). Should be the *average* magnesium concentration in
        seawater - a salinity correction is then applied to calculate
        the magnesium concentration in the sample. Used to correct the Ks
        using MyAMI.
    calcium : array-like
        calcium concentration in mol/kgsw. If None, modern is assumed
        (0.0102821). Should be the *average* calcium concentration in
        seawater - a salinity correction is then applied to calculate
        the magnesium concentration in the sample. Used to correct the Ks
        using MyAMI.
    sulphate : array-like
        Total sulphate in mol/kgsw. Calculated from salinity if not
        given.
    fluorine : array-like
        Total fluorine in mol/kgsw. Calculated from salinity if not
        given.
    MyAMI_mode : str
        Either 'calculate' or 'approximate'. In the former case,
        the full MyAMI model is run to calculate the correction
        factor for the Ks. In the latter, a polynomial function is
        used to approximate the correction factor. The latter is faster,
        though marginally less accurate.

    Returns
    -------
    array-like
        The specified K at the given conditions.
    """
    if K not in K_fns:
        raise ValueError(f'{K} is not valid. Should be one of {K_fns.keys}')
    
    TK = temp_c + 273.15
    lnTK = np.log(TK)
    S = sal
    sqrtS = S**0.5

    K = K_fns[K](p=K_coefs[K], TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)

    if p_bar is not None:
        if fluorine is None:
            fluorine = calc_fluorine(sal=sal)
        if sulphate is None:
            sulphate = calc_sulphate(sal=sal)
        
        KS_surf = K_fns['KS'](p=K_coefs['KS'], TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)
        KS_deep = KS_surf * prescorr(p=K_presscorr_coefs['KS'], P=p_bar, TC=temp_c)
        KF_surf = K_fns['KF'](p=K_coefs['KF'], TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)
        KF_deep = KF_surf * prescorr(p=K_presscorr_coefs['KF'], P=p_bar, TC=temp_c)
        
        tot_to_sws_surface = (1 + sulphate / KS_surf) / (1 + sulphate / KS_surf + fluorine / KF_surf)  # convert from TOT to SWS before pressure correction
        sws_to_tot_deep = (1 + sulphate / KS_deep + fluorine / KF_deep) / (1 + sulphate / KS_deep)  # convert from SWS to TOT after pressure correction
        
        K *= tot_to_sws_surface * prescorr(p=K_presscorr_coefs[K], P=p_bar, TC=temp_c) * sws_to_tot_deep
    
    if magnesium is not None or calcium is not None:
        if calcium is None:
            calcium = 0.0102821
        if magnesium is None:
            magnesium = 0.0528171
        if MyAMI_mode == 'calculate':
            Fcorr = calculate_seawater_correction(Sal=sal, TempC=temp_c, Mg=magnesium, Ca=calcium)
        else:
            Fcorr = approximate_seawater_correction(Sal=sal, TempC=temp_c, Mg=magnesium, Ca=calcium)
        if K in Fcorr:
            K *= Fcorr[K]
    
    return K

def calc_Ks(K_list, temp_c=25., sal=35., p_bar=None, magnesium=None, calcium=None, sulphate=None, fluorine=None, MyAMI_mode='calculate'):
    """
    Calculate specified stoichiometric equilibrium constants at given
    temperature, salinity and pressure.

    TODO: document pH scales.

    Parameters
    ----------
    K_list : array-like
        List of Ks to calculate
    temp_c : array-like
        Temperature in Celcius
    sal : array-like
        Salinity in PSU
    p_bar : array-like
        Pressure in bar
    magnesium : array-like
        Magnesium concentration in mol/kgsw. If None, modern is assumed
        (0.0528171). Should be the *average* magnesium concentration in
        seawater - a salinity correction is then applied to calculate
        the magnesium concentration in the sample. Used to correct the Ks
        using MyAMI.
    calcium : array-like
        Calcium concentration in mol/kgsw. If None, modern is assumed
        (0.0102821). Should be the *average* calcium concentration in
        seawater - a salinity correction is then applied to calculate
        the magnesium concentration in the sample. Used to correct the Ks
        using MyAMI.
    sulphate : array-like
        Total sulphate in mol/kgsw. Calculated from salinity if not
        given.
    fluorine : array-like
        Total fluorine in mol/kgsw. Calculated from salinity if not
        given.
    MyAMI_mode : str
        Either 'calculate' or 'approximate'. In the former case,
        the full MyAMI model is run to calculate the correction
        factor for the Ks. In the latter, a polynomial function is
        used to approximate the correction factor. The latter is faster,
        though marginally less accurate.

    Returns
    -------
    dict
        Containing calculated Ks.
    """
    if K_list is None:
        K_list = K_fns.keys()

    TK = temp_c + 273.15
    lnTK = np.log(TK)
    S = sal
    sqrtS = S**0.5

    Ks = {}
    for k in K_list:
        Ks[k] = K_fns[k](p=K_coefs[k], TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)

        if p_bar is not None:
            if fluorine is None:
                fluorine = calc_fluorine(sal=sal)
            if sulphate is None:
                sulphate = calc_sulphate(sal=sal)
            
            KS_surf = K_fns['KS'](p=K_coefs['KS'], TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)
            KS_deep = KS_surf * prescorr(p=K_presscorr_coefs['KS'], P=p_bar, TC=temp_c)
            KF_surf = K_fns['KF'](p=K_coefs['KF'], TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)
            KF_deep = KF_surf * prescorr(p=K_presscorr_coefs['KF'], P=p_bar, TC=temp_c)
            
            tot_to_sws_surface = (1 + sulphate / KS_surf) / (1 + sulphate / KS_surf + fluorine / KF_surf)  # convert from TOT to SWS before pressure correction
            sws_to_tot_deep = (1 + sulphate / KS_deep + fluorine / KF_deep) / (1 + sulphate / KS_deep)  # convert from SWS to TOT after pressure correction

            if k in K_presscorr_coefs:
                Ks[k] *= tot_to_sws_surface * prescorr(p=K_presscorr_coefs[k], P=p_bar, TC=temp_c) * sws_to_tot_deep
    
    if magnesium is not None or calcium is not None:
        if calcium is None:
            calcium = 0.0102821
        if magnesium is None:
            magnesium = 0.0528171
        if MyAMI_mode == 'calculate':
            Fcorr = calculate_seawater_correction(Sal=sal, TempC=temp_c, Mg=magnesium, Ca=calcium)
        else:
            Fcorr = approximate_seawater_correction(Sal=sal, TempC=temp_c, Mg=magnesium, Ca=calcium)
        for k, f in Fcorr.items():
            if k in Ks:
                Ks[k] *= f
    
    return Ks

def calc_all_Ks(temp_c=25., sal=35., p_bar=None, magnesium=None, calcium=None, sulphate=None, fluorine=None, MyAMI_mode='calculate'):
    """
    Calculate all stoichiometric equilibrium constants at given
    temperature, salinity and pressure.

    TODO: document pH scales.

    Parameters
    ----------
    temp_c : array-like
        Temperature in Celcius
    sal : array-like
        Salinity in PSU
    p_bar : array-like
        Pressure in bar
    magnesium : array-like
        Magnesium concentration in mol/kgsw. If None, modern is assumed
        (0.0528171). Should be the *average* magnesium concentration in
        seawater - a salinity correction is then applied to calculate
        the magnesium concentration in the sample. Used to correct the Ks
        using MyAMI.
    calcium : array-like
        Calcium concentration in mol/kgsw. If None, modern is assumed
        (0.0102821). Should be the *average* calcium concentration in
        seawater - a salinity correction is then applied to calculate
        the magnesium concentration in the sample. Used to correct the Ks
        using MyAMI.
    sulphate : array-like
        Total sulphate in mol/kgsw. Calculated from salinity if not
        given.
    fluorine : array-like
        Total fluorine in mol/kgsw. Calculated from salinity if not
        given.
    MyAMI_mode : str
        Either 'calculate' or 'approximate'. In the former case,
        the full MyAMI model is run to calculate the correction
        factor for the Ks. In the latter, a polynomial function is
        used to approximate the correction factor. The latter is faster,
        though marginally less accurate.

    Returns
    -------
    dict
        Containing calculated Ks.
    """
    K_list = K_fns.keys()
    Ks = calc_Ks(K_list, temp_c=temp_c, sal=sal, p_bar=p_bar, magnesium=magnesium, calcium=calcium, sulphate=sulphate, fluorine=fluorine, MyAMI_mode=MyAMI_mode)


    return Ks