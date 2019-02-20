#' Correlation Report
#'
#' Create a report of a correlation object.
#'
#' @param model Object of class correlation
#' @param effsize Effect size interpretation set of rules.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' model <- correlation(iris)
#' report(model)
#' @seealso report
#'
#' @export
report.correlation <- function(model, effsize = "cohen1988", ...) {

  info <- as.list(model)

  if(info$bayesian){
    if(info$ci == "default"){
      info$ci <- .9
    }
    description <- paste0(
      "We ran a Bayesian correlation analysis (prior scale set to ",
      info$prior,
      ").",
      .format_ROPE_description(info$rope_full, info$rope_bounds, info$ci))
  } else{
    if(info$ci == "default"){
      info$ci <- .95
    }

    if(info$partial == TRUE){
      description <- "We ran a partial correlation analysis"
    } else if(info$partial == "semi"){
      description <- "We ran a semi-partial correlation analysis"
    } else{
      description <- "We ran a correlation analysis"
    }

    if(info$p_adjust != "none"){
      description <- paste0(description, " with p-values adjusted using ", info$p_adjust, " correction")
    }
    description <- paste0(description, ".")
  }

  description <- paste0(description, .format_effsize_description(effsize))

  estimate <- c("rho", "r", "tau", "Median")[c("rho", "r", "tau", "Median") %in% names(model)]
  if("Group" %in% names(model)){
    group <- paste0("In ", model$Group, ", the")
  } else{
    group <- "the"
  }

  if("CI_low" %in% names(model)){
    ci_text <- paste0(", ", format_ci(model$CI_low, model$CI_high, info$ci))
  } else{
    ci_text <- ""
  }

  if(info$bayesian == FALSE){
    text <- paste0(
      "  - ",
      group,
      " correlation between ",
      model$Parameter1,
      " and ",
      model$Parameter2,
      " is ",
      interpret_direction(model[[estimate]]),
      ", ",
      interpret_p(model$p),
      " and ",
      interpret_r(model[[estimate]], rules=effsize),
      " (",
      estimate,
      " = ",
      format_value(model[[estimate]]),
      ci_text,
      ", p ",
      format_p(model$p, stars = FALSE),
      ")."
    )
  } else{
    text <- paste0(
      "  - There is ",
      interpret_bf(model$BF, include_bf=TRUE),
      " a ",
      interpret_direction(model[[estimate]]),
      " and ",
      interpret_r(model[[estimate]], rules=effsize),
      " correlation between ",
      model$Parameter1,
      " and ",
      model$Parameter2,
      " (r's median = ",
      format_value(model[[estimate]]),
      ci_text,
      ", ",
      format_pd(model$pd),
      ", ",
      format_rope(model$ROPE_Percentage),
      ")."
    )
  }

  text <- paste0(text, collapse = "\n")
  text <- paste0(description, "\n\n", text)
  text_full <- text

  table <- model
  table_full <- table

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  return(as.report(out))
}
