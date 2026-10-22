test_that("report_random names each grouping factor", {
  skip_if_not_installed("lme4")
  d <- mtcars

  m <- lme4::lmer(mpg ~ 1 + (1 | cyl) + (1 | gear), data = d)
  expect_identical(
    attr(report_random(m), "summary"),
    "The model included cyl and gear as random effects"
  )

  # random slopes are not grouping factors
  m <- suppressWarnings(lme4::lmer(mpg ~ wt + (1 + wt | cyl), data = d))
  expect_identical(
    attr(report_random(m), "summary"),
    "The model included cyl as random effect"
  )
})


test_that("report_random describes interaction grouping factors", {
  skip_if_not_installed("lme4")
  d <- mtcars

  m <- suppressWarnings(lme4::lmer(mpg ~ 1 + (1 | cyl:gear), data = d))
  expect_identical(
    attr(report_random(m), "summary"),
    "The model included the interaction of cyl and gear as random effect"
  )

  m <- suppressWarnings(lme4::lmer(mpg ~ 1 + (1 | cyl / gear), data = d))
  expect_identical(
    attr(report_random(m), "summary"),
    "The model included the interaction of gear and cyl, and cyl as random effects"
  )
})


test_that("report_random works for glmmTMB and lme", {
  skip_if_not_installed("glmmTMB")
  skip_if_not_installed("nlme")
  d <- mtcars

  m <- suppressWarnings(glmmTMB::glmmTMB(
    mpg ~ 1 + (1 | cyl) + (1 | gear),
    data = d
  ))
  expect_identical(
    attr(report_random(m), "summary"),
    "The model included cyl and gear as random effects"
  )

  m <- nlme::lme(mpg ~ 1, random = ~ 1 | cyl / gear, data = d)
  expect_identical(
    attr(report_random(m), "summary"),
    "The model included the interaction of gear and cyl, and cyl as random effects"
  )
})
