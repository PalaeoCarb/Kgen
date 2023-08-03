import unittest
import os
import pandas as pd
import numpy as np
from glob import glob
import pymyami
import json

RDIFF_TOLERANCE = 0.0001  # tolrate max 0.01% difference

class crosscheck(unittest.TestCase):
    def test_polynomial_coefficients(self):
        with open('../r/inst/coefficients/polynomial_coefficients.json') as f:
            r_coefs = json.load(f)
            
        with open('../matlab/polynomial_coefficients.json') as f:
            matlab_coefs = json.load(f)
            
        with self.subTest(msg=f'Checking MATLAB polynomial coefficients'):
            for k, ref in pymyami.approximate.SEAWATER_CORRECTION_COEFS.items():
                self.assertIsNone(np.testing.assert_equal(ref, matlab_coefs[k]), msg=f'\nMATLAB polynomial coefficients differ for {k}')
        
        with self.subTest(msg=f'Checking R polynomial coefficients'):
            for k, ref in pymyami.approximate.SEAWATER_CORRECTION_COEFS.items():
                self.assertIsNone(np.testing.assert_equal(ref, r_coefs[k]), msg=f'\nR polynomial coefficients differ for {k}')

    def test_all(self):
        fs = glob('generated_Ks/*.csv')
        
        checks = {}
        for f in fs:
            lang, method = os.path.basename(f).replace('.csv', '').split('_')
            if method not in checks:
                checks[method] = {}
            checks[method][lang] = pd.read_csv(f)

        for method in checks:
            langs = list(checks[method].keys())
            nlangs = len(langs)
            if nlangs < 2:
                print(f'Only one language ({lang}) uses {method} method - nothing to compare.')
                continue
            
            print(f'Testing {method} method...')
            for i,j in zip(*np.triu_indices(nlangs, k=1)):
                test_pass = True
                msg = ''
                ref = checks[method][langs[i]]
                diff = checks[method][langs[i]] - checks[method][langs[j]]
                
                rdiff = diff / ref
                
                maxrdiff = rdiff.abs().max()
                
                print(f'  {langs[i]} vs. {langs[j]}')
                if np.all(maxrdiff <= RDIFF_TOLERANCE):
                    print(f'    OK')
                else:
                    msg = f'  Max relative difference:'
                    msg +='\n      ' + maxrdiff[maxrdiff>RDIFF_TOLERANCE].to_string().replace('\n', '\n      ')
                    test_pass = False
            
                with self.subTest(msg=f'{method}: {langs[i]} vs. {langs[j]}'):
                    self.assertTrue(test_pass, msg=f'\n\nKs outside tolerance ({RDIFF_TOLERANCE}):\n{msg}')

if __name__ == '__main__':
    unittest.main()
