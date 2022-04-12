library('testthat')
library('Kgen')

# Taken from https://rstudio.github.io/reticulate/articles/package.html
skip_if_no_pymyami <- function() {
  have_pymyami <- reticulate::py_module_available("pymyami")
  if (!have_pymyami)
    skip("pymyami not available for testing")
}

test_that("Things work as expected", {
  skip_if_no_pymyami()
  Kgen::calc_Ks()
})
