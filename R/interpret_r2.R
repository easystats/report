#' Coefficient of determination  (R2) Interpretation
#'
#' @param r2 Value or vector of R2 values.
#' @param rules Can be "cohen1988" (default), "falk1992", "chin1998", "hair2011" or custom set of rules.
#'
#' @examples
#' interpret_r2(.02)
#' interpret_r2(c(.5, .02))
#' @references
#' \itemize{
#'   \item Cohen, J. (1988). Statistical power analysis for the behavioural sciences.
#'   \item Falk, R. F., & Miller, N. B. (1992). A primer for soft modeling. University of Akron Press.
#'   \item Chin, W. W. (1998). The partial least squares approach to structural equation modeling. Modern methods for business research, 295(2), 295-336.
#'   \item Hair, J. F., Ringle, C. M., & Sarstedt, M. (2011). PLS-SEM: Indeed a silver bullet. Journal of Marketing theory and Practice, 19(2), 139-152.
#' }
#' @export
interpret_r2 <- function(r2, rules = "cohen1988") {
  if (is.rules(rules)) {
    return(interpret(r2, rules))
  } else {
    if (rules == "cohen1988") {
      return(interpret(r2, rules(c(0.02, 0.13, 0.26), c("very weak", "weak", "moderate", "substantial"))))
    } else if (rules == "falk1992") {
      return(interpret(r2, rules(c(0.10), c("negligible", "adequate"))))
    } else if (rules == "chin1998") {
      return(interpret(r2, rules(c(0.19, 0.33, 0.67), c("very weak", "weak", "moderate", "substantial"))))
    } else if (rules == "hair2011") {
      return(interpret(r2, rules(c(0.25, 0.50, 0.75), c("very weak", "weak", "moderate", "substantial"))))
    } else {
      stop("rules must be 'cohen1988', 'sawilowsky2009' or an object of type rules.")
    }
  }
}
