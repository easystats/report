mod0 <- lm(Sepal.Length ~ 1, data = iris)
mod1 <- lm(Sepal.Length ~ Species, data = iris)
mod2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
mod3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)

BFmodels <- bayestestR::bayesfactor_models(mod1, mod2, mod3, denominator = mod0)

test_that("models", {
  r <- report(BFmodels)
  expect_s3_class(summary(r), c("report_text", "character"))
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  expect_output(print(r), "BIC approximation")
  expect_output(print(r), "Intercept only")

  BFmodels <- bayestestR::bayesfactor_models(
    mod1,
    mod2,
    mod3,
    denominator = mod1
  )
  r <- report(BFmodels)
  expect_output(print(r), "Compared to the Species model")
})

test_that("inclusion", {
  inc_bf <- bayestestR::bayesfactor_inclusion(
    BFmodels,
    prior_odds = c(1, 2, 3),
    match_models = TRUE
  )
  r <- report(inc_bf)
  expect_s3_class(summary(r), c("report_text", "character"))
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Check for content that should be present in the output
  output_lines <- capture.output(print(r))
  output_text <- paste(output_lines, collapse = " ")

  expect_true(any(grepl(
    "Bayesian model averaging",
    output_lines,
    fixed = TRUE
  )))
  expect_true(any(grepl("subjective", output_lines, fixed = TRUE)))
  expect_true(any(grepl("averaging", output_lines, fixed = TRUE)))

  inc_bf <- bayestestR::bayesfactor_inclusion(BFmodels)
  r <- report(inc_bf)
  expect_s3_class(summary(r), c("report_text", "character"))
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Check that "subjective prior odds" doesn't appear when no prior_odds specified
  output_lines2 <- capture.output(print(r))
  output_text2 <- paste(output_lines2, collapse = " ")
  expect_false(grepl("subjective prior odds", output_text2, fixed = TRUE))
})
