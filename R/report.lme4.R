#' @include report.lm.R
#' @export
report.merMod <- report.lm

#' @export
report_effectsize.merMod <- report_effectsize.lm

#' @export
report_table.merMod <- report_table.lm

#' @export
report_performance.merMod <- report_performance.lm

#' @export
report_statistics.merMod <- report_statistics.lm

#' @export
report_parameters.merMod <- report_parameters.lm

#' @export
report_intercept.merMod <- report_intercept.lm

#' @export
report_random.merMod <- function(x, ...) {
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
report_model.merMod <- report_model.lm

#' @export
report_info.merMod <- report_info.lm

#' @export
report_text.merMod <- report_text.lm