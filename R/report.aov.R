#' Reporting ANOVAs
#'
#' Create reports for ANOVA models.
#'
#' @param x Object of class `aov`, `anova` or `aovlist`.
#' @param include_intercept	Set to `TRUE` to include the intercept (relevant for type-3 ANOVA tables).
#' @inheritParams report
#' @inheritParams report.htest
#' @inherit report return seealso
#'
#' @examples
#' data <- iris
#' data$Cat1 <- rep(c("A", "B"), length.out = nrow(data))
#'
#' model <- aov(Sepal.Length ~ Species * Cat1, data = data)
#' r <- report(model)
#' r
#' summary(r)
#' as.data.frame(r)
#' summary(as.data.frame(r))
#' @return An object of class [report()].
#' @export
report.aov <- function(x, ...) {
  table <- report_table(x, ...)
  text <- report_text(x, table = table, ...)

  as.report(text, table = table, ...)
}

#' @export
report.anova <- report.aov

#' @export
report.aovlist <- report.aov


# report_effectsize -------------------------------------------------------


#' @rdname report.aov
#' @inheritParams report.lm
#' @export
report_effectsize.aov <- function(x, include_intercept = FALSE, ...) {
  table <- suppressMessages(effectsize::effectsize(x, include_intercept = include_intercept, ...))
  estimate <- names(table)[effectsize::is_effectsize_name(names(table))]

  if (estimate == "Eta2_partial") {
    interpret <- effectsize::interpret_eta_squared(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Eta2 (partial) = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Eta2") {
    interpret <- effectsize::interpret_eta_squared(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Eta2 = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Omega2_partial") {
    interpret <- effectsize::interpret_omega_squared(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Omega2 (partial) = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Omega2") {
    interpret <- effectsize::interpret_omega_squared(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Epsilon2 = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Epsilon2_partial") {
    interpret <- effectsize::interpret_epsilon_squared(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Epsilon2 (partial) = ", insight::format_value(table[[estimate]]))
  } else if (estimate == "Epsilon2") {
    interpret <- effectsize::interpret_epsilon_squared(table[[estimate]], ...)
    interpretation <- interpret
    main <- paste0("Epsilon2 = ", insight::format_value(table[[estimate]]))
  }


  ci <- table$CI
  statistics <- paste0(
    main,
    ", ",
    insight::format_ci(table$CI_low, table$CI_high, ci)
  )

  table <- as.data.frame(table)[c("Parameter", estimate, "CI_low", "CI_high")]
  names(table)[3:ncol(table)] <- c(paste0(estimate, "_CI_low"), paste0(estimate, "_CI_high"))

  rules <- .text_effectsize(attr(attr(interpret, "rules"), "rule_name"))
  parameters <- paste0(interpretation, " (", statistics, ")")


  as.report_effectsize(parameters,
    summary = parameters,
    table = table,
    interpretation = interpretation,
    statistics = statistics,
    rules = rules,
    ci = ci,
    main = main
  )
}

#' @export
report_effectsize.anova <- report_effectsize.aov

#' @export
report_effectsize.aovlist <- report_effectsize.aov

# report_table ------------------------------------------------------------

#' @rdname report.aov
#' @export
report_table.aov <- function(x, include_intercept = FALSE, ...) {
  effsize <- report_effectsize(x, include_intercept = include_intercept, ...)
  effsize_table <- attributes(effsize)$table
  params <- parameters::model_parameters(x, ...)

  if (!include_intercept) {
    params <- params[params$Parameter != "(Intercept)", ]
  }

  if ("Group" %in% names(params)) {
    effsize_table$Group <- "Within"
    params <- params[params$Group == "Within", ]
    table_full <- merge(params, effsize_table, all = TRUE)
    table_full <- table_full[order(
      match(
        paste(table_full$Group, table_full$Parameter),
        paste(params$Group, params$Parameter)
      )
    ), ]
  } else {
    table_full <- merge(params, effsize_table, all = TRUE)
    table_full <- table_full[order(
      match(table_full$Parameter, params$Parameter)
    ), ]
  }

  row.names(table_full) <- NULL

  table <- datawizard::data_remove(
    table_full,
    select = "(_CI_low|_CI_high)$",
    regex = TRUE
  )

  as.report_table(
    table_full,
    summary = table,
    ci = attributes(effsize)$ci,
    effsize = effsize
  )
}

#' @export
report_table.anova <- report_table.aov

#' @export
report_table.aovlist <- report_table.aov


# report_statistics ------------------------------------------------------------

#' @rdname report.aov
#' @export
report_statistics.aov <- function(x, table = NULL, ...) {
  if (is.null(table) || is.null(attributes(table)$effsize)) {
    table <- report_table(x, ...)
  }
  effsize <- attributes(table)$effsize

  parameters <- table[table$Parameter != "Residuals", ]
  if ("Group" %in% names(parameters)) {
    parameters <- parameters[parameters$Group == "Within", ]
  }

  # Get residuals' DoFs
  if ("Residuals" %in% table$Parameter) {
    DoF_residual <- table[table$Parameter == "Residuals", "df"]
  } else {
    DoF_residual <- NULL
  }

  # DoFs
  text <- paste0(
    "F(",
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
    insight::format_p(parameters$p)
  )

  # Effect size
  text_full <- paste0(text, "; ", attributes(effsize)$statistics)
  text <- paste0(text, ", ", attributes(effsize)$main)

  as.report_statistics(text_full,
    summary = text,
    table = table,
    effsize = effsize
  )
}

#' @export
report_statistics.anova <- report_statistics.aov

#' @export
report_statistics.aovlist <- report_statistics.aov


# report_parameters ------------------------------------------------------------


#' @rdname report.aov
#' @export
report_parameters.aov <- function(x, ...) {
  stats <- report_statistics(x, ...)
  table <- attributes(stats)$table
  effsize <- attributes(stats)$effsize

  params <- table[table$Parameter != "Residuals", ]

  # Text parameters
  text <- vapply(
    params$Parameter,
    .format_parameters_aov,
    USE.NAMES = FALSE,
    "string"
  )

  # Significance
  text <- paste0(
    text,
    " is statistically ",
    effectsize::interpret_p(params$p),
    " and ",
    attributes(effsize)$interpretation,
    " ("
  )

  text_full <- paste0(text, stats, ")")
  text <- paste0(text, summary(stats), ")")

  as.report_parameters(
    text_full,
    summary = text,
    table = table,
    effectsize = effsize,
    ...
  )
}

#' @export
report_parameters.anova <- report_parameters.aov

#' @export
report_parameters.aovlist <- report_parameters.aov


# report_model ------------------------------------------------------------

#' @rdname report.aov
#' @export
report_model.aov <- function(x, table = NULL, ...) {
  if (is.null(table)) {
    table <- report_table(x, ...)
  }

  if ("Group" %in% names(table)) {
    text <- "repeated-measures ANOVA"
  } else {
    text <- "ANOVA"
  }

  if (inherits(x, "anova")) {
    text_full <- text # Because anova() does not save the formula.
  } else {
    text_full <- paste0(
      text,
      " (",
      format_formula(x),
      ")"
    )
  }


  as.report_model(text_full, summary = text)
}

#' @export
report_model.anova <- report_model.aov

#' @export
report_model.aovlist <- report_model.aov


# report_info ------------------------------------------------------------

#' @rdname report.aov
#' @include report.htest.R
#' @export
report_info.aov <- function(x, effectsize = NULL, ...) {
  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x, ...)
  }
  as.report_info(attributes(effectsize)$rules)
}

#' @export
report_info.anova <- report_info.aov

#' @export
report_info.aovlist <- report_info.aov


# report_text ------------------------------------------------------------

#' @rdname report.aov
#' @export
report_text.aov <- function(x, table = NULL, ...) {
  params <- report_parameters(x, table = table, ...)
  table <- attributes(params)$table
  model <- report_model(x, table = table, ...)
  info <- report_info(x, effectsize = attributes(params)$effectsize, ...)


  text_full <- paste0(
    "The ",
    model,
    " suggests that:\n\n",
    as.character(params, ...),
    "\n\n",
    info
  )

  text <- paste0(
    "The ",
    summary(model),
    " suggests that:\n\n",
    as.character(summary(params), ...)
  )


  as.report_text(text_full, summary = text)
}

#' @export
report_text.anova <- report_text.aov

#' @export
report_text.aovlist <- report_text.aov
