#' Interpretation Grid
#'
#' Create a container for interpretation rules of thumb. See \link{interpret}.
#'
#' @param breakpoints Vector of value break points (edges defining categories).
#' @param labels Labels associated with each category. Must contain one label more than breakpoints.
#' @param if_lower If true, each label will be given if the value is strictly lower than its breakpoint. The contrary if false.
#'
#'
#'
#'
#' @examples
#' rules(c(0.05), c("significant", "not significant"), if_lower = TRUE)
#' @export
rules <- function(breakpoints, labels, if_lower = TRUE) {
  if (length(breakpoints) != length(labels) - 1) {
    stop("There must be exactly one more label than breakpoints.")
  } else if (is.unsorted(breakpoints)) {
    stop("Breakpoints must be sorted.")
  }

  out <- list(
    breakpoints = breakpoints,
    labels = labels,
    if_lower = if_lower
  )
  class(out) <- c("rules", "list")
  return(out)
}




#' Test for objects of class \link{rules}
#'
#' @param x An arbitrary R object.
#'
#' @export
is.rules <- function(x) inherits(x, "rules")


#' Interpret Values
#'
#' Interpret a value based on a set of rules. See \link{rules}.
#'
#' @param x Vector of value break points (edges defining categories).
#' @param rules Set of \link{rules}.
#'
#'
#' @examples
#' rules_grid <- rules(c(0.01, 0.05), c("very significant", "significant", "not significant"))
#' interpret(0.001, rules_grid)
#' interpret(0.021, rules_grid)
#' interpret(0.08, rules_grid)
#' interpret(c(0.01, 0.005, 0.08), rules_grid)
#' @export
interpret <- function(x, rules) {
  if (length(x) > 1) {
    return(sapply(x, .interpret, rules))
  } else {
    return(.interpret(x, rules))
  }
}




#' @keywords internal
.interpret <- function(x, rules) {
  if (rules$if_lower == TRUE) {
    check <- x < rules$breakpoints
    if (TRUE %in% check) {
      index <- min(which(check))
    } else {
      index <- length(rules$labels)
    }
  } else {
    check <- x <= rules$breakpoints
    if (TRUE %in% check) {
      index <- min(which(check))
    } else {
      index <- length(rules$labels)
    }
  }
  out <- rules$labels[index]
  return(out)
}
