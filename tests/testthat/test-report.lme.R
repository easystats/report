skip_if_not_installed("nlme")
library(nlme)

test_that("report.lme", {
  # Create a test nlme model
  suppressWarnings({
    model <- nlme::lme(
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

  # Test that report.lme method is properly available
  expect_true("report.lme" %in% ls(asNamespace("report")))

  # Test that it works as intended (aliased to report.lm)
  expect_identical(
    get("report.lme", asNamespace("report")),
    get("report.lm", asNamespace("report"))
  )
})
