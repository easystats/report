#' Contrasts Estimate Report
#'
#' Create a report of an contrasts estimate object.
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
#' report(estimate_contrasts(model, modulate = "Petal.Width", length = 4))
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
