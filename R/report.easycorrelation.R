#' #' Correlation Report
#' #'
#' #' Create a report of a correlation object.
#' #'
#' #' @param model Object of class easycorrelation.
#' #' @param effsize Effect size interpretation set of rules. Can be "cohen1988" (default), "evans1996" or custom set of rules.
#' #' @param stars Add significance stars in table. For frequentist correlations: \*p < .05, \*\*p < .01, \*\*\*p < .001. For Bayesian correlations: \*\*\*BF > 30, \*\*BF > 10, \*BF > 3.
#' #' @param lower Remove the upper triangular part of the matrix.
#' #' @param reorder Reorder the matrix based on correlation pattern (currently only works with square matrices).
#' #' @param reorder_method Reordering method. See \link{hclust}.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #'
#' #'
#' #' @examples
#' #' model <- correlation(iris)
#' #' report(model)
#' #' @seealso report
#' #'
#' #' @export
#' report.easycorrelation <- function(model, effsize = "cohen1988", stars=TRUE, lower=TRUE, reorder=TRUE, reorder_method="complete", ...) {
#'
#'   # Text ----
#'
#'
#'   info <- as.list(model)
#'
#'   if(info$bayesian){
#'     if(info$ci == "default"){
#'       info$ci <- .9
#'     }
#'     description <- paste0(
#'       "We ran a Bayesian correlation analysis (prior scale set to ",
#'       info$prior,
#'       ").",
#'       .format_ROPE_description(info$rope_full, info$rope_bounds, info$ci))
#'   } else{
#'     if(info$ci == "default"){
#'       info$ci <- .95
#'     }
#'
#'     if(info$partial == TRUE){
#'       description <- "We ran a partial correlation analysis"
#'     } else if(info$partial == "semi"){
#'       description <- "We ran a semi-partial correlation analysis"
#'     } else{
#'       description <- "We ran a correlation analysis"
#'     }
#'
#'     if(info$p_adjust != "none"){
#'       description <- paste0(description, " with p-values adjusted using ", info$p_adjust, " correction")
#'     }
#'     description <- paste0(description, ".")
#'   }
#'
#'   description <- paste0(description, .format_effsize_description(effsize))
#'
#'   estimate <- c("rho", "r", "tau", "Median")[c("rho", "r", "tau", "Median") %in% names(model)]
#'   if("Group" %in% names(model)){
#'     group <- paste0("In ", model$Group, ", the")
#'   } else{
#'     group <- "the"
#'   }
#'
#'   if("CI_low" %in% names(model)){
#'     ci_text <- paste0(", ", insight::format_ci(model$CI_low, model$CI_high, info$ci))
#'   } else{
#'     ci_text <- ""
#'   }
#'
#'   if(info$bayesian == FALSE){
#'     text <- paste0(
#'       "  - ",
#'       group,
#'       " correlation between ",
#'       model$Parameter1,
#'       " and ",
#'       model$Parameter2,
#'       " is ",
#'       interpret_direction(model[[estimate]]),
#'       ", ",
#'       interpret_p(model$p),
#'       " and ",
#'       interpret_r(model[[estimate]], rules=effsize),
#'       " (",
#'       estimate,
#'       " = ",
#'       format_value(model[[estimate]]),
#'       ci_text,
#'       ", p ",
#'       format_p(model$p, stars = FALSE),
#'       ")."
#'     )
#'   } else{
#'     text <- paste0(
#'       "  - There is ",
#'       interpret_bf(model$BF, include_bf=TRUE),
#'       " a ",
#'       interpret_direction(model[[estimate]]),
#'       " and ",
#'       interpret_r(model[[estimate]], rules=effsize),
#'       " correlation between ",
#'       model$Parameter1,
#'       " and ",
#'       model$Parameter2,
#'       " (r's median = ",
#'       format_value(model[[estimate]]),
#'       ci_text,
#'       ", ",
#'       format_pd(model$pd),
#'       ", ",
#'       format_rope(model$ROPE_Percentage),
#'       ")."
#'     )
#'   }
#'
#'   text <- paste0(text, collapse = "\n")
#'   text <- paste0(description, "\n\n", text)
#'   text_full <- text
#'
#'
#'   # Tables ----
#'   distance_matrix <- as.table(model, lower=FALSE, reorder=FALSE)
#'
#'   # Table
#'   data <- model
#'   if("Median" %in% names(data)){
#'     data$value <- format_value(data$Median)
#'   } else{
#'     data$value <- format_value(data$r)
#'   }
#'
#'   if(stars){
#'     data$value <- paste0(data$value, .add_stars(data))
#'   }
#'
#'
#'   table <- as.table(data, which_column="value", lower=lower, reorder=reorder, reorder_method=reorder_method, reorder_distance=distance_matrix)
#'
#'   # Fulltable
#'   if("Median" %in% names(data)){
#'     data$value <- paste0("r's median = ", format_value(data$Median))
#'   } else{
#'     data$value <- paste0("r = ", format_value(data$r))
#'   }
#'   if("CI_low" %in% names(data)){
#'     data$value <- paste0(data$value, ", ", insight::format_ci(data$CI_low, data$CI_high, info$ci))
#'   }
#'   if("p" %in% names(data)){
#'     data$value <- paste0(data$value, ", p ", format_p(data$p))
#'   }
#'   if("BF" %in% names(data)){
#'     data$value <- paste0(data$value, ", ", format_bf(data$BF))
#'   }
#'   if(stars){
#'     data$value <- paste0(data$value, .add_stars(data))
#'   }
#'   table_full <- as.table(data, which_column="value", lower=lower, reorder=reorder, reorder_method=reorder_method, reorder_distance=distance_matrix)
#'
#'
#'
#'   out <- list(
#'     text = text,
#'     text_full = text_full,
#'     table = table,
#'     table_full = table_full,
#'     values = as.list(model)
#'   )
#'
#'   return(as.report(out))
#' }
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#' #' @keywords internal
#' .add_stars <- function(data){
#'   if("p" %in% names(data)){
#'     stars <- ifelse(data$p < .001, "***",
#'            ifelse(data$p < .01, "**",
#'                   ifelse(data$p < .05, "*", "")))
#'   } else if("BF" %in% names(data)){
#'     stars <- ifelse(data$BF > 30, "***",
#'                     ifelse(data$BF > 10, "**",
#'                            ifelse(data$BF > 3, "*", "")))
#'   } else{
#'     stars <- ""
#'   }
#'   return(stars)
#' }
#'
#'
#'
#'
