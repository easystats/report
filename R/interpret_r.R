#' Correlation Coefficient Interpretation
#'
#' @param r Value or vector of correlation coefficient.
#' @param rules Can be "cohen1988" (default), "evans1996" or custom set of rules.
#' @param direction Return the parameter's direction.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' interpret_r(r = .015)
#' interpret_r(r = c(.5, -.02))
#' #
#' @export
interpret_r <- function(r, rules = "cohen1988", direction = TRUE) {
  if (rules == "cohen1988") {
    text <- interpret(
      abs(r),
      rules(
        c(0.1, 0.3, 0.5),
        c("very small", "small", "moderate", "large")
      )
    )
  } else if (rules == "evans1996") {
    text <- interpret(
      abs(r),
      rules(
        c(0.2, 0.4, 0.6, 0.8),
        c("very weak", "weak", "moderate", "strong", "very strong")
      )
    )
  } else if (!is.rules(rules)) {
    stop("The rules set must be an object of type rules.")
  } else {
    text <- interpret(abs(r), rules)
  }

  if (direction == TRUE) {
    text <- ifelse(r >= 0, paste0("positive and ", text), paste0("negative and ", text))
  }

  return(text)
}
