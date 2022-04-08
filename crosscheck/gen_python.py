import sys
import numpy as np
import pandas as pd
sys.path.append('../python')

import kgen

# 1. Load test_conditions.csv
test_df = pd.read_csv('./test_conditions.csv')
test_dict = {k: np.array(v) for k,v in test_df.to_dict(orient='list').items()}

# 2. Run kgen using those inputs
Ks_calc = kgen.calc_Ks(**test_dict, MyAMI_mode='calculate')
Ks_approx = kgen.calc_Ks(**test_dict, MyAMI_mode='approximate')

# 3. Save inputs to ./generated_Ks as python_{calculated, approximated}.csv
Ks_calc_df = pd.DataFrame.from_dict(Ks_calc)
Ks_approx_df = pd.DataFrame.from_dict(Ks_approx)

Ks_calc_df.to_csv('./generated_Ks/python_calculated.csv', index=False)
Ks_approx_df.to_csv('./generated_Ks/python_approximated.csv', index=False)
