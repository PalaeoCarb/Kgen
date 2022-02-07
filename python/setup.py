from setuptools import setup, find_packages
from kgen import __version__

setup(name='kgen',
      version=__version__,
      description='Tools for calculating empirical K values for seawater chemistry.',
      url='https://github.com/PalaeoCarb/Kgen',
      author='Oscar Branson',
      author_email='ob266@cam.ac.uk',
      license='MIT',
      packages=find_packages(),
      keywords=['science', 'chemistry', 'oceanography', 'carbon'],
      classifiers=['Development Status :: 4 - Beta',
                   'Intended Audience :: Science/Research',
                   'Programming Language :: Python :: 3 :: Only',
                   ],
      install_requires=['numpy'],
      package_data={
          'kgen': [
              '../coefficients/*.json',
              '../check_values/*.json'
              ]
          },
      zip_safe=True)
