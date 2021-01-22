if (require("testthat") && require("brms")) {
  model <- brm(mpg ~ qsec + wt, data = mtcars, refresh=0, iter=300)

  testthat::test_that("model", {
    r <- report(model)
    testthat::expect_is(summary(r), "character")
    testthat::expect_is(as.data.frame(r), "data.frame")

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
      c(rep(1, 3), rep(NA, 7)), 
      tolerance = 1e-1
    )
  })
}
