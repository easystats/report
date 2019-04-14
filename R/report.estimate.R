#' Estimated Means, Contrasts, Slopes and Smooth Report
#'
#' Create a report of an object from the \code{estimate} package.
#'
#' @param model Object of class \code{estimate}
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' \dontrun{
#' library(estimate)
#' library(rstanarm)
#'
#' model <- stan_glm(Sepal.Width ~ Species * Petal.Width, data = iris)
#' report(estimate_contrasts(model))
#' report(estimate_contrasts(model, fixed = "Petal.Width"))
#' report(estimate_contrasts(model, modulate = "Petal.Width", length = 2))
#' }
#'
#' @seealso report
#'
#' @export
report.estimateContrasts <- function(model, ...) {
  # Tables ----
  full_table <- model

  cols_to_remove <- c("MAD", "SD", "t", "z", "DoF", "ROPE_Equivalence")
  table <- full_table[!names(full_table) %in% cols_to_remove]

  # Text ----
  ## General
  attri <- attributes(model)
  description <- "The contrast anaysis, based on estimated marginal means"

  if(!is.null(attri$fixed)){
    description <- paste0(description,
                          " (adjusted for ",
                          attri$fixed,
                          ")")
  }
  description <- paste0(description,
                        ", suggested that:\n\n")


  ## Params
  parameters <- full_table
  if(!is.null(attri$modulate)){
    parameters$Parameter <- paste0("The difference between ",
                                   parameters$Level1, " and ",
                                   parameters$Level2, " when ",
                                   attri$modulate, " is ",
                                   parameters[[attri$modulate]])
  } else{
    parameters$Parameter <- paste0("The difference between ",
                                   parameters$Level1, " and ",
                                   parameters$Level2)
  }

  text_params <- model_text_parameters_bayesian(model=NULL, parameters, ci = attri$ci, rope_full = attri$rope_full)
  text_full <- paste0(description,
                      text_params$text_full)
  text <- paste0(description,
                 text_params$text)


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = full_table,
    values = as.list(full_table)
  )

  return(as.report(out))
}









#' @examples
#' \dontrun{
#' library(rstanarm)
#' model <- stan_glm(Sepal.Width ~ Species * Petal.Width, data = iris)
#' report(estimate_means(model))
#' }
#' @rdname report.estimateContrasts
#' @export
report.estimateMeans <- function(model, ...) {
  # Tables ----
  full_table <- model

  cols_to_remove <- c("MAD", "SD")
  table <- full_table[!names(full_table) %in% cols_to_remove]

  # Text ----
  ## General
  attri <- attributes(model)
  levels <- attri$levels[!attri$levels %in% attri$fixed]
  description <- "The estimated means"

  if(!is.null(attri$fixed)){
    description <- paste0(description,
                          " (adjusted for ",
                          attri$fixed,
                          ")")
  }
  description <- paste0(description,
                        " of the levels of ",
                        levels,
                        " are the following:\n\n")


  ## Params
  parameters <- full_table
  parameters$Parameter <- parameters[, levels]

  text_params <- model_text_parameters_bayesian(model=NULL, parameters, ci = attri$ci)
  text_full <- paste0(description,
                      text_params$text_full)
  text <- paste0(description,
                 text_params$text)


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = full_table,
    values = as.list(full_table)
  )

  return(as.report(out))
}
























#' @examples
#' \dontrun{
#' library(rstanarm)
#' model <- stan_glm(Sepal.Width ~ Species * Petal.Width, data = iris)
#' report(estimate_slopes(model))
#' }
#' @rdname report.estimateContrasts
#' @export
report.estimateSlopes <- function(model, ...) {
  # Tables ----
  full_table <- model

  cols_to_remove <- c("MAD", "SD", "t", "z", "DoF", "ROPE_Equivalence")
  table <- full_table[!names(full_table) %in% cols_to_remove]

  # Text ----
  ## General
  attri <- attributes(model)
  description <- "The estimated coefficients"

  if(!is.null(attri$fixed)){
    description <- paste0(description,
                          " (adjusted for ",
                          attri$fixed,
                          ")")
  }
  description <- paste0(description,
                        " of ",
                        attri$trend,
                        " in the levels of ",
                        attri$levels,
                        " are the following:\n\n")


  ## Params
  parameters <- full_table
  parameters$Parameter <- paste0("In ",
                                 parameters[, attri$levels[!attri$levels %in% attri$fixed]],
                                 ", the effect of ",
                                 attri$trend)

  text_params <- model_text_parameters_bayesian(model=NULL, parameters, ci = attri$ci, rope_full = attri$rope_full)
  text_full <- paste0(description,
                      text_params$text_full)
  text <- paste0(description,
                 text_params$text)


  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = full_table,
    values = as.list(full_table)
  )

  return(as.report(out))
}




















#' @examples
#' \dontrun{
#' library(rstanarm)
#' model <- stan_glm(Sepal.Width ~ poly(Petal.Length, 2), data=iris)
#' report(estimate_smooth(model))
#' }
#' @rdname report.estimateContrasts
#' @export
report.estimateSmooth <- function(model, ...) {
  # Tables ----
  full_table <- model
  table <- full_table

  # Text ----
  ## General
  attri <- attributes(model)
  description <- paste0("The effect of ",
                        attri$smooth,
                        " can be described by the following linear approximation:\n\n")


  ## Params
  parameters <- full_table
  if(is.null(attri$levels)){
    text <- .format_smooth_part(parameters)

  } else{
    parameters$Group <- paste(parameters[, attri$levels])
    text <- c()
    for(group in unique(parameters$Group)){
      text <- c(text, paste0("- In ", group))

      current_params <- parameters[parameters$Group == group, ]
      current_text <- .format_smooth_part(current_params)
      text <- c(text, current_text)
      }
    }

  text <- paste0(description, paste0(text, collapse = "\n"))

  out <- list(
    text = text,
    text_full = text,
    table = table,
    table_full = full_table,
    values = as.list(full_table)
  )

  return(as.report(out))
}


#' @keywords internal
.format_smooth_part <- function(parameters){
  parameters$TrendText <- ifelse(!is.na(parameters$Trend),
                                 paste0(interpret_direction(parameters$Trend),
                                        " trend (linear coefficient = ",
                                        format_value(parameters$Trend),
                                        ")"),
                                 "part")

  text <- paste0("  - A ",
                 parameters$TrendText,
                 " starting at ",
                 format_value(parameters$Start),
                 " and ending at ",
                 format_value(parameters$End),
                 " (",
                 format_value(parameters$Size*100),
                 "% of the total size)")
  return(text)
}