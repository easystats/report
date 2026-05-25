#' Report model assumption checks
#'
#' Produces a formatted summary of model assumption checks, covering
#' **influential observations** (via [performance::check_outliers()]) and
#' **homoskedasticity** (via [performance::check_heteroskedasticity()]).
#' Calling [summary()] on the result returns a single integrated sentence.
#' Set `audience = "ai"` for a compact, token-efficient version suitable for
#' passing to an LLM.
#'
#' @param x A statistical model object (e.g., `lm`, `glm`).
#' @param audience The intended audience. `"humans"` (default) produces a
#'   readable bulleted report; `"ai"` produces a compact structured version.
#'   The default can be changed globally with `options(report_audience = "ai")`.
#' @param ... Additional arguments passed to [performance::check_outliers()].
#'
#' @return An object of class [report_text()]. [summary()] returns a compact
#'   one-sentence version integrating all checks (for `audience = "humans"`).
#'
#' @examplesIf requireNamespace("performance", quietly = TRUE)
#' \donttest{
#' model <- lm(mpg ~ wt + hp, data = mtcars)
#' report_assumptions(model)
#' summary(report_assumptions(model))
#' report_assumptions(model, audience = "ai")
#'
#' mt2 <- rbind(
#'   mtcars[, c("mpg", "disp", "hp")],
#'   data.frame(mpg = c(37, 40), disp = c(300, 400), hp = c(110, 120))
#' )
#' model2 <- lm(disp ~ mpg + hp, data = mt2)
#' report_assumptions(model2)
#' summary(report_assumptions(model2))
#' report_assumptions(model2, audience = "ai")
#' }
#'
#' @export
report_assumptions <- function(
  x,
  ...,
  audience = getOption("report_audience", "humans")
) {
  insight::check_if_installed("performance")
  audience <- match.arg(audience, c("humans", "ai"))

  # TODO: add the following assumption checks:
  # - Linearity          performance::check_predictions() / check_linearity()
  # - Collinearity       performance::check_collinearity()
  # - Normality          performance::check_normality()
  # - Autocorrelation    performance::check_autocorrelation()
  # - Overdispersion     performance::check_overdispersion()

  # --- Influential observations -------------------------------------------
  outliers <- tryCatch(
    performance::check_outliers(x, ...),
    error = function(e) NULL
  )

  # --- Homoskedasticity ---------------------------------------------------
  heterosk <- tryCatch(
    performance::check_heteroskedasticity(x),
    error = function(e) NULL
  )
  if (!is.null(heterosk)) {
    p_val <- as.numeric(heterosk)
    p_fmt <- insight::format_p(p_val)
    homosked_ok <- p_val >= 0.05
  }

  # --- AI output ----------------------------------------------------------
  if (audience == "ai") {
    if (!is.null(outliers)) {
      n_outliers <- sum(outliers)
      n_total <- length(outliers)
      if (n_outliers == 0L) {
        outlier_ai <- "none"
      } else {
        pct <- insight::format_value(n_outliers / n_total, as_percent = TRUE)
        methods <- attr(outliers, "method")
        thresholds <- attr(outliers, "threshold")
        method_labels <- .format_outlier_method_names(methods)
        thresh_parts <- vapply(
          seq_along(methods),
          function(i) {
            thresh <- thresholds[[methods[i]]]
            if (!is.null(thresh) && length(thresh) == 1L && !is.na(thresh)) {
              paste0(
                method_labels[i],
                ", threshold = ",
                insight::format_value(thresh, digits = 3)
              )
            } else {
              method_labels[i]
            }
          },
          character(1L)
        )
        outlier_ai <- paste0(
          n_outliers,
          "/",
          n_total,
          " (",
          pct,
          ") [",
          paste(thresh_parts, collapse = "; "),
          "]"
        )
      }
    } else {
      outlier_ai <- "N/A"
    }

    if (!is.null(heterosk)) {
      heterosk_ai <- if (homosked_ok) {
        paste0("OK (Breusch-Pagan, ", p_fmt, ")")
      } else {
        paste0("VIOLATED (Breusch-Pagan, ", p_fmt, ")")
      }
    } else {
      heterosk_ai <- "N/A"
    }

    lines <- c(
      "## Assumptions",
      paste0("- Influential Observations: ", outlier_ai),
      paste0("- Homoskedasticity: ", heterosk_ai)
    )
    res <- paste(lines, collapse = "\n")
    class(res) <- c("report_ai", "character")
    return(res)
  }

  # --- Full bulleted output (humans) --------------------------------------
  lines_bullets <- c(
    "Model Assumptions",
    paste(rep("-", 24L), collapse = "")
  )
  phrases <- character(0L)

  if (!is.null(outliers)) {
    outlier_bullet <- as.character(report_text(outliers))
    lines_bullets <- c(
      lines_bullets,
      paste0("- Influential observations: ", outlier_bullet)
    )
    phrases <- c(phrases, .outlier_summary_phrase(outliers))
  }

  if (!is.null(heterosk)) {
    if (homosked_ok) {
      heterosk_bullet <- paste0(
        "Homoskedasticity was satisfied (Breusch-Pagan test, ",
        p_fmt,
        ")."
      )
      heterosk_phrase <- paste0(
        "the error variance appeared homoskedastic (",
        p_fmt,
        ")"
      )
    } else {
      heterosk_bullet <- paste0(
        "Heteroskedasticity was detected (Breusch-Pagan test, ",
        p_fmt,
        ")."
      )
      heterosk_phrase <- paste0("heteroskedasticity was detected (", p_fmt, ")")
    }
    lines_bullets <- c(
      lines_bullets,
      paste0("- Homoskedasticity: ", heterosk_bullet)
    )
    phrases <- c(phrases, heterosk_phrase)
  }

  if (length(phrases) == 0L) {
    lines_bullets <- c(
      lines_bullets,
      "- Assumption checks could not be performed for this model class."
    )
    text_summary <- "Assumption checks could not be performed for this model class."
  } else {
    text_summary <- paste0(
      "The model's assumptions were checked: ",
      paste(phrases, collapse = " and "),
      "."
    )
  }

  as.report_text(paste(lines_bullets, collapse = "\n"), summary = text_summary)
}


# Helpers -----------------------------------------------------------------

.outlier_summary_phrase <- function(outliers) {
  n_outliers <- sum(outliers)

  if (n_outliers == 0L) {
    return("no influential observations were detected")
  }

  pct <- n_outliers / length(outliers)
  methods <- attr(outliers, "method")
  method_labels <- .format_outlier_method_names(methods)
  method_str <- paste(method_labels, collapse = " and ")

  paste0(
    n_outliers,
    " influential ",
    if (n_outliers == 1L) "observation" else "observations",
    " (",
    insight::format_value(pct, as_percent = TRUE),
    ")",
    " were detected (",
    method_str,
    ")"
  )
}
