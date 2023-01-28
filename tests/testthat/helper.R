skip_if_not_or_load_if_installed <- function(package) {
  testthat::skip_if_not_installed(package)
  suppressPackageStartupMessages(
    require(package, warn.conflicts = FALSE, character.only = TRUE)
  )
}

# load all hard dependencies to use them without namespacing
skip_if_not_or_load_if_installed("bayestestR")
skip_if_not_or_load_if_installed("insight")
skip_if_not_or_load_if_installed("datawizard")
skip_if_not_or_load_if_installed("effectsize")
skip_if_not_or_load_if_installed("parameters")
skip_if_not_or_load_if_installed("performance")
