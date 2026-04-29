#' Generate AI-optimized reports
#'
#' This function is designed to produce AI-optimized output for statistical models.
#' It strikes a careful balance between comprehensiveness, specificity, and compactness.
#' The primary goal is to provide a Large Language Model (LLM) or AI agent with the
#' clearest and most relevant analytical information at the lowest possible token cost.
#'
#' @param x A statistical model.
#' @param ... Arguments passed to other functions, like \code{parameters::model_parameters()},
#'  \code{performance::model_performance()} or \code{insight::format_table()}.
#' @return A character vector of class `report_ai` containing the formatted text.
#'
#' @examples
#' m <- lm(mpg ~ wt + hp, data = mtcars)
#' report_ai(m)
#' @export
report_ai <- function(x, ...) {
  UseMethod("report_ai")
}

#' @export
report_ai.default <- function(x, ...) {
  insight::format_warning(
    paste0(
      "AI-optimized reports are not yet available for objects of class '",
      class(x)[1],
      "'. Falling back to report()."
    )
  )
  report(x, ..., audience = "humans")
}

#' @export
report_ai.lm <- function(x, ...) {
  .report_ai_models(x, ...)
}

#' @export
report_ai.glm <- report_ai.lm

#' @rdname report_ai
#' @examplesIf requireNamespace("lme4", quietly = TRUE)
#' \donttest{
#' m <- lme4::lmer(Reaction ~ Days + (1 | Subject), data = lme4::sleepstudy)
#' report_ai(m)
#' }
#' @export
report_ai.merMod <- function(x, ...) {
  .report_ai_models(x, ...)
}

#' @rdname report_ai
#' @examplesIf requireNamespace("glmmTMB", quietly = TRUE)
#' \donttest{
#' m <- glmmTMB::glmmTMB(count ~ mined + (1 | site), family = poisson(), data = glmmTMB::Salamanders)
#' report_ai(m)
#' }
#' @export
report_ai.glmmTMB <- function(x, ...) {
  .report_ai_models(x, ...)
}


# --- Internal Workhorse Function ---
.report_ai_models <- function(x, ...) {
  mi <- insight::model_info(x)
  dat <- insight::get_data(x)
  n_obs <- insight::n_obs(x)
  form <- insight::find_formula(x)

  func_name <- tryCatch(
    {
      dep <- insight::safe_deparse(insight::get_call(x)[[1]])
      sub(".*::", "", dep)
    },
    error = function(e) class(x)[1]
  )
  mod_family <- if (is.null(mi$family)) "Unknown" else mi$family

  model_vars_list <- insight::find_variables(x)
  # Use only response + conditional (fixed) variables for descriptives;
  # random grouping variables (e.g. Subject) are excluded.
  fixed_var_comps <- intersect(
    c("response", "conditional"),
    names(model_vars_list)
  )
  fixed_vars <- unique(unlist(
    model_vars_list[fixed_var_comps],
    use.names = FALSE
  ))
  fixed_vars <- fixed_vars[fixed_vars %in% colnames(dat)]

  if (length(fixed_vars) > 0) {
    desc_report <- suppressWarnings(summary(report::report(
      dat[, fixed_vars, drop = FALSE],
      audience = "humans"
    )))
    desc_lines <- unlist(strsplit(
      as.character(desc_report),
      "\n",
      fixed = TRUE
    ))

    if (length(desc_lines) > 1) {
      # Use trimws() to kill the spaces that cause nested bullets
      clean_lines <- trimws(desc_lines[-1])
      desc_str <- paste(clean_lines, collapse = "\n")
    } else {
      desc_str <- paste(trimws(desc_lines), collapse = "\n")
    }
  } else {
    desc_str <- "- No variables found."
  }

  params <- parameters::model_parameters(x, ...)

  # Separate fixed and random effects to avoid duplicated table headers
  # (model_parameters returns both in one table for mixed models)
  has_random <- "Effects" %in%
    names(params) &&
    any(!is.na(params$Effects) & params$Effects != "fixed")

  if (has_random) {
    fixed_params <- params[
      !is.na(params$Effects) & params$Effects == "fixed",
      ,
      drop = FALSE
    ]
    random_params <- params[
      !is.na(params$Effects) & params$Effects != "fixed",
      ,
      drop = FALSE
    ]
  } else {
    fixed_params <- params
    random_params <- NULL
  }

  param_table <- insight::format_table(fixed_params)
  param_markdown <- insight::export_table(param_table, format = "markdown")
  param_str <- paste(param_markdown, collapse = "\n")

  # Format random effect variances as metadata bullet points
  random_str <- NULL
  if (!is.null(random_params) && nrow(random_params) > 0) {
    coef_col <- intersect(
      c("Coefficient", "Estimate", "SD"),
      names(random_params)
    )[1]
    random_str <- paste(
      vapply(
        seq_len(nrow(random_params)),
        function(i) {
          param_row <- random_params[i, , drop = FALSE]
          param_name <- if ("Parameter" %in% names(param_row)) {
            as.character(param_row$Parameter)
          } else {
            "?"
          }
          group_tag <- if (
            "Group" %in%
              names(param_row) &&
              !is.na(param_row$Group) &&
              nzchar(as.character(param_row$Group))
          ) {
            paste0(" [", param_row$Group, "]")
          } else {
            ""
          }
          val <- if (!is.na(coef_col) && coef_col %in% names(param_row)) {
            sprintf("%.3f", as.numeric(param_row[[coef_col]]))
          } else {
            "?"
          }
          paste0("- ", param_name, group_tag, ": ", val)
        },
        character(1)
      ),
      collapse = "\n"
    )
  }

  perf <- performance::model_performance(x, ...)
  perf_table <- insight::format_table(perf)
  perf_markdown <- insight::export_table(perf_table, format = "markdown")
  perf_str <- paste(perf_markdown, collapse = "\n")

  if ("p" %in% names(fixed_params) && "Parameter" %in% names(fixed_params)) {
    sig_effects <- fixed_params$Parameter[
      !is.na(fixed_params$p) &
        fixed_params$p < 0.05 &
        fixed_params$Parameter != "(Intercept)"
    ]
    highlights_str <- if (length(sig_effects) == 0) {
      "- Significant effects: None"
    } else {
      sprintf(
        "- Significant effects (p < 0.05): %s",
        toString(sig_effects)
      )
    }
  } else {
    highlights_str <- "- Significant effects: Could not be determined."
  }

  formula_str <- if (is.list(form)) {
    Reduce(paste, deparse(form$conditional))
  } else {
    Reduce(paste, deparse(form))
  }

  # CI / degrees-of-freedom estimation method
  ci_level <- attr(params, "ci")
  ci_method <- attr(params, "ci_method")
  if (!is.null(ci_level) && !is.null(ci_method)) {
    ci_pct <- sprintf("%.0f%%", ci_level * 100)
    ci_label <- .ci_method_label(ci_method)
    inference_str <- paste0("- Inference: ", ci_pct, " CI [", ci_label, "]")
  } else if (is.null(ci_level)) {
    inference_str <- NULL
  } else {
    inference_str <- paste0(
      "- Inference: ",
      sprintf("%.0f%%", ci_level * 100),
      " CI"
    )
  }

  param_section <- if (is.null(random_str)) {
    paste0("## Parameters\n", param_str)
  } else {
    paste0("## Parameters\n", param_str, "\n\n### Random Effects\n", random_str)
  }

  model_section <- paste0(
    "## Model\n",
    "- Call: ",
    func_name,
    "\n",
    "- Formula: ",
    formula_str,
    "\n",
    "- Family: ",
    mod_family,
    "\n",
    "- N: ",
    n_obs,
    if (is.null(inference_str)) "" else paste0("\n", inference_str)
  )

  res <- paste0(
    model_section,
    "\n\n",
    "## Variables\n",
    desc_str,
    "\n\n",
    param_section,
    "\n\n",
    "## Performance\n",
    perf_str,
    "\n\n",
    "## Highlights\n",
    highlights_str
  )

  class(res) <- c("report_ai", "character")
  res
}

# Helper: human-readable CI / df-method label
.ci_method_label <- function(method) {
  method_labels <- c(
    wald = "Wald",
    residual = "Residual df (t/F)",
    satterthwaite = "Satterthwaite df",
    kenward = "Kenward-Roger df",
    normal = "Normal (z)",
    profile = "Profile likelihood",
    boot = "Bootstrap",
    uniroot = "Uniroot",
    hdi = "HDI",
    eti = "ETI",
    si = "SI"
  )
  lab <- method_labels[tolower(as.character(method))]
  if (is.na(lab)) {
    tools::toTitleCase(tolower(as.character(method)))
  } else {
    unname(lab)
  }
}

#' @export
print.report_ai <- function(x, ...) {
  cat(x, "\n")
  invisible(x)
}
