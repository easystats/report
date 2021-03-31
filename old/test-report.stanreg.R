

# test_that("report.stanreg_lm", {
#   library(rstanarm)
#
#   r <- report(insight::download_model("stanreg_lm_1"))
#   expect_equal(r$values$wt$Median, -5.34, tol = 0.2)
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 8))
#
#   expect_error(report(insight::download_model("stanreg_lm_1"), bootstrap = TRUE, n = 10))
#
#   r <- report(insight::download_model("stanreg_lm_1"), effsize = "cohen1988", standardize = "refit", centrality = "Mean")
#   expect_equal(r$values$wt$Mean, -5.3397, tol = 0.2)
#
#   r <- report(insight::download_model("stanreg_lm_1"), effsize = "cohen1988", standardize = "refit", test = "bf")
#   # expect_equal(r$values$wt$Mean, -5.3397, tol = 0.2)
#
#   expect_warning(report(insight::download_model("stanreg_lm_1"), effsize = "cohen1988", standardize = TRUE, centrality = "MAP"))
#
#   r <- report(insight::download_model("stanreg_lm_1"), effsize = "cohen1988", rope_ci = 0.95, standardize = "smart", centrality = "all")
#   expect_equal(r$values$wt$Median, -5.336, tol = 0.2)
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 12))
#
#   expect_warning(report(insight::download_model("stanreg_lm_1"), ci = c(0.8, 0.9)))
#   expect_error(report(insight::download_model("stanreg_lm_1"), rope_range = c(0.1, 0.2, 0.3)))
#
#   r <- report(insight::download_model("stanreg_lm_3"), standardize = FALSE, effsize = "cohen1988")
# })



# test_that("report.stanreg_glm", {
#   r <- report(insight::download_model("stanreg_glm_1"), effsize = "cohen1988", standardize = "smart")
#   expect_equal(r$values$wt$Median, -1.93, tol = 0.2)
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(4, 8))
#
#   r <- report(insight::download_model("stanreg_glm_2"))
#   expect_equal(r$values$wt$Median, 0.759, tol = 0.2)
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 8))
# })



# test_that("report.stanreg_lmer", {
#   r <- report(insight::download_model("stanreg_lmerMod_1"), effsize = "cohen1988", standardize = "smart")
#   expect_equal(r$values$cyl$Median, 0.406, tol = 0.2)
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(6, 8))
#
#   r <- report(insight::download_model("stanreg_merMod_1"), effsize = "chen2010", standardize = "smart")
#   expect_equal(r$values$cyl$Median, -1.72, tol = 0.2)
#   expect_equal(c(nrow(to_table(r)), ncol(to_table(r))), c(5, 8))
# })
