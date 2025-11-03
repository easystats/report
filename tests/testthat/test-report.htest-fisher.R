test_that("report.htest-fisher report", {
  TeaTasting <<-
    matrix(
      c(3, 1, 1, 3),
      nrow = 2,
      dimnames = list(
        Guess = c("Milk", "Tea"),
        Truth = c("Milk", "Tea")
      )
    )
  x <- fisher.test(TeaTasting, alternative = "greater")

  expect_snapshot(
    variant = "windows",
    report(x)
  )
})
