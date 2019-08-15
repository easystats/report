#' ROPE percentage Interpretation
#'
#' @param rope_percentage Value or vector of ROPE-percentages.
#' @param ci The Credible Interval (CI) probability, corresponding to the proportion of HDI, that was used. Can be \code{1} in the case of "full ROPE".
#' @param rules Can be \href{https://easystats.github.io/bayestestR/articles/guidelines.html}{"default"} or custom set of rules.
#'
#' @references \href{https://easystats.github.io/bayestestR/articles/guidelines.html}{BayestestR's reporting guidelines}
#' @examples
#' interpret_rope(0, ci = 0.9)
#' interpret_rope(c(0.005, 0.99), ci = 1)
#' @export
interpret_rope <- function(rope_percentage, ci = 0.9, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(rope_percentage, rules))
  } else {
    if (rules == "default") {
      if (ci < 1) {
        return(ifelse(rope_percentage == 0, "significant",
          ifelse(rope_percentage == 1, "negligible", "not significant")
        ))
      } else {
        return(ifelse(rope_percentage < 0.01, "significant",
          ifelse(rope_percentage < 0.025, "probably significant",
            ifelse(rope_percentage > 0.99, "negligible",
              ifelse(rope_percentage > 0.975, "probably negligible", "not significant")
            )
          )
        ))
      }
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}
