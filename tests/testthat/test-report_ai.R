test_that("report_ai.lm - basic structure", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report_ai(m)

  expect_s3_class(result, "report_ai")
  expect_s3_class(result, "character")
  expect_match(result, "## Model", fixed = TRUE)
  expect_match(result, "## Variables", fixed = TRUE)
  expect_match(result, "## Parameters", fixed = TRUE)
  expect_match(result, "## Performance", fixed = TRUE)
  expect_match(result, "## Highlights", fixed = TRUE)
  # lm has no random effects section
  expect_false(grepl("### Random Effects", result, fixed = TRUE))
  # CI / df method line
  expect_match(result, "Inference:", fixed = TRUE)
})

test_that("report_ai.lm - model metadata", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report_ai(m)

  expect_match(result, "Call: lm", fixed = TRUE)
  expect_match(result, "N: 32", fixed = TRUE)
  expect_match(result, "gaussian", fixed = TRUE)
  # significant predictors
  expect_match(result, "wt", fixed = TRUE)
})

test_that("report_ai.lm - print method", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result <- report_ai(m)
  expect_output(print(result))
})

test_that("report_ai.default - warns and falls back to report()", {
  # htest has report() support but no dedicated report_ai() method
  ht <- t.test(mtcars$mpg ~ mtcars$am)
  result <- expect_warning(report_ai(ht), "not yet available")
  expect_s3_class(result, "report")
})

test_that("report_ai.default - falls back to human report() when report_audience option is ai", {
  # Regression test: fallback from report_ai.default() must not recurse back
  # into AI routing when the global audience option is set to "ai".
  ht <- t.test(mtcars$mpg ~ mtcars$am)
  old <- getOption("report_audience")
  on.exit(options(report_audience = old))

  options(report_audience = "ai")
  result <- expect_warning(report_ai(ht), "not yet available")
  expect_s3_class(result, "report")
  expect_false(inherits(result, "report_ai"))
})

test_that("report() audience argument dispatches to report_ai", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  result_ai <- report(m, audience = "ai")
  result_human <- report(m, audience = "humans")

  expect_s3_class(result_ai, "report_ai")
  expect_s3_class(result_human, "report")
})

test_that("report() respects report_audience option", {
  m <- lm(mpg ~ wt + hp, data = mtcars)
  old <- getOption("report_audience")
  on.exit(options(report_audience = old))

  options(report_audience = "ai")
  expect_s3_class(report(m), "report_ai")

  options(report_audience = "humans")
  expect_s3_class(report(m), "report")
})

test_that("report_ai.glm - binomial family", {
  m <- glm(vs ~ mpg + hp, data = mtcars, family = binomial())
  result <- report_ai(m)

  expect_s3_class(result, "report_ai")
  expect_match(result, "## Model", fixed = TRUE)
  expect_match(result, "## Parameters", fixed = TRUE)
  expect_match(result, "## Performance", fixed = TRUE)
  expect_match(result, "binomial", fixed = TRUE)
  expect_match(result, "Call: glm", fixed = TRUE)
})

test_that("report_ai.glm - poisson family", {
  m <- glm(gear ~ mpg + hp, data = mtcars, family = poisson())
  result <- report_ai(m)

  expect_s3_class(result, "report_ai")
  expect_match(result, "poisson", fixed = TRUE)
})

test_that("report_ai.merMod - lmer", {
  skip_if_not_installed("lme4")
  skip_on_cran()

  m <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
  result <- report_ai(m)

  expect_s3_class(result, "report_ai")
  expect_match(result, "## Model", fixed = TRUE)
  expect_match(result, "## Parameters", fixed = TRUE)
  expect_match(result, "## Performance", fixed = TRUE)
  expect_match(result, "Call: lmer", fixed = TRUE)
  expect_match(result, "Days", fixed = TRUE)
  # Random effects should appear as bullet points, not in the fixed-effects table
  expect_match(result, "### Random Effects", fixed = TRUE)
  expect_match(result, "[Subject]", fixed = TRUE)
  # Subject (grouping variable) should NOT appear in the Variables section
  expect_false(grepl(
    "Subject",
    strsplit(
      strsplit(result, "## Variables\n", fixed = TRUE)[[1]][2],
      "## Parameters",
      fixed = TRUE
    )[[1]][
      1
    ],
    fixed = TRUE
  ))
})

test_that("report_ai.merMod - glmer", {
  skip_if_not_installed("lme4")
  skip_on_cran()

  set.seed(123)
  m <- lme4::glmer(
    cbind(incidence, size - incidence) ~ period + (1 | herd),
    data = lme4::cbpp,
    family = binomial()
  )
  result <- report_ai(m)

  expect_s3_class(result, "report_ai")
  expect_match(result, "binomial", fixed = TRUE)
  expect_match(result, "Call: glmer", fixed = TRUE)
})

test_that("report_ai.glmmTMB - poisson with random effect", {
  skip_if_not_installed("glmmTMB")
  skip_on_cran()

  set.seed(123)
  m <- suppressWarnings(glmmTMB::glmmTMB(
    count ~ mined + (1 | site),
    family = poisson(),
    data = glmmTMB::Salamanders
  ))
  result <- report_ai(m)

  expect_s3_class(result, "report_ai")
  expect_match(result, "## Model", fixed = TRUE)
  expect_match(result, "## Parameters", fixed = TRUE)
  expect_match(result, "## Performance", fixed = TRUE)
  expect_match(result, "Call: glmmTMB", fixed = TRUE)
  expect_match(result, "poisson", fixed = TRUE)
  # Random effects section should be present
  expect_match(result, "### Random Effects", fixed = TRUE)
})
