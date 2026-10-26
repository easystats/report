test_that("t-test tables retain the test's confidence level", {
  for (alternative in c("two.sided", "less", "greater")) {
    test <- t.test(
      1:10,
      y = c(7:20, 200),
      conf.level = 0.975,
      alternative = alternative
    )
    result <- report(test)
    table <- as.report_table(result)

    expect_identical(table$CI, 0.975)
    expect_identical(table$CI_low, unname(test$conf.int[1]))
    expect_identical(table$CI_high, unname(test$conf.int[2]))
    expect_true("97.5% CI" %in% names(format(table)))
    expect_true("97.5% CI" %in% names(format(summary(table))))
    expect_match(as.character(result), "97.5% CI", fixed = TRUE)
  }
})

test_that("correlation tables retain the test's confidence level", {
  test <- cor.test(mtcars$mpg, mtcars$wt, conf.level = 0.9)
  table <- report_table(test)

  expect_identical(table$CI, 0.9)
  expect_identical(table$CI_low, unname(test$conf.int[1]))
  expect_identical(table$CI_high, unname(test$conf.int[2]))
  expect_true("90% CI" %in% names(format(table)))
})
