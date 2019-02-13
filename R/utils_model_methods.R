#' Model Values
#'
#' model values See the documentation for your object's class:
#' \itemize{
#'  \item{\link[=model_values.lm]{lm}}
#'  }
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @export
model_values <- function(model, ...) {
  UseMethod("model_values")
}



#' Model table
#'
#' Model table. See the documentation for your object's class:
#' \itemize{
#'  \item{\link[=model_table.lm]{lm}}
#'  }
#'
#' @param model Statistical Model.
#' @param ... Arguments passed to or from other methods (see \link{model_parameters} and \link{model_performance}).
#'
#'
#' @export
model_table <- function(model, ...) {
  UseMethod("model_table")
}



#' #' Retrieve Data
#' #'
#' #' Attempts at retrieving data from model. See the documentation for your object's class:
#' #' \itemize{
#' #'  \item{\link[=model_data.lm]{lm}}
#' #'  }
#' #'
#' #' @param model Statistical Model.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #'
#' #' @export
#' model_data <- function(model, ...) {
#'   UseMethod("model_data")
#' }
#'
#'
#'
#' #' Compute Indices of Model Performance
#' #'
#' #' Indices of model performance. See the documentation for your object's class:
#' #' \itemize{
#' #'  \item{\link[=model_performance.lm]{lm}}
#' #'  }
#' #'
#' #' @param model Statistical Model.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #'
#' #' @export
#' model_performance <- function(model, ...) {
#'   UseMethod("model_performance")
#' }
#'
#'
#'
#'
#' #' Model Description
#' #'
#' #' Model description. See the documentation for your object's class:
#' #' \itemize{
#' #'  \item{\link[=model_description.lm]{lm}}
#' #'  }
#' #'
#' #' @param model Statistical Model.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #'
#' #' @export
#' model_description <- function(model, ...) {
#'   UseMethod("model_description")
#' }
#'
#'
#'
#'
#'
#' #' Initial Model Parameters
#' #'
#' #' Initial model parameters. See the documentation for your object's class:
#' #' \itemize{
#' #'  \item{\link[=model_initial.lm]{lm}}
#' #'  }
#' #'
#' #' @param model Statistical Model.
#' #' @param ... Arguments passed to or from other methods.
#' #'
#' #' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#' #'
#' #' @export
#' model_initial <- function(model, ...) {
#'   UseMethod("model_initial")
#' }




