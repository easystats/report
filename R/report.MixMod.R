#' @include report.lm.R
#' @export
report.MixMod <- report.lm

#' @export
report_effectsize.MixMod <- report_effectsize.lm

#' @export
report_table.MixMod <- report_table.lm

#' @export
report_performance.MixMod <- report_performance.lm

#' @export
report_statistics.MixMod <- report_statistics.lm

#' @export
report_parameters.MixMod <- report_parameters.lm

#' @export
report_intercept.MixMod <- report_intercept.lm

#' @export
report_random.MixMod <- function(x, ...) {
  random_terms <- insight::find_terms(x)$random
  if (!is.null(random_terms)) {
    text <- format_text(random_terms)
    text <- paste0("The model included ", text, " as random effect")
    text <- ifelse(length(random_terms) > 1, paste0(text, "s"), text)
    text_full <- paste0(text, " (", format_formula(x, "random"), ")")
  }

  as.report_random(text_full, summary = text, ...)
}


#' @export
report_model.MixMod <- report_model.lm

#' @export
report_info.MixMod <- report_info.lm

#' @export
report_text.MixMod <- report_text.lm
