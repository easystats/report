#' ANOVAs Report
#'
#' Create a report of an ANOVA.
#'
#' @param model Object of class \code{aov}, \code{anova} or \code{aovlist}.
#' @param effsize Effect size interpretation set of rules.
#' @inheritParams parameters::model_parameters.aov
#'
#'
#'
#' @examples
#' data <- iris
#' data$Cat1 <- rep(c("X", "X", "Y"), length.out = nrow(data))
#' data$Cat2 <- rep(c("A", "B"), length.out = nrow(data))
#' model <- aov(Sepal.Length ~ Species * Cat1 * Cat2, data = data)
#' report(model, omega_squared = "partial")
#' @seealso report
#'
#' @export
report.aov <- function(model, effsize = "field2013", omega_squared = NULL, eta_squared = NULL, epsilon_squared = NULL, ...) {
  table_full <- parameters::model_parameters(model, omega_squared = omega_squared, eta_squared = eta_squared, epsilon_squared = epsilon_squared, ...)

  parameters <- table_full[table_full$Parameter != "Residuals", ]
  if ("Group" %in% names(parameters)) {
    parameters <- parameters[parameters$Group == "Within", ]
  }

  # Get residuals' DoFs
  if ("Residuals" %in% table_full$Parameter) {
    DoF_residual <- table_full[table_full$Parameter == "Residuals", "df"]
  } else {
    DoF_residual <- NULL
  }

  # Text parameters
  text <- sapply(parameters$Parameter, .format_aov_varname, simplify = TRUE, USE.NAMES = FALSE)

  # DoFs
  text <- paste0(
    text,
    " is ",
    interpret_p(parameters$p),
    " (F(",
    insight::format_value(parameters$df, protect_integers = TRUE)
  )

  if (!is.null(DoF_residual)) {
    text <- paste0(text, ", ", insight::format_value(DoF_residual, protect_integers = TRUE))
  } else if ("DoF_Residuals" %in% names(parameters)) {
    text <- paste0(text, ", ", insight::format_value(parameters$DoF_Residuals, protect_integers = TRUE))
  }

  # Indices
  text <- paste0(
    text,
    ") = ",
    insight::format_value(parameters$`F`),
    ", ",
    parameters::format_p(parameters$p)
  )

  # Effect size
  text <- paste0(
    text,
    .format_aov_effsize(parameters, effsize = effsize)
  )

  if ("Group" %in% names(parameters)) {
    text <- paste0("The repeated-measures ANOVA suggests that:\n\n", paste0(text, collapse = "\n"))
  } else {
    text <- paste0("The ANOVA suggests that:\n\n", paste0(text, collapse = "\n"))
  }


  out <- list(
    text = text,
    text_full = text,
    table = table_full,
    table_full = table_full,
    values = to_values(parameters)
  )

  as.report(out, effsize = effsize, omega_squared = omega_squared, eta_squared = eta_squared, epsilon_squared = epsilon_squared, ...)
}


#' @export
report.anova <- report.aov


#' @export
report.aovlist <- report.aov



#' @keywords internal
.format_aov_effsize <- function(parameters, effsize = "field2013") {
  if ("Omega_Sq_partial" %in% names(parameters)) {
    out <- paste0(
      ") and can be considered as ",
      interpret_omega_squared(parameters$Omega_Sq_partial, rules = effsize),
      " (partial omega squared = ",
      insight::format_value(parameters$Omega_Sq_partial),
      ")."
    )
  } else if ("Omega_Sq" %in% names(parameters)) {
    out <- paste0(
      ") and can be considered as ",
      interpret_omega_squared(parameters$Omega_Sq, rules = effsize),
      " (omega squared = ",
      insight::format_value(parameters$Omega_Sq),
      ")."
    )
  } else if ("Eta_Sq" %in% names(parameters)) {
    out <- paste0(
      ", eta squared = ",
      insight::format_value(parameters$Eta_Sq),
      ")."
    )
  } else if ("Epsilon_sq" %in% names(parameters)) {
    out <- paste0(
      ", epsilon squared = ",
      insight::format_value(parameters$Epsilon_sq),
      ")."
    )
  } else {
    out <- ")."
  }

  out
}






#' @keywords internal
.format_aov_varname <- function(names) {
  if (grepl(":", names)) {
    varname <- format_text(unlist(strsplit(names, ":", fixed = TRUE)))
    varname <- paste0("  - The interaction between ", varname)
  } else {
    varname <- paste0("  - The main effect of ", names)
  }
  varname
}
