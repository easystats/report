#' @include report.lm.R
#' @export
report.lmerMod <- report.lm

#' @export
report_effectsize.lmerMod <- report_effectsize.lm

#' @export
report_table.lmerMod <- report_table.lm

#' @export
report_performance.lmerMod <- report_performance.lm

#' @export
report_statistics.lmerMod <- report_statistics.lm

#' @export
report_parameters.lmerMod <- report_parameters.lm

#' @export
report_intercept.lmerMod <- report_intercept.lm

#' @export
report_random.lmerMod <- function(x, ...) {
  random_terms <- insight::find_terms(x)$random
  if (!is.null(random_terms)) {
    text <- format_text(random_terms)
    text <- paste0("The model included ", text, " as random effect")
    text <- ifelse(length(random_terms) > 1, paste0(text, "s"), text)
    text_full <- paste0(text, " (", format_formula(x, "random"), ")")
  }

  as.report_random(text_full, summary=text, ...)
}


#' @export
report_model.lmerMod <- report_model.lm

#' @export
report_info.lmerMod <- report_info.lm

#' @export
report_text.lmerMod <- report_text.lm