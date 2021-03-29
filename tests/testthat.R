library(testthat)
library(report)

if (length(strsplit(packageDescription("report")$Version, "\\.")[[1]]) > 3) {
  Sys.setenv("RunAllreportTests" = "yes")
} else {
  Sys.setenv("RunAllreportTests" = "no")
}

osx <- tryCatch(
  {
    si <- Sys.info()
    if (!is.null(si["sysname"])) {
      si["sysname"] == "Darwin" || grepl("^darwin", R.version$os)
    } else {
      FALSE
    }
  },
  error = function(e) {
    FALSE
  }
)

test_check("report")
