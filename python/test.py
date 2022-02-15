import unittest
import json
import numpy as np
from kgen.K_functions import K_fns, prescorr, calc_Ks

class checkKValues(unittest.TestCase):
    """
    Test calculated Ks against all check values.
    """

    def test_Ks(self):
        with open("../coefficients/K_calculation.json") as f:
            coefs = json.load(f)

        with open("../check_values/check_Ks.json") as f:
            check = json.load(f)

        S = check['input_conditions']['S']
        TK = check['input_conditions']['TC'] + 273.15
        lnTK = np.log(TK)
        sqrtS = np.sqrt(S)


        for k, p in coefs['coefficients'].items():
            K = K_fns[k](p, TK=TK, lnTK=lnTK, S=S, sqrtS=sqrtS)

            check_val = check['check_values'][k]
            sigfig = len(str(check_val).rstrip('0').split('.')[1])
            
            self.assertAlmostEqual(np.log(K), check['check_values'][k], msg=f'{k}: {K}', places=sigfig)

    def test_presscorr(self):
        with open('../coefficients/K_pressure_correction.json') as f:
            pcoefs = json.load(f)

        with open("../check_values/check_presscorr.json") as f:
            check = json.load(f)

        S = check['input_conditions']['S']
        P = check['input_conditions']['P']
        TC = check['input_conditions']['TC']
        

        for k, p in pcoefs['coefficients'].items():
            
            pF = prescorr(p, P=P, TC=TC)

            checkval = check['check_values'][k]
        
            self.assertAlmostEqual(pF, checkval, msg=f'{k}: {pF}', places=5)

    def test_boilerplate(self):
        with open("../check_values/check_Ks.json") as f:
            check = json.load(f)
        S = check['input_conditions']['S']
        TC = check['input_conditions']['TC']

        calc = calc_Ks(TempC=TC, Sal=S)

        for k in calc:
            check_val = check['check_values'][k]
            sigfig = len(str(check_val).rstrip('0').split('.')[1])
            
            self.assertAlmostEqual(np.log(calc[k]), check['check_values'][k], msg=f'{k}: {calc[k]}', places=sigfig)
        
if __name__ == '__main__':
    unittest.main()