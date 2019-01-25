#' p-values Interpretation
#'
#' @param p Value or vector of p-values.
#' @param rules Can be "default" or custom set of rules.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @examples
#' interpret_p(.02)
#' interpret_p(c(.5, .02))
#' #
#' @export
interpret_p <- function(p, rules = "default") {
  if (rules == "default") {
    return(interpret(p, rules(c(0.05), c("significant", "not significant"))))
  } else if (!is.rules(rules)) {
    stop("The rules set must be an object of type rules.")
  } else {
    return(interpret(p, rules))
  }
}
