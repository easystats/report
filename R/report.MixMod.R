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
  random_text <- .text_random(x)
  if (!is.null(random_text)) {
    text_full <- paste0(random_text, " (", format_formula(x, "random"), ")")
  }

  as.report_random(text_full, summary = random_text, ...)
}


#' @export
report_model.MixMod <- report_model.lm

#' @export
report_info.MixMod <- report_info.lm

#' @export
report_text.MixMod <- report_text.lm
