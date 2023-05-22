from . import K_functions

kgen_to_PyCO2SYS = {
    "K0": "k_CO2",
    "K1": "k_carbonic_1",
    "K2": "k_carbonic_2",
    "KW": "k_water",
    "KB": "k_borate",
    "KS": "k_bisulfate",
    "KspA": "k_aragonite",
    "KspC": "k_calcite",
    "KP1": "k_phosphoric_1",
    "KP2": "k_phosphoric_2",
    "KP3": "k_phosphoric_3",
    "KSi": "k_silicate",
    "KF": "k_fluoride",
}


def calc_Ks_PyCO2SYS(**kwargs_calc_Ks):
    """
    Calculate all stoichiometric equilibrium constants at given
    temperature, salinity and pressure, with the output dict formatted
    ready to use with PyCO2SYS.

    Parameters
    ----------
    kwargs_calc_Ks
        The same set of kwargs as provided to `kgen.calc_Ks()`.

    Returns
    -------
    kgen_constants : dict
        Calculated Ks with the keys in the format required for PyCO2SYS,
        as well as the other relevant variables (temperature, pressure,
        salinity, pH scale and total salt concentrations).

        This can be provided to PyCO2SYS as follows:

            >>> results = pyco2.sys(**other_PyCO2SYS_kwargs, **kgen_constants)

        You then cannot provide the following kwargs within `other_PyCO2SYS_kwargs`
        (because they are already in `kgen_constants`):
            temperature, salinity, pressure, opt_pH_scale, total_fluoride,
            total_sulfate, total_calcium

        For more information on PyCO2SYS, see https://PyCO2SYS.readthedocs.io
    """
    # Set defaults, if not provided by the user
    if "temp_c" not in kwargs_calc_Ks:
        kwargs_calc_Ks["temp_c"] = 25.0
    if "sal" not in kwargs_calc_Ks:
        kwargs_calc_Ks["sal"] = 35.0
    if "p_bar" not in kwargs_calc_Ks:
        kwargs_calc_Ks["p_bar"] = None
    if "magnesium" not in kwargs_calc_Ks:
        kwargs_calc_Ks["magnesium"] = None
    if "calcium" not in kwargs_calc_Ks:
        kwargs_calc_Ks["calcium"] = None
    if "sulphate" not in kwargs_calc_Ks:
        kwargs_calc_Ks["sulphate"] = None
    if "fluorine" not in kwargs_calc_Ks:
        kwargs_calc_Ks["fluorine"] = None
    if "MyAMI_mode" not in kwargs_calc_Ks:
        kwargs_calc_Ks["MyAMI_mode"] = "calculate"
    if "K_list" not in kwargs_calc_Ks:
        kwargs_calc_Ks["K_list"] = None
    # Run Kgen to calculate the Ks
    kgen_constants = K_functions.calc_Ks(**kwargs_calc_Ks)
    # Rename Kgen keys for PyCO2SYS
    kgen_constants = {kgen_to_PyCO2SYS[k]: v for k, v in kgen_constants.items()}
    # Add extra PyCO2SYS variables
    kgen_constants["opt_pH_scale"] = 1  # total pH scale
    kgen_constants["temperature"] = kwargs_calc_Ks["temp_c"]
    kgen_constants["salinity"] = kwargs_calc_Ks["sal"]
    if kwargs_calc_Ks["p_bar"] is None:
        kgen_constants["pressure"] = 0
    else:
        kgen_constants["pressure"] = kwargs_calc_Ks["p_bar"] * 10  # bar to dbar
    # Get total salt contents, all in micromol/kg
    if kwargs_calc_Ks["fluorine"] is None:
        kgen_constants["total_fluoride"] = 1e6 * K_functions.calc_fluorine(
            sal=kwargs_calc_Ks["sal"]
        )
    else:
        kgen_constants["total_fluoride"] = 1e6 * kwargs_calc_Ks["fluorine"]
    if kwargs_calc_Ks["sulphate"] is None:
        kgen_constants["total_sulfate"] = 1e6 * K_functions.calc_sulphate(
            sal=kwargs_calc_Ks["sal"]
        )
    else:
        kgen_constants["total_sulfate"] = 1e6 * kwargs_calc_Ks["sulphate"]
    if kwargs_calc_Ks["calcium"] is None:
        kgen_constants["total_calcium"] = 0.0102821e6 * kgen_constants["salinity"] / 35
    else:
        kgen_constants["total_calcium"] = 1e6 * kwargs_calc_Ks["calcium"]
    # # PyCO2SYS doesn't yet accept magnesium, but it's coming in a future release,
    # # so the following is just to be ready for that:
    # if kwargs_calc_Ks["magnesium"] is None:
    #     kgen_constants["total_magnesium"] = (
    #         0.0528171e6 * kgen_constants["salinity"] / 35
    #     )
    # else:
    #     kgen_constants["total_magnesium"] = 1e6 * kwargs_calc_Ks["magnesium"]
    return kgen_constants
