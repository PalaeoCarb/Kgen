# Taken from https://rstudio.github.io/reticulate/articles/package.html
skip_if_no_pymyami <- function() {
  have_pymyami <- reticulate::py_module_available("pymyami")
  if (!have_pymyami)
    testthat::skip("pymyami not available for testing")
}

testthat::test_that("Things work as expected", {
  skip_if_no_pymyami()
  
  # Load input values
  check_Ks <- rjson::fromJSON(file="check_values/check_Ks.json")
  check_KSin <- check_Ks$input_conditions
  check_Ks <- check_Ks$check_values
  check_Ks <- data.frame(do.call(rbind, check_Ks))
  
  # Test 1: at standard pressure
  Ks <- rownames(check_Ks)
  datalist <- list()
  for(ii in Ks) {
    datalist[[ii]] <- Kgen::calc_K(ii, 
                                   TC=check_KSin$TC,
                                    S=check_KSin$S)
  }
  Kgen_calc <- do.call(rbind, datalist)

  testthat::expect_lt(max(Kgen_calc - exp(check_Ks)), 0.0001)
  
  # Test 2: pressure correction
  
  # Add a test for the pressure correction in a future release.
  
  # check_presscorr <- rjson::fromJSON(file="check_values/check_presscorr.json")
  # check_pressin <- check_presscorr$input_conditions
  # check_presscorr <- check_presscorr$check_values
  # check_presscorr <- data.frame(do.call(cbind, check_presscorr))
  
})
