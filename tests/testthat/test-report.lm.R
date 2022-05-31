test_that("report.lm - lm", {
  # lm -------

  # simple effect
  set.seed(123)
  expect_snapshot(report(lm(Sepal.Width ~ Species, data = iris)))

  # interaction effect
  set.seed(123)
  expect_snapshot(report(lm(wt ~ as.factor(am) * as.factor(cyl), data = mtcars)))
})

test_that("report.lm - glm", {
  # glm ------

  set.seed(123)
  expect_snapshot(report(glm(vs ~ disp, data = mtcars, family = binomial(link = "probit"))))

  set.seed(123)
  expect_snapshot(report(glm(vs ~ mpg, data = mtcars, family = "poisson")))
})
