#' Interpretation of SEM/CFA Indices of Fit
#'
#' Interpretation of SEM/CFA Indices of Fit
#'
#' @param x vector of values.
#' @param rules Can be "default" or custom set of rules.
#'
#' @inherit performance::model_performance.lavaan details
#' @inherit performance::model_performance.lavaan references
#'
#' @examples
#' interpret_gfi(c(.5, .99))
#' interpret_agfi(c(.5, .99))
#' interpret_nfi(c(.5, .99))
#' interpret_nnfi(c(.5, .99))
#' interpret_cfi(c(.5, .99))
#' interpret_rmsea(c(.5, .99))
#' interpret_srmr(c(.5, .99))
#' interpret_rfi(c(.5, .99))
#' interpret_ifi(c(.5, .99))
#' interpret_pnfi(c(.5, .99))
#' @export
interpret_gfi <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.95), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}


#' @rdname interpret_gfi
#' @export
interpret_agfi <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.90), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}


#' @rdname interpret_gfi
#' @export
interpret_nfi <- function(x, rules = "byrne1994") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "byrne1994") {
      return(interpret(x, rules(c(0.90), c("poor", "satisfactory"))))
    } else if (rules == "schumacker2004") {
      return(interpret(x, rules(c(0.95), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}

#' @rdname interpret_gfi
#' @export
interpret_nnfi <- interpret_nfi


#' @rdname interpret_gfi
#' @export
interpret_cfi <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.90), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}




#' @rdname interpret_gfi
#' @export
interpret_rmsea <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.05), c("satisfactory", "poor"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}


#' @rdname interpret_gfi
#' @export
interpret_srmr <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.08), c("satisfactory", "poor"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}

#' @rdname interpret_gfi
#' @export
interpret_rfi <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.90), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}

#' @rdname interpret_gfi
#' @export
interpret_ifi <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.90), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}

#' @rdname interpret_gfi
#' @export
interpret_pnfi <- function(x, rules = "default") {
  if (is.rules(rules)) {
    return(interpret(x, rules))
  } else {
    if (rules == "default") {
      return(interpret(x, rules(c(0.50), c("poor", "satisfactory"))))
    } else {
      stop("rules must be 'default' or an object of type rules.")
    }
  }
}