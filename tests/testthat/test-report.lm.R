# skip_if_not(getRversion() <= "4.2.1")
# This skip does not seem necessary??
# Readding back because of a .1 decimal difference in snapshots

test_that("report.lm - lm", {
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
  out <- report(model_io)
  expect_snapshot(out)
})
