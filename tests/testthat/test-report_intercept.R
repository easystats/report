set.seed(123)
response <- rnorm(30)

data1 <- data.frame(
  y = response,
  f = factor(rep(c(1, 2, 3), 10)),
  stringsAsFactors = FALSE
)

data2 <- data.frame(
  y = response,
  f = factor(rep(c(1, 2, 3), 10)),
  stringsAsFactors = FALSE
)

data3 <- data.frame(
  y = response,
  f = factor(rep(c(1, 2, 3), 10)),
  stringsAsFactors = FALSE
)

contrasts(data1$f) <- cbind(c(1, 0, 0), c(0, 1, 0))
data2$f <- relevel(data2$f, 3)

# insight::get_data needs access to data in global environment
data1 <<- data1
data2 <<- data2
data3 <<- data3

# contrasts, ref. level = category 3
m1 <- lm(y ~ f, data = data1)

# relevel, ref. level = category 3
m2 <- lm(y ~ f, data = data2)

# default ref. level = category 1
m3 <- lm(y ~ f, data = data3)

test_that("reflevel", {
  expect_identical(
    as.character(report_intercept(m1)),
    "The model's intercept, corresponding to f = 3, is at 0.07 (95% CI [-0.57, 0.71], t(27) = 0.23, p = 0.819)."
  )
  expect_identical(
    as.character(report_intercept(m2)),
    "The model's intercept, corresponding to f = 3, is at 0.07 (95% CI [-0.57, 0.71], t(27) = 0.23, p = 0.819)."
  )
  expect_identical(
    as.character(report_intercept(m3)),
    "The model's intercept, corresponding to f = 1, is at 0.17 (95% CI [-0.47, 0.81], t(27) = 0.55, p = 0.584)."
  )
})
