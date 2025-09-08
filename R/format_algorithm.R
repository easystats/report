#' @rdname format_formula
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' format_algorithm(model)
#'
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' # Mixed models
#' library(lme4)
#' model <- lme4::lmer(Sepal.Length ~ Sepal.Width + (1 | Species), data = iris)
#' format_algorithm(model)
#' @return A character string.
#' @export
format_algorithm <- function(x) {
  algorithm <- suppressWarnings(insight::find_algorithm(x))

  result <- ""

  if (is.null(algorithm$algorithm)) {
    return(result)
  }

  # Name
  result <- algorithm$algorithm
  if (result == "sampling") {
    result <- "MCMC sampling"
  }

  # Chains
  if (!is.null(algorithm$chains)) {
    result <- paste0(
      result,
      " with ",
      algorithm$chains,
      " chains"
    )
    if (!is.null(algorithm$iterations)) {
      result <- paste0(
        result,
        " of ",
        algorithm$iterations,
        " iterations"
      )
    }
    if (!is.null(algorithm$warmup)) {
      result <- paste0(
        result,
        " and a warmup of ",
        algorithm$warmup
      )
    }
  }

  # Optimizer
  if (!is.null(algorithm$optimizer)) {
    optimizer <- algorithm$optimizer[1]

    if (optimizer == "bobyqa") {
      optimizer <- "BOBYQA"
    } else if (optimizer == "Nelder_Mead") {
      optimizer <- "Nelder-Mead"
    }
    result <- paste0(
      result,
      " and ",
      optimizer,
      " optimizer"
    )
  }

  result
}
