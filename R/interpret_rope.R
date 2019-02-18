#' ROPE percentage Interpretation
#'
#' @param rope_percentage Value or vector of ROPE-percentages.
#' @param ci The Credible Interval (CI) probability, corresponding to the proportion of HDI, that was used.
#' @param rules Can be \href{https://easystats.github.io/bayestestR/articles/4_Guidelines.html}{"default"} or custom set of rules.
#'
#' @references \href{https://easystats.github.io/bayestestR/articles/4_Guidelines.html}{BayestestR's reporting guidelines}
#' @examples
#' interpret_rope(0, ci = 0.9)
#' interpret_rope(c(0.5, 99), ci = 1)
#' @export
interpret_rope <- function(rope_percentage, ci = 0.9, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(rope_percentage, rules))
  } else {
    if (rules == "default") {
      if (ci < 1) {
        return(ifelse(rope_percentage == 0, "significant",
          ifelse(rope_percentage == 100, "negligible", "not significant")
        ))
      } else {
        return(ifelse(rope_percentage < 1, "significant",
          ifelse(rope_percentage < 2.5, "probably significant",
            ifelse(rope_percentage > 99, "negligible",
              ifelse(rope_percentage > 97.5, "probably negligible", "not significant")
            )
          )
        ))
      }
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}
