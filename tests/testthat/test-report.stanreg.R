skip_if_not_installed("rstanarm")
skip_on_cran() # rstanarm models are computationally intensive

set.seed(123)
model <- suppressWarnings(rstanarm::stan_glm(
  mpg ~ qsec + wt,
  data = mtcars,
  refresh = 0,
  iter = 300
))

test_that("model-stanreg", {
  r <- report(model, centrality = "mean")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_identical(
    as.data.frame(r)$Parameter,
    c(
      "(Intercept)",
      "qsec",
      "wt",
      NA,
      "ELPD",
      "LOOIC",
      "WAIC",
      "R2",
      "R2 (adj.)",
      "Sigma"
    )
  )
  expect_equal(
    as.data.frame(r)$Mean,
    c(
      19.6150397292409,
      0.937896549338215,
      -5.04660975597389,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA,
      NA
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
  expect_snapshot(
    variant = "windows",
    report(model, include_diagnostic = FALSE)
  )
})

test_that("model-stanreg diagnostics match the fitted posterior", {
  diagnostic <- bayestestR::diagnostic_posterior(model)
  ess_column <- intersect(c("ESS_tail", "ESS", "ESS_bulk"), names(diagnostic))[
    1
  ]
  expect_false(is.na(ess_column))
  ess_label <- switch(
    ess_column,
    ESS_tail = "ESS (tail)",
    ESS_bulk = "ESS (bulk)",
    "ESS"
  )
  parameters <- report_parameters(model)
  parameter_names <- attr(parameters, "parameters")$Parameter

  for (i in seq_len(nrow(diagnostic))) {
    text <- parameters[match(diagnostic$Parameter[i], parameter_names)]
    expect_match(
      text,
      paste0(
        ess_label,
        " = ",
        insight::format_value(diagnostic[[ess_column]][i], digits = 0)
      ),
      fixed = TRUE
    )
    expect_match(
      text,
      paste0("Rhat = ", insight::format_value(diagnostic$Rhat[i], digits = 3)),
      fixed = TRUE
    )
  }
})
