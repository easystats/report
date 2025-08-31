# Generate snapshots only on Windows to avoid having to generate snapshot variant
# corresponding to each OS (#312).
#
# This is especially important for Bayesian models where the results can be different
# across OS, and there is no way to specify a threshold when it comes to snapshots
# since the values included are of character type.
if (tolower(Sys.info()[["sysname"]]) == "windows") {
  library(testthat)

  test_check("report")
}
