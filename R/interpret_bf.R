#' Bayes Factor (BF) Interpretation
#'
#' @param bf Value or vector of Bayes factor (BF) values.
#' @param rules Can be "jeffreys1961" (default), "raftery1995" or custom set of \code{\link{rules}}.
#' @param include_value Include the value in the output.
#'
#'
#' @examples
#' interpret_bf(1)
#' interpret_bf(c(5, 2))
#' @references
#' \itemize{
#'  \item Jeffreys, H. (1961), Theory of Probability, 3rd ed., Oxford University Press, Oxford.
#'  \item Raftery, A. E. (1995). Bayesian model selection in social research. Sociological methodology, 25, 111-164.
#'  \item Jarosz, A. F., & Wiley, J. (2014). What are the odds? A practical guide to computing and reporting Bayes factors. The Journal of Problem Solving, 7(1), 2.
#'  }
#' @export
interpret_bf <- function(bf, rules = "jeffreys1961", include_value = FALSE) {
  ori_bf <- bf

  dir <- ifelse(bf < 1, "against", "in favour of")
  bf <- c(bf)
  bf[bf < 1] <- 1 / abs(bf[bf < 1])


  if (is.rules(rules)) {
    interpretation <- interpret(bf, rules)
  } else {
    if (rules == "jeffreys1961") {
      interpretation <- interpret(bf, rules(c(1, 3, 10, 30, 100), c("no", "anecdotal", "moderate", "strong", "very strong", "extreme")))
    } else if (rules == "raftery1995") {
      interpretation <- interpret(bf, rules(c(1, 3, 20, 150), c("no", "weak", "positive", "strong", "very strong")))
    } else {
      stop("rules must be 'jeffreys1961', 'raftery1995' or an object of type rules.")
    }
  }

  if (include_value == FALSE) {
    return(paste0(interpretation, " evidence ", dir))
  } else {
    return(paste0(interpretation, " evidence (", parameters::format_bf(ori_bf), ") ", dir))
  }
}
