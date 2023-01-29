skip_if_not_or_load_if_installed("rstanarm")
set.seed(123)
model <- suppressWarnings(stan_glm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 300))

test_that("model-stanreg", {
  r <- report(model, centrality = "mean")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_identical(
    as.data.frame(r)$Parameter,
    c(
      "(Intercept)", "qsec", "wt", NA, "ELPD", "LOOIC", "WAIC", "R2",
      "R2 (adj.)", "Sigma"
    )
  )
  expect_equal(
    as.data.frame(r)$Mean,
    c(
      19.6150397292409, 0.937896549338215, -5.04660975597389, NA,
      NA, NA, NA, NA, NA, NA
    ),
    tolerance = 1e-1
  )
  expect_equal(
    as.data.frame(r)$pd,
    c(0.998333333333333, 0.998333333333333, 1, NA, NA, NA, NA, NA, NA, NA),
    tolerance = 1e-1
  )
})

test_that("model-stanreg detailed", {
  expect_snapshot(variant = "windows", report(model))
})
