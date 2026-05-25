skip_if_not_installed("performance")

# ---------------------------------------------------------------------------
# Happy paths
# ---------------------------------------------------------------------------

test_that("report_assumptions - all assumptions satisfied", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report_assumptions(m)

  expect_s3_class(result, "report_text")
  expect_match(as.character(result), "Model Assumptions", fixed = TRUE)
  expect_match(as.character(result), "Influential observations", fixed = TRUE)
  expect_match(as.character(result), "Homoskedasticity", fixed = TRUE)
})

test_that("report_assumptions - summary sentence structure", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  summ <- as.character(summary(report_assumptions(m)))

  expect_match(summ, "The model's assumptions were checked", fixed = TRUE)
  expect_match(summ, "no influential observations were detected", fixed = TRUE)
  expect_match(summ, "homoskedastic", fixed = TRUE)
})

test_that("report_assumptions - outliers detected", {
  dat <- mtcars
  dat[1L, "mpg"] <- 200
  dat[2L, "mpg"] <- 200
  m <- lm(mpg ~ wt + hp, data = dat)
  summ <- as.character(summary(report_assumptions(m)))

  expect_match(summ, "The model's assumptions were checked", fixed = TRUE)
  expect_false(grepl("no influential observations", summ, fixed = TRUE))
  expect_match(summ, "influential observation", ignore.case = TRUE)
})

test_that("report_assumptions - AI audience structure", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report_assumptions(m, audience = "ai")

  expect_s3_class(result, "report_ai")
  expect_match(result, "## Assumptions", fixed = TRUE)
  expect_match(result, "- Influential Observations:", fixed = TRUE)
  expect_match(result, "- Homoskedasticity:", fixed = TRUE)
})

test_that("report_assumptions - AI no outliers", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report_assumptions(m, audience = "ai")
  expect_match(result, "Influential Observations: none", fixed = TRUE)
})

test_that("report_assumptions - AI outliers detected", {
  dat <- mtcars
  dat[1L, "mpg"] <- 200
  dat[2L, "mpg"] <- 200
  m <- lm(mpg ~ wt + hp, data = dat)
  result <- report_assumptions(m, audience = "ai")
  # Should show a count, not "none"
  expect_false(grepl("Influential Observations: none", result, fixed = TRUE))
  expect_match(result, "Influential Observations:", fixed = TRUE)
})

# ---------------------------------------------------------------------------
# Graceful fallbacks when individual checks fail
# ---------------------------------------------------------------------------

test_that("report_assumptions - partial fallback when check_outliers fails", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  local_mocked_bindings(
    check_outliers = function(...) stop("not supported for this class"),
    .package = "performance"
  )
  result <- expect_no_error(report_assumptions(m))

  # Heteroskedasticity check still ran → summary should mention it
  summ <- as.character(summary(result))
  expect_match(summ, "The model's assumptions were checked", fixed = TRUE)
  expect_match(summ, "homoskedastic", fixed = TRUE)
  # Outlier check absent from summary
  expect_false(grepl("influential", summ, ignore.case = TRUE))
})

test_that("report_assumptions - partial fallback when check_heteroskedasticity fails", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  local_mocked_bindings(
    check_heteroskedasticity = function(...) stop("not supported"),
    .package = "performance"
  )
  result <- expect_no_error(report_assumptions(m))

  summ <- as.character(summary(result))
  expect_match(summ, "The model's assumptions were checked", fixed = TRUE)
  expect_match(summ, "influential observations", fixed = TRUE)
  expect_false(grepl("homoskedast", summ, ignore.case = TRUE))
})

test_that("report_assumptions - full fallback when both checks fail", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  local_mocked_bindings(
    check_outliers = function(...) stop("not supported"),
    check_heteroskedasticity = function(...) stop("not supported"),
    .package = "performance"
  )
  result <- expect_no_error(report_assumptions(m))

  # Should return an object (not NULL, not an error)
  expect_false(is.null(result))
  summ <- as.character(summary(result))
  expect_match(summ, "could not be performed", fixed = TRUE)
})

test_that("report_assumptions - AI partial fallback shows N/A", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  local_mocked_bindings(
    check_outliers = function(...) stop("not supported"),
    .package = "performance"
  )
  result <- expect_no_error(report_assumptions(m, audience = "ai"))

  expect_s3_class(result, "report_ai")
  expect_match(result, "Influential Observations: N/A", fixed = TRUE)
  # Homoskedasticity still worked
  expect_false(grepl("Homoskedasticity: N/A", result, fixed = TRUE))
})

test_that("report_assumptions - AI full fallback shows N/A for both", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  local_mocked_bindings(
    check_outliers = function(...) stop("not supported"),
    check_heteroskedasticity = function(...) stop("not supported"),
    .package = "performance"
  )
  result <- expect_no_error(report_assumptions(m, audience = "ai"))

  expect_s3_class(result, "report_ai")
  expect_match(result, "Influential Observations: N/A", fixed = TRUE)
  expect_match(result, "Homoskedasticity: N/A", fixed = TRUE)
})

# ---------------------------------------------------------------------------
# Integration with report()
# ---------------------------------------------------------------------------

test_that("report() - assumptions summary appears after model description", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  summ <- as.character(summary(report(m)))

  # Assumptions sentence present
  expect_match(summ, "The model's assumptions were checked", fixed = TRUE)
  # It should come before the R2 performance sentence
  assum_pos <- regexpr("assumptions were checked", summ)
  r2_pos <- regexpr("R2", summ)
  expect_true(assum_pos < r2_pos)
})

test_that("report(audience='ai') - assumptions block between Variables and Parameters", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report(m, audience = "ai")

  expect_match(result, "## Assumptions", fixed = TRUE)
  vars_pos <- regexpr("## Variables", result)
  assum_pos <- regexpr("## Assumptions", result)
  params_pos <- regexpr("## Parameters", result)
  expect_true(vars_pos < assum_pos)
  expect_true(assum_pos < params_pos)
})

test_that("report(audience='ai') - no blank line after ## Variables", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report(m, audience = "ai")

  # After "## Variables\n" the very next character should not be "\n"
  expect_false(grepl("## Variables\n\n", result, fixed = TRUE))
})
