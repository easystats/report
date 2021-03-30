if (require("testthat") && require("rstanarm")) {
  set.seed(123)
  model <- stan_glm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 300)

  test_that("model-stanreg", {
    r <- report(model)
    expect_s3_class(summary(r), "character")
    expect_s3_class(as.data.frame(r), "data.frame")

    expect_equal(
      as.data.frame(r)$Parameter,
      c(
        "(Intercept)", "qsec", "wt", NA, "ELPD", "LOOIC", "WAIC", "R2",
        "R2 (adj.)", "Sigma"
      )
    )
    expect_equal(
      as.data.frame(r)$Median,
      c(19.906865, 0.930295, -5.119548, rep(NA, 7)),
      tolerance = 1e-1
    )
    expect_equal(
      as.data.frame(r)$pd,
      c(0.998333333333333, 0.998333333333333, 1, NA, NA, NA, NA, NA, NA, NA),
      tolerance = 1e-1
    )
  })

  test_that("model-stanreg detailed", {
    skip_on_ci()
    expect_snapshot(report(model))
  })
}
