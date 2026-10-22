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

#' @rdname report.lm
#' @export
report_random.merMod <- function(x, ...) {
  random_text <- .text_random(x)
  if (!is.null(random_text)) {
    text_full <- paste0(random_text, " (", format_formula(x, "random"), ")")
  }

  as.report_random(text_full, summary = random_text, ...)
}


#' @export
report_model.merMod <- report_model.lm

#' @export
report_info.merMod <- report_info.lm

#' @export
report_text.merMod <- report_text.lm
