#' @include report.lm.R
#' @export
report.lme <- report.lm

#' @export
report_effectsize.lme <- report_effectsize.lm

#' @export
report_table.lme <- report_table.lm

#' @export
report_performance.lme <- report_performance.lm

#' @export
report_statistics.lme <- report_statistics.lm

#' @export
report_parameters.lme <- report_parameters.lm

#' @export
report_intercept.lme <- report_intercept.lm

#' @export
report_random.lme <- function(x, ...) {
  random_terms <- insight::find_terms(x)$random
  if (!is.null(random_terms)) {
    random_text <- random_terms
    random_text <- paste0(
      "The model included ",
      random_text,
      " as random effect"
    )
    random_text <- ifelse(
      length(random_terms) > 1,
      paste0(random_text, "s"),
      random_text
    )
    text_full <- paste0(random_text, " (", format_formula(x, "random"), ")")
  }

  as.report_random(text_full, summary = random_text, ...)
}


#' @export
report_model.lme <- report_model.lm

#' @export
report_info.lme <- report_info.lm

#' @export
report_text.lme <- report_text.lm
