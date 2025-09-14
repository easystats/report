skip_on_cran()
skip_if_not_installed("brms")

test_that("report.brms", {
  skip_if_not_installed("rstan", "2.26.0")

  set.seed(333)
  model <- suppressMessages(suppressWarnings(brms::brm(
    mpg ~ qsec + wt,
    data = mtcars, refresh = 0, iter = 300, seed = 333
  )))
  r <- report(model, verbose = FALSE)

  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_identical(
    as.data.frame(r)$Parameter,
    c(
      "(Intercept)", "qsec", "wt", "sigma", NA, "ELPD", "LOOIC", "WAIC", "R2",
      "R2 (adj.)", "Sigma"
    )
  )
  expect_equal(
    as.data.frame(r)$Median,
    c(19.906865, 0.930295, -5.119548, 2.6611623, rep(NA, 7)),
    tolerance = 1e-1
  )
  expect_equal(
    as.data.frame(r)$pd,
    c(rep(1, 4), rep(NA, 7)),
    tolerance = 1e-1
  )

  # Note: snapshot test may have slight numerical differences on different platforms
  set.seed(333)
  expect_snapshot(variant = "windows", report(model, verbose = FALSE))
})
