#' @include report.lm.R
#' @export
report.stanreg <- report.lm

#' @export
report_effectsize.stanreg <- report_effectsize.lm

#' @export
report_table.stanreg <- report_table.lm

#' @export
report_performance.stanreg <- report_performance.lm

#' @export
report_statistics.stanreg <- report_statistics.lm

#' @export
report_parameters.stanreg <- function(x, include_intercept = TRUE, ...) {

  # Get data
  data <- bayestestR::sexit(x, ...)

  att <- attributes(data)
  info <- paste0(att$sexit_info, " ", att$sexit_thresholds)

  params <- as.data.frame(data)

  # Parameters' names
  text <- .parameters_starting_text(x, params)

  # Replace parameters names
  for(i in 1:length(text)){
    att$sexit_textlong[i] <- gsub(names(text)[i], text[i], att$sexit_textlong[i], fixed = TRUE)
    att$sexit_textshort[i] <- gsub(names(text)[i], text[i], att$sexit_textshort[i], fixed = TRUE)
  }

  # Include intercept
  if (isFALSE(include_intercept)) {
    idx <- !params$Parameter == "(Intercept)"
  } else{
    idx <- rep(TRUE, nrow(params))
  }

  text <- att$sexit_textshort[idx]
  text_full <- att$sexit_textlong[idx]


  as.report_parameters(text_full, summary = text, table = params, ...)
}

#' @export
report_intercept.stanreg <- report_intercept.lm

#' @export
report_random.stanreg <- report_random.merMod

#' @export
report_model.stanreg <- report_model.lm

#' @export
report_info.stanreg <- report_info.lm

#' @export
report_text.stanreg <- report_text.lm