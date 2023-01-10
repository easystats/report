skip_if_not(getRversion() <= "4.2.1")

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
