#' Model Algorithm Formatting
#'
#' @param model A statistical model.
#'
#' @examples
#' model <- lm(Sepal.Length ~ Species, data = iris)
#' format_algorithm(model)
#' @importFrom insight find_algorithm
#' @export
format_algorithm <- function(model) {
  algorithm <- insight::find_algorithm(model)

  text <- ""

  if (is.null(algorithm$algorithm)) {
    return(text)
  }

  # Name
  text <- algorithm$algorithm
  if (text == "sampling") {
    text <- "MCMC sampling"
  }

  # Chains
  if (!is.null(algorithm$chains)) {
    text <- paste0(
      text,
      " with ",
      algorithm$chains,
      " chains"
    )
    if (!is.null(algorithm$iterations)) {
      text <- paste0(
        text,
        " of ",
        algorithm$iterations,
        " iterations"
      )
    }
    if (!is.null(algorithm$warmup)) {
      text <- paste0(
        text,
        " and a warmup of ",
        algorithm$warmup
      )
    }
    # Thinning?
  }

  # Optimizer
  if (!is.null(algorithm$optimizer)) {
    optimizer <- algorithm$optimizer

    if (optimizer == "bobyqa") {
      optimizer <- "BOBYQA"
    }
    if (optimizer == "Nelder_Mead") {
      optimizer <- "Nelder-Mead"
    }
    text <- paste0(
      text,
      " and ",
      optimizer,
      " optimizer"
    )
  }


  text
}
