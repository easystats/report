context("report.lavaan")

# test_that("report.lavaan", {
#   library(lavaan)
#
#   structure <- " visual  =~ x1 + x2 + x3
#                  textual =~ x4 + x5 + x6
#                  speed   =~ x7 + x8 + x9 "
#
#   model <- lavaan::cfa(structure, data = HolzingerSwineford1939)
#   r <- report(model)
#   testthat::expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(27, 7))
# })
