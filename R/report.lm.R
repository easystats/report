#' Linear Models Values
#'
#' Extract all values of linear models.
#'
#' @param model Object of class \link{lm}.
#' @param effsize Compute standardized parameters and interpret them using a set of rules. Can be "cohen1988" (default), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' model_values(model)
#' @importFrom insight model_info
#' @importFrom parameters model_parameters
#' @importFrom performance model_performance
#' @export
model_values.lm <- function(model, effsize = "cohen1988", ...) {

  # Information
  out <- list()
  out$info <- insight::model_info(model)

  # Tables
  if(!is.null(effsize)){
    out$table_parameters <- parameters::model_parameters(model, standardize = TRUE, ...)
    out$table_parameters$Effect_Size <- interpret_d(out$table_parameters$Std_beta, rules=effsize)
  } else{
    out$table_parameters <- parameters::model_parameters(model, ...)
  }
  out$table_performance <- performance::model_performance(model, ...)
  out$table_parameters$Parameter <- as.character(out$table_parameters$Parameter)



  # tables to values
  out$parameters <- list()
  for (param in out$table_parameters$Parameter) {
    out$parameters[[param]] <- as.list(out$table_parameters[out$table_parameters$Parameter == param, ])
  }

  out$performance <- list()
  for (perf in names(out$table_performance)) {
    out$performance[[perf]] <- out$table_performance[[perf]]
  }


  class(out) <- c("values_lm", class(out))
  return(out)
}








#' Create Tables for Linear Models
#
#' @param model Object of class \link{lm}.
#' @param performance Add performance metrics on table.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#' @examples
#' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' model_table(model)$table
#' @importFrom parameters model_parameters
#' @export
model_table.lm <- function(model, performance=TRUE, ...){

  if(!inherits(model, "values_lm")){
    model <- model_values(model, ...)
    }

  table_full <- model$table_parameters
  table <- table_full
  table <- table[, colnames(table) %in% c("Parameter", "beta", "CI_low", "CI_high", "p", "Std_beta", "Effect_Size")]

  if(performance){
    # Full ----
    perf <- data.frame(
      "Parameter" = colnames(model$table_performance),
      "Fit" = as.numeric(model$table_performance[1, ]),
      stringsAsFactors = FALSE)
    table_full <- dplyr::full_join(table_full, perf, by="Parameter")
    # Mini ----
    perf <- data.frame(
      "Parameter" = colnames(model$table_performance),
      "Fit" = as.numeric(model$table_performance[1, ]),
      stringsAsFactors = FALSE) %>%
      dplyr::filter_("Parameter %in% c('R2', 'R2_adj')")
    table <- dplyr::full_join(table, perf, by="Parameter")
  }

  class(table_full) <- c("report_table", class(table_full))
  class(table) <- c("report_table", class(table))

  out <- list("table_full" = table_full,
              "table" = table)
  return(out)
}

#' @export
model_table.values_lm <- model_table.lm














#' #' Retrieve Data from Linear Models
#' #'
#' #' Attempts at retrieving data from a linear model.
#' #'
#' #' @param model Object of class \link{lm}.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #' @importFrom stats getCall
#' #' @importFrom utils data
#' #' @importFrom stats formula
#' #' @export
#' model_data.lm <- function(model, ...) {
#'   data <- tryCatch({
#'     eval(getCall(model)$data, environment(formula(model)))
#'   }, error = function(e) {
#'     stop("Couldn't retrieve data from model. Please provide it.")
#'   })
#'   return(data)
#' }
#'
#'
#'

#'
#'
#'
#'
#' #' Linear Models Description
#' #'
#' #' Description for linear models.
#' #'
#' #' @param model Object of class \link{lm}.
#' #' @param effsize Compute standardized parameters and interpret them using a set of rules. Can be "cohen1988" (default), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #' @importFrom utils head tail
#' #' @importFrom stats as.formula
#' #' @export
#' model_description.lm <- function(model, effsize = "cohen1988", ...) {
#'   values <- list()
#'
#'   # Get variables
#'   if (!"values_lm" %in% class(model)) {
#'     model <- model_values(model, ...)
#'   }
#'
#'   values$Formula <- as.formula(model$Formula)
#'
#'
#'   predictors <- all.vars(values$Formula)
#'   values$Outcome <- predictors[[1]]
#'   values$Predictors <- tail(predictors, -1)
#'   values$Predictors_text <- format_text_collapse(values$Predictors)
#'
#'   text <- paste0(
#'     "We fitted a linear model to predict ",
#'     values$Outcome,
#'     " with ",
#'     values$Predictors_text
#'   )
#'   text_full <- paste0(text, " (formula = ", Reduce(paste, deparse(values$Formula)), ").")
#'   text <- paste0(text, ".")
#'
#'   # Effect size
#'   if (!is.null(effsize)) {
#'     if (is.character(effsize)) {
#'       effsize_name <- ifelse(effsize == "cohen1988", "Cohen's (1988)",
#'         ifelse(effsize == "sawilowsky2009", "Savilowsky's (2009)", effsize)
#'       )
#'       text_full <- paste0(text_full, " Effect sizes were labelled following ", effsize_name, " recommendations.")
#'     } else {
#'       text_full <- paste0(text_full, " Effect sizes were labelled following a custom set of rules.")
#'     }
#'   }
#'
#'   out <- list(
#'     text = text,
#'     text_full = text_full,
#'     values = values
#'   )
#'   return(as.report(out))
#' }
#' #' @export
#' model_description.values_lm <- model_description.lm
#'
#'
#'
#'
#'
#'
#' #' Linear Models Performance
#' #'
#' #' Indices of model performance for linear models.
#' #'
#' #' @param model Object of class \link{lm}.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #'
#' #' @export
#' model_performance.lm <- function(model, ...) {
#'   if (!"values_lm" %in% class(model)) {
#'     model <- model_values(model, ...)
#'   }
#'
#'   R2 <- model$R2
#'   R2_adj <- model$R2_adj
#'   F_value <- model$`F`
#'   DoF <- model$DoF
#'   DoF_residual <- model$DoF_residual
#'   p <- model$p
#'
#'
#'   text <- paste0(
#'     "The model's explanatory power (R2) is of ",
#'     format_value(R2),
#'     " (adj. R2 = ",
#'     format_value(R2_adj),
#'     ")."
#'   )
#'
#'   text_full <- paste0(
#'     "The model explains a ",
#'     interpret_p(p),
#'     " proportion of variance (R2 = ",
#'     format_value(R2),
#'     ", F(",
#'     format_value_unless_integers(DoF),
#'     ", ",
#'     format_value_unless_integers(DoF_residual),
#'     ") = ",
#'     format_value(F_value),
#'     ", p ",
#'     format_p(p),
#'     ", adj. R2 = ",
#'     format_value(R2_adj),
#'     ")."
#'   )
#'
#'   table <- data.frame(
#'     R2 = R2,
#'     R2_adj = R2_adj
#'   )
#'
#'   table_full <- data.frame(
#'     R2 = R2,
#'     R2_adj = R2_adj,
#'     `F` = F_value,
#'     DoF_residual = DoF_residual,
#'     DoF = DoF,
#'     p = p
#'   )
#'
#'
#'   out <- list(
#'     table = table,
#'     table_full = table_full,
#'     text = text,
#'     text_full = text_full
#'   )
#'   return(as.report(out))
#' }
#' #' @export
#' model_performance.values_lm <- model_performance.lm
#'
#'
#'
#'
#' #' Linear Models Initial Parameters
#' #'
#' #' Initial parameters for linear models.
#' #'
#' #' @param model Object of class \link{lm}.
#' #' @param ... Arguments passed to or from other methods.
#' #' @examples
#' #' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #'
#' #' @export
#' model_initial.lm <- function(model, ...) {
#'   if (!"values_lm" %in% class(model)) {
#'     model <- model_values(model, ...)
#'   }
#'
#'   table <- data.frame(Intercept = model$Parameters$`(Intercept)`$beta)
#'   text <- paste0(
#'     "The model's intercept is at ",
#'     format_value(table$Intercept[1]),
#'     "."
#'   )
#'
#'   table_full <- table
#'   table_full$t <- model$Parameters$`(Intercept)`$t
#'   table_full$CI_low <- model$Parameters$`(Intercept)`$CI_low
#'   table_full$CI_high <- model$Parameters$`(Intercept)`$CI_high
#'   table_full$CI <- model$CI
#'   table_full$p <- model$Parameters$`(Intercept)`$p
#'
#'   text_full <- paste0(
#'     "The model's intercept is at ",
#'     format_value(table_full$Intercept[1]),
#'     "(t(",
#'     format_value_unless_integers(table_full$DoF_residual[1]),
#'     ") = ",
#'     format_value(table_full$t[1]),
#'     ", ",
#'     format_CI(table_full$CI_low[1], table_full$CI_high[1], table_full$CI[1]),
#'     ", p ",
#'     format_p(table_full$p[1]),
#'     ")."
#'   )
#'
#'   out <- list(
#'     table = table,
#'     table_full = table,
#'     text = text,
#'     text_full = text_full
#'   )
#'   return(as.report(out))
#' }
#' #' @export
#' model_initial.values_lm <- model_initial.lm
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
#'
#' #' Linear Models Description
#' #'
#' #' Description for linear models.
#' #'
#' #' @param model Object of class \link{lm}.
#' #' @param effsize Compute standardized parameters and interpret them using a set of rules. Can be "cohen1988" (default), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #' @import dplyr
#' #' @export
#' model_parameters.lm <- function(model, effsize = "cohen1988", ...) {
#'   if (!"values_lm" %in% class(model)) {
#'     model <- model_values(model, effsize = effsize, ...)
#'   }
#'
#'   table <- model$table_parameters[c("Parameter", "beta", "CI_low", "CI_high", "p")]
#'   if ("Std_beta" %in% names(model$table_parameters)) {
#'     table_full <- model$table_parameters[c("Parameter", "beta", "SE", "t", "DoF_residual", "CI_low", "CI_high", "p", "Std_beta", "Std_SE", "Std_CI_low", "Std_CI_high")]
#'   } else {
#'     table_full <- model$table_parameters[c("Parameter", "beta", "SE", "t", "DoF_residual", "CI_low", "CI_high", "p")]
#'   }
#'
#'
#'   params <- table_full[-1, ]
#'   params$CI <- format_CI(params$CI_low, params$CI_high, model$CI)
#'   params$p_formatted <- paste0("p ", format_p(params$p))
#'
#'   # Effect size text
#'   if ("Std_beta" %in% names(params)) {
#'     params$effsize_text <- paste0(
#'       " and ",
#'       interpret_d(params$Std_beta, rules = effsize),
#'       " (Std. beta = ",
#'       format_value(params$Std_beta),
#'       ")."
#'     )
#'     params$effsize_text_full <- paste0(
#'       " and ",
#'       interpret_d(params$Std_beta, rules = effsize),
#'       " (Std. beta = ",
#'       format_value(params$Std_beta),
#'       ", Std. SE = ",
#'       format_value(params$Std_SE),
#'       ", Std. ",
#'       format_CI(params$Std_CI_low, params$Std_CI_high, model$CI),
#'       ")."
#'     )
#'     params$significant_full <- paste0(interpret_direction(params$beta), ", ", interpret_p(params$p))
#'   } else {
#'     params$effsize_text <- "."
#'     params$effsize_text_full <- "."
#'     params$significant_full <- paste0(interpret_direction(params$beta), " and ", interpret_p(params$p))
#'   }
#'
#'
#'   text <- paste0(
#'     "  - ",
#'     params$Parameter,
#'     " is ",
#'     interpret_p(params$p),
#'     " (beta = ",
#'     format_value(params$beta),
#'     ", ",
#'     params$CI,
#'     ", ",
#'     params$p_formatted,
#'     ")",
#'     params$effsize_text
#'   )
#'   text <- paste0(c("\n\nWithin this model: ", text), collapse = "\n")
#'
#'   text_full <- paste0(
#'     "  - ",
#'     params$Parameter,
#'     " is ",
#'     params$significant_full,
#'     " (beta = ",
#'     format_value(params$beta),
#'     ", t(",
#'     format_value_unless_integers(params$DoF_residual),
#'     ") = ",
#'     format_value(params$t),
#'     ", ",
#'     params$CI,
#'     ", ",
#'     params$p_formatted,
#'     ")",
#'     params$effsize_text_full
#'   )
#'   text_full <- paste0(c("\n\nWithin this model: ", text_full), collapse = "\n")
#'
#'
#'   out <- list(
#'     table = table,
#'     table_full = table_full,
#'     text = text,
#'     text_full = text_full
#'   )
#'   return(as.report(out))
#' }
#'
#' #' @export
#' model_parameters.values_lm <- model_parameters.lm
#'
#'
#'
#'
#'
#'
#'
#'
#' #' Linear Models Report
#' #'
#' #' Create a report of a linear model.
#' #'
#' #' @param x Object of class \link{lm}.
#' #' @param CI Confidence Interval (CI) level. Default to 95\%.
#' #' @param effsize Compute standardized parameters and interpret them using a set of rules. Can be "cohen1988" (default), "sawilowsky2009", NULL, or a custom set of \link{rules}.
#' #' @param data Dataframe used to fit the model. Can be useful to compute standardized parameters.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @examples
#' #' model <- lm(Sepal.Length ~ Petal.Length * Species, data = iris)
#' #' r <- report(model)
#' #' to_text(r)
#' #' to_fulltext(r)
#' #' to_table(r)
#' #' to_fulltable(r)
#' #' @export
#' report.lm <- function(x, CI = 95, effsize = "cohen1988", data = NULL, ...) {
#'   model <- x
#'   values <- model_values(model, CI = CI, effsize = effsize, data = data)
#'
#'   description <- model_description(values, effsize = effsize)
#'   performance <- model_performance(values)
#'   initial <- model_initial(values)
#'   parameters <- model_parameters(values, effsize = effsize)
#'
#'   text <- paste(
#'     description$text,
#'     performance$text,
#'     initial$text,
#'     parameters$text
#'   )
#'   text_full <- paste(
#'     description$text_full,
#'     performance$text_full,
#'     initial$text_full,
#'     parameters$text_full
#'   )
#'
#'   out <- list(
#'     table = parameters$table,
#'     table_full = parameters$table_full,
#'     text = text,
#'     text_full = text_full,
#'     values = values
#'   )
#'   return(as.report(out))
#' }
