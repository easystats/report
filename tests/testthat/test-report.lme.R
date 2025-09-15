skip_if_not_installed("nlme")

test_that("report.lme", {
  # Create a test nlme model
  suppressWarnings({
    model <- lme(
      Sepal.Length ~ Petal.Length,
      data = iris,
      random = ~ 1 | Species
    )
  })

  # Test that model was created successfully
  expect_s3_class(model, "lme")

  # Test specific lme methods that should work without standardization issues
  rr <- report_random(model)
  expect_s3_class(rr, c("report_random", "character"))
  expect_true(grepl("random effect", rr, fixed = TRUE))
  expect_true(grepl("Species", rr, fixed = TRUE))

  # Test that report.lme exists and is assigned correctly
  expect_true(exists("report.lme", where = asNamespace("report")))
  expect_identical(report.lme, report.lm)
})
