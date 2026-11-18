test_that("linear-model statistics use exact degrees-of-freedom columns", {
  old_options <- options(warnPartialMatchDollar = TRUE, warn = 2)
  on.exit(options(old_options), add = TRUE)
  model <- lm(mpg ~ wt, data = mtcars)
  table <- report_table(model)

  expect_match(
    as.character(report_statistics(model, table = table)),
    "t(30) = ",
    fixed = TRUE
  )
  expect_no_warning(report(model))

  table$df <- table$df_error
  table$df_error <- NULL
  expect_match(
    as.character(report_statistics(model, table = table)),
    "t(30) = ",
    fixed = TRUE
  )

  table$df <- NULL
  expect_match(
    as.character(report_statistics(model, table = table)),
    "t = ",
    fixed = TRUE
  )
})

test_that("survey logistic models retain their t-test degrees of freedom", {
  skip_if_not_installed("survey")
  api <- new.env()
  data("api", package = "survey", envir = api)
  design <- survey::svydesign(
    ids = ~1,
    strata = ~stype,
    weights = ~pw,
    data = api$apistrat
  )
  model <- suppressWarnings(survey::svyglm(
    sch.wide ~ stype * yr.rnd,
    design = design,
    family = binomial()
  ))

  table <- suppressWarnings(report_table(model, effectsize_method = "basic"))
  expected_df <- parameters::model_parameters(model)[["df_error"]]
  expect_identical(table$df_error[!is.na(table$t)], expected_df)
  statistics <- as.character(report_statistics(model, table = table))
  expect_match(statistics, "t(192) = ", fixed = TRUE)
  expect_s3_class(
    suppressWarnings(report(model, effectsize_method = "basic")),
    "report"
  )
})

test_that("performance reports reuse a supplied model table", {
  model <- lm(mpg ~ wt, data = mtcars)
  table <- report_table(model)
  expected <- as.character(report_performance(model))
  local_mocked_bindings(report_table = function(...) {
    stop("Unexpected table recomputation", call. = FALSE)
  })

  expect_identical(
    as.character(report_performance(model, table = table)),
    expected
  )
})
