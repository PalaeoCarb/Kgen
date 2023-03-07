# Release Checklist for KGen

## Version numbers

Should follow X.Y.Z, where X and Y are cross-platform major and minor releases, and Z can be platform-specific bug fixes.

### Logic

- Performance across all languages will be identical at the X.Y level.
- The .Z level will be used to indicate bug fixes for a specific language, and may therefore differ between languages.

### Update Procedure

1. Make changes to code, and push a GitHub Tag incrementing the Z level and identifying the language that was changed, i.e. `X.Y.Z+1 - LANGUAGE`
2. On GitHub, create a release linked to this tag, and add a description of the changes made.
3. Follow the instructions below to update the package for the language that has changed.

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
