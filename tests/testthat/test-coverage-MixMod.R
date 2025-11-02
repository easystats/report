# Coverage tests for report.MixMod functions

skip_if_not_installed("GLMMadaptive")
skip_on_cran() # GLMMadaptive mixed models are computationally intensive

test_that("report.MixMod coverage test", {
  set.seed(999)
  # Create longitudinal data suitable for GLMMadaptive
  n_subjects <- 8
  n_timepoints <- 4

  data_mixmod <- data.frame(
    id = rep(1:n_subjects, each = n_timepoints),
    time = rep(c(0, 1, 2, 3), n_subjects),
    x = rnorm(n_subjects * n_timepoints)
  )

  # Create binary outcome appropriate for GLMMadaptive
  data_mixmod$y <- rbinom(
    nrow(data_mixmod), 1,
    plogis(-1 + 0.5 * data_mixmod$time + 0.3 * data_mixmod$x)
  )

  # Create GLMMadaptive mixed model
  suppressWarnings({
    model <- GLMMadaptive::mixed_model(
      fixed = y ~ time + x,
      random = ~ 1 | id,
      data = data_mixmod,
      family = binomial()
    )
  })

  # Test report.MixMod (which is aliased to report.lm)
  r <- suppressWarnings(report(model, data = data_mixmod))
  expect_s3_class(r, "report")
  expect_type(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Test report_random.MixMod specifically
  rr <- report_random(model)
  expect_s3_class(rr, c("report_random", "character"))
  expect_true(grepl("random effect", rr, fixed = TRUE))

  # Test other MixMod-specific functions for coverage
  rt <- report_table(model)
  expect_s3_class(rt, c("report_table", "data.frame"))

  # Test report_performance for MixMod
  rp <- suppressWarnings(report_performance(model))
  expect_s3_class(rp, c("report_performance", "character"))

  # Test report_effectsize for MixMod
  re <- suppressWarnings(report_effectsize(model))
  expect_s3_class(re, "report_effectsize")
})
