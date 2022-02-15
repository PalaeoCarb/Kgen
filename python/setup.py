from setuptools import setup, find_packages

setup(
    packages=find_packages(),
    package_data={'kgen': ['coefficients/*.json']},
    include_package_data=True,
    zip_safe=True)
