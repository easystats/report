if (require("lavaan") && require("effectsize") &&
  packageVersion("effectsize") >= "0.6.1") {
  structure <- " ind60 =~ x1 + x2 + x3
                 dem60 =~ y1 + y2 + y3
                 dem60 ~ ind60 "

  set.seed(123)
  model <- lavaan::sem(structure, data = PoliticalDemocracy)

  # Specific reports
  test_that("model-lavaan detailed report", {
    expect_snapshot(variant = .Platform$OS.type, report(model))
  })

  test_that("model-lavaan detailed table", {
    expect_snapshot(variant = .Platform$OS.type, report_table(model))
  })

  test_that("model-lavaan detailed performance", {
    expect_snapshot(variant = .Platform$OS.type, report_performance(model))
  })
}
