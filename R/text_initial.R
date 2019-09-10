#' Initial model state textual reporting
#'
#' Convert initial state parameters table to text.
#'
#' @param model Object.
#' @param parameters Parameters table.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @seealso report
#'
#' @export
text_initial <- function(model, parameters, ...) {
  UseMethod("text_initial")
}







#' @export
text_initial.lm <- function(model, parameters, ci = 0.95, ...) {
  .text_intercept(model, parameters, ci = ci, ...)
}

#' @export
text_initial.glm <- text_initial.lm

#' @export
text_initial.merMod <- text_initial.lm




#' @keywords internal
.text_intercept <- function(model, parameters, ci = 0.95, ...) {
  intercept <- parameters[parameters$Parameter == "(Intercept)", ]

  coefficient <- names(parameters)[names(parameters) %in% c("Coefficient", "Median", "Mean", "MAP")][1]
  is_at <- insight::format_value(intercept[[coefficient]])

  intercept[[coefficient]] <- NULL

  text <- paste0(
    " The model's intercept is at ",
    insight::format_value(is_at),
    "."
  )
  text_full <- paste0(
    " The model's intercept",
    .find_intercept(model),
    " is at ",
    insight::format_value(is_at),
    " (",
    .text_parameters_indices(intercept, ci = ci),
    ")."
  )

  text_full <- gsub("std. beta", "std. intercept", text_full, fixed = TRUE)

  list(
    "text" = text,
    "text_full" = text_full
  )
}




#' @keywords internal
.find_intercept <- function(model) {

  # Intercept-only
  if (all(insight::find_parameters(model, flatten = FALSE) == "(Intercept)")) {
    return("")
  }

  terms <- insight::find_variables(model)$conditional
  data <- insight::get_data(model)[terms %in% names(insight::get_data(model))]
  text <- c()
  for (col in names(data)) {
    if (is.numeric(data[[col]])) {
      text <- c(text, paste0(col, " = 0"))
    } else if (is.character(data[[col]])) {
      data[col] <- as.character(data[col])
      text <- c(text, paste0(col, " = ", levels(data[[col]])[1]))
    } else if (is.factor(data[[col]])) {
      text <- c(text, paste0(col, " = ", levels(data[[col]])[1]))
    } else {
      text <- c(text, paste0(col, " = [?]"))
    }
  }
  paste0(", corresponding to ", format_text(text), ",")
}
