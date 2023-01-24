requiet <- function(package) {
  testthat::skip_if_not_installed(package)
  suppressPackageStartupMessages(
    require(package, warn.conflicts = FALSE, character.only = TRUE)
  )
}

# requiet all hard dependencies
requiet("bayestestR")
requiet("insight")
requiet("datawizard")
requiet("effectsize")
requiet("parameters")
requiet("performance")
