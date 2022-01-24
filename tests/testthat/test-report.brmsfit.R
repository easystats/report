.runThisTest <- Sys.getenv("RunAllreportTests") == "yes"

if (.runThisTest && require("testthat") && require("brms")) {
  test_that("report.brms", {
    # too strict; exact values will change depending on the platform
    # so worth checking only locally
    skip_on_ci()

    model <- brm(mpg ~ qsec + wt, data = mtcars, refresh = 0, iter = 300, seed = 333)
    r <- report(model)

    expect_s3_class(summary(r), "character")
    expect_s3_class(as.data.frame(r), "data.frame")

    expect_snapshot(variant = .Platform$OS.type, report(model))

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
