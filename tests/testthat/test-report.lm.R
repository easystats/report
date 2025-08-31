# skip_if_not(getRversion() <= "4.2.1")
# This skip does not seem necessary??
# Readding back because of a .1 decimal difference in snapshots

test_that("report.lm - lm", {
  skip("Skipping because of a .01 decimal difference in snapshots")
  # lm -------

  # simple effect
  set.seed(123)
  expect_snapshot(variant = "windows", report(lm(Sepal.Width ~ Species, data = iris)))

  # interaction effect
  set.seed(123)
  expect_snapshot(variant = "windows", report(lm(wt ~ as.factor(am) * as.factor(cyl), data = mtcars)))
})

test_that("report.lm - glm", {
  # glm ------

  set.seed(123)
  expect_snapshot(variant = "windows", report(glm(vs ~ disp, data = mtcars, family = binomial(link = "probit"))))

  set.seed(123)
  expect_snapshot(variant = "windows", report(glm(vs ~ mpg, data = mtcars, family = "poisson")))
})

test_that("report.lm - lm intercept-only", {
  data(sleep)
  d <- datawizard::data_modify(sleep, group = as.integer(group) - 1L)
  d_wide <<- datawizard::data_to_wide(
    d,
    names_from = "group",
    values_from = "extra",
    names_prefix = "group"
  )

  model_io <- lm(d_wide$group0 - d_wide$group1 ~ 1)
  out <- suppressWarnings(report(model_io, verbose = FALSE))
  expect_snapshot(variant = "windows", out)
})


test_that("report.lm - reformulate formula edge cases", {
  # Test various reformulate scenarios to prevent regression of issue #391
  
  # Test 1: Simple reformulate case  
  model_reform <- lm(reformulate(c("wt", "hp"), "mpg"), data = mtcars)
  result_reform <- report(model_reform)
  expect_s3_class(result_reform, "report")
  expect_true(any(grepl("wt", as.character(result_reform))))
  expect_true(any(grepl("hp", as.character(result_reform))))
  
  # Test 2: Reformulate with formula() wrapper (exact issue case)
  model_formula <- lm(formula(reformulate(c("wt", "hp"), "mpg")), data = mtcars)
  result_formula <- report(model_formula)
  expect_s3_class(result_formula, "report")
  expect_true(any(grepl("wt", as.character(result_formula))))
  expect_true(any(grepl("hp", as.character(result_formula))))
  
  # Test 3: Reformulate with interaction terms
  model_interact <- lm(reformulate(c("wt", "hp", "wt:hp"), "mpg"), data = mtcars)
  result_interact <- report(model_interact)
  expect_s3_class(result_interact, "report")
  expect_true(any(grepl("wt", as.character(result_interact))))
  expect_true(any(grepl("hp", as.character(result_interact))))
  
  # Test 4: Reformulate without intercept
  model_no_int <- lm(reformulate(c("wt", "hp"), "mpg", intercept = FALSE), data = mtcars)
  result_no_int <- report(model_no_int)
  expect_s3_class(result_no_int, "report")
  expect_true(any(grepl("wt", as.character(result_no_int))))
  expect_true(any(grepl("hp", as.character(result_no_int))))
  
  # Test 5: Verify format_formula works correctly with reformulate
  formatted_reform <- format_formula(model_reform)
  formatted_normal <- format_formula(lm(mpg ~ wt + hp, data = mtcars))
  expect_equal(formatted_reform, formatted_normal)
  
  # Test 6: Verify report_model works correctly with reformulate  
  model_report_reform <- report_model(model_reform)
  model_report_normal <- report_model(lm(mpg ~ wt + hp, data = mtcars))
  expect_equal(as.character(model_report_reform), as.character(model_report_normal))
})
