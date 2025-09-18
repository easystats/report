test_that("BRMS effectsize method uses faster default", {
  # Test that the brmsfit method exists and has correct default parameters
  expect_true(exists("report_effectsize.brmsfit", envir = getNamespace("report")))

  # Get the function
  brms_func <- get("report_effectsize.brmsfit", envir = getNamespace("report"))

  # Check that it's a function
  expect_type(brms_func, "closure")

  # Check the arguments - should have effectsize_method = "basic" as default
  args <- formals(brms_func)
  expect_true("effectsize_method" %in% names(args))
  expect_identical(eval(args$effectsize_method), "basic")

  # Ensure it's different from the lm method which defaults to "refit"
  lm_func <- get("report_effectsize.lm", envir = getNamespace("report"))
  lm_args <- formals(lm_func)
  expect_identical(eval(lm_args$effectsize_method), "refit")

  # This confirms that BRMS models will use the faster "basic" method
  # while LM models continue using "refit" for consistency
})
