skip_if_not_installed("GLMMadaptive")
skip_if_not_installed("glmmTMB") # Required by the report.MixMod method

test_that("report.MixMod", {
  # Create a test GLMMadaptive model
  skip_on_cran() # GLMMadaptive models can be computationally intensive

  # Use example from GLMMadaptive documentation
  # Create binary outcome data (GLMMadaptive works best with binomial)
  set.seed(123)
  n <- 50
  K <- 8
  t.max <- 15

  times <- as.vector(replicate(n, c(0, sort(runif(K - 1, 0, t.max)))))
  group <- sample(rep(0:1, each = n / 2))

  DF <- data.frame(
    id = rep(seq_len(n), each = K),
    time = times,
    group = factor(rep(group, each = K))
  )

  # Add binary outcome
  DF$y <- rbinom(nrow(DF), 1, plogis(-2.13 + 0.24 * DF$time))

  suppressWarnings({
    model <- GLMMadaptive::mixed_model(
      fixed = y ~ time + group,
      random = ~ 1 | id,
      data = DF,
      family = binomial()
    )
  })

  # Test main report function
  r <- suppressWarnings(report(model, data = DF))
  expect_s3_class(r, "report")
  expect_s3_class(summary(r), "character")
  expect_s3_class(as.data.frame(r), c("report_table", "data.frame"))

  # Test that it uses lm methods (since report.MixMod <- report.lm)
  expect_gt(nchar(summary(r)), 0)
  expect_gt(nrow(as.data.frame(r)), 0)

  # Test specific MixMod methods
  rt <- report_table(model)
  expect_s3_class(rt, c("report_table", "data.frame"))

  rr <- report_random(model)
  expect_s3_class(rr, c("report_random", "character"))
  expect_true(grepl("random effect", rr, fixed = TRUE))
})
