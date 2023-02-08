# Release Checklist for KGen

## Version numbers

Should follow X.Y.Z, where X and Y are cross-platform major and minor releases, and Z can be platform-specific bug fixes.

## When a new version is released

### Python

Update `VERSION` in `kgen/__init__.py`.

run `make distribute python`

### matlab

What needs doing?

### R

How to update package and upload to CRAN?

## When pymyami is updated 

### Python

Nothing to do - latest version is used by default.

### matlab

- [ ] Update pymyami version in `FILE PATH and LINE NUMBER`
- [ ] Update `polynomial_coefficients` to match `pymyami/parameters/Fcorr_approx.json`

### R

- [ ] Update pymyami version in `FILE PATH and LINE NUMBER`
- [ ] Update `polynomial_coefficients` to match `pymyami/parameters/Fcorr_approx.json`
