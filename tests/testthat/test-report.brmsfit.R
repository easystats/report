skip_on_cran()
skip_if_not_installed("brms")

test_that("report.brms", {
  # skip_if_not_installed("rstan", "2.26.0")

  set.seed(333)
  model <- suppressMessages(suppressWarnings(brms::brm(
    mpg ~ qsec + wt,
    data = mtcars,
    refresh = 0,
    iter = 300,
    seed = 333
  )))
  r <- report(model, verbose = FALSE)

  expect_type(summary(r), "character")
  expect_s3_class(as.data.frame(r), "data.frame")

  expect_identical(
    as.data.frame(r)$Parameter,
    c(
      "(Intercept)",
      "qsec",
      "wt",
      "sigma",
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
    as.data.frame(r)$Median,
    c(19.906865, 0.930295, -5.119548, 2.6611623, rep(NA, 7)),
    tolerance = 1e-1
  )
  expect_equal(
    as.data.frame(r)$pd,
    c(rep(1, 4), rep(NA, 7)),
    tolerance = 1e-1
  )

  # Test that report text is a single string (not multiple repetitions)
  # This ensures the fix for issue #543 works correctly
  report_text <- as.character(r)
  expect_length(report_text, 1)
  expect_type(report_text, "character")

  # Ensure the text doesn't contain multiple identical paragraphs (duplications)
  # Split by double newlines to find paragraphs
  paragraphs <- strsplit(report_text, "\\n\\n")[[1]]
  # The main model description paragraph should appear only once
  model_paragraphs <- paragraphs[grepl(
    "We fitted a Bayesian linear model",
    paragraphs,
    fixed = TRUE
  )]
  expect_length(model_paragraphs, 1)

  # Test that priors text doesn't contain empty/meaningless entries like "uniform (location = , scale = )"
  # This ensures proper filtering of empty priors
  prior_paragraphs <- paragraphs[grepl(
    "Priors over parameters",
    paragraphs,
    fixed = TRUE
  )]
  if (length(prior_paragraphs) > 0) {
    # Should not contain empty parentheses or double spaces from empty values
    expect_false(
      grepl("(location = , scale = )", prior_paragraphs[1], fixed = TRUE),
      info = "Prior text should not contain empty parameter values"
    )
    expect_false(
      grepl("\\(,\\s*\\)", prior_paragraphs[1]),
      info = "Prior text should not contain empty parameter parentheses"
    )
  }
  # Note: snapshot test may have slight numerical differences on different platforms
  # Skip snapshot due to platform differences causing CI failures
  skip("Skipping because of a .01 decimal difference in snapshots")
  set.seed(333)
  expect_snapshot(variant = "windows", report(model, verbose = FALSE))
})
