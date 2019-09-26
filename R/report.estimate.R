#' Estimated Means, Contrasts, Slopes and Smooth Report
#'
#' Create a report of an object from the \code{estimate} package.
#'
#' @param model Object of class \code{estimate}.
#' @inheritParams report.lm
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' library(estimate)
#' library(report)
#'
#' data <- iris
#' data$Group <- ifelse(data$Sepal.Width > 3, "A","B")
#'
#' model <- lm(Petal.Width ~ Species * Group, data = data)
#' report(estimate_contrasts(model))
#' \dontrun{
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
report.estimate_contrasts <- function(model, effsize = "funder2019", ...) {
  .report_estimate(model, effsize = effsize)
}


#' @keywords internal
.report_estimate <- function(model, effsize = "funder2019", ...) {
  # Tables ----
  table_full <- as.data.frame(model)
  table <- table_full[!names(table_full) %in% c("MAD", "SD", "t", "z", "df")]

  # Text ----

  # Description
  text <- text_model(model, effsize = effsize)
  text_full <- text$text_full
  text <- text$text

  # Params
  text <- paste0(text, text_parameters(model, parameters = table))
  text_full <- paste0(text_full, text_parameters(model, parameters = table_full))

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  as.report(out)
}





#' @examples
#' \dontrun{
#' library(estimate)
#' library(rstanarm)
#'
#' model <- stan_glm(Sepal.Width ~ Species * Petal.Width, data = iris)
#' report(estimate_means(model))
#' report(estimate_means(model, modulate = "Petal.Width"))
#' }
#' @rdname report.estimate_contrasts
#' @export
report.estimate_means <- report.estimate_contrasts




#' @examples
#' \dontrun{
#' library(rstanarm)
#' model <- stan_glm(Sepal.Width ~ Species * Petal.Width, data = iris)
#' report(estimate_slopes(model))
#' }
#' @rdname report.estimate_contrasts
#' @export
report.estimate_slopes <- report.estimate_contrasts



#' @examples
#' \dontrun{
#' library(rstanarm)
#' model <- stan_glm(Sepal.Width ~ poly(Petal.Length, 2), data = iris)
#' report(estimate_smooth(model))
#' }
#' @rdname report.estimate_contrasts
#' @export
report.estimate_smooth <- function(model, ...) {
  # Tables ----
  table_full <- table <- model

  # Text ----

  ## Description
  description <- paste0(
    "The effect of ",
    attributes(model)$smooth,
    " can be described by the following linear approximation:\n\n"
  )


  ## Params
  parameters <- table_full
  if (is.null(attributes(model)$levels)) {
    text <- .format_smooth_part(parameters)
  } else {
    parameters$Group <- paste(parameters[, attributes(model)$levels])
    text <- c()
    for (group in unique(parameters$Group)) {
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
    table_full = table_full,
    values = as.list(table_full)
  )

  as.report(out)
}





#' @keywords internal
.format_smooth_part <- function(parameters, prefix = "  - ") {
  parameters$trend_text <- ifelse(!is.na(parameters$Trend),
    paste0(
      interpret_direction(parameters$Trend),
      " trend (linear coefficient = ",
      insight::format_value(parameters$Trend),
      ")"
    ),
    "part"
  )

  text <- paste0(
    prefix,
    "A ",
    parameters$trend_text,
    " starting at ",
    insight::format_value(parameters$Start),
    " and ending at ",
    insight::format_value(parameters$End),
    " (",
    insight::format_value(parameters$Size * 100),
    "% of the total size)"
  )
  text
}
