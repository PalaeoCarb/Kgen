import unittest
import os
import pandas as pd
import numpy as np
from glob import glob

class crosscheck(unittest.TestCase):

    def test_all(self):
        fs = glob('generated_Ks/*.csv')

        RDIFF_TOLERANCE = 0.1

        checks = {}
        for f in fs:
            lang, method = os.path.basename(f).replace('.csv', '').split('_')
            if method not in checks:
                checks[method] = {}
            checks[method][lang] = pd.read_csv(f)

        test_pass = True

        for method in checks:
            langs = list(checks[method].keys())
            nlangs = len(langs)
            if nlangs < 2:
                print(f'Only one language uses {method} method - nothing to compare.')
                continue
            
            print(f'Testing {method} method...')
            for i,j in zip(*np.triu_indices(nlangs, k=1)):
                ref = checks[method][langs[i]]
                diff = checks[method][langs[i]] - checks[method][langs[j]]
                
                rdiff = diff / ref
                
                maxrdiff = rdiff.abs().max()
                
                print(f'  {langs[i]} vs. {langs[j]}')
                if np.all(maxrdiff <= RDIFF_TOLERANCE):
                    print(f'    OK')
                else:
                    print(f'  **FAIL! Max relative difference:')
                    print('      ' + maxrdiff[maxrdiff>RDIFF_TOLERANCE].to_string().replace('\n', '\n      '))
                    test_pass = False
            
            self.assertTrue(test_pass, msg=f'Ks outside tolerance ({RDIFF_TOLERANCE}), see output above.')