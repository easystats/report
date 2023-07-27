#' Report S- and p-values in easy language.
#'
#' Reports interpretation of S- and p-values in easy language.
#'
#' @param s An S-value. Either `s` or `p` must be provided.
#' @param p A p-value. Either `s` or `p` must be provided.
#'
#' @return A string with the interpretation of the S- or p-value.
#'
#' @examples
#' report_s(s = 1.5)
#' report_s(p = 0.05)
#' @export
report_s <- function(s = NULL, p = NULL) {
  # sanity check arguments
  if ((is.null(s) || is.na(s)) && (is.null(p) || is.na(p))) {
    insight::format_error("You must provide either `s` or `p`.")
  }
  if (length(s) > 1 || length(p) > 1) {
    insight::format_error("You must provide a single value for `s` or `p`.")
  }
  # make sure we have both s and p
  if (!is.null(p) && !is.na(p)) {
    s <- -log2(p)
  } else {
    p <- 2^(-s)
  }
  all_heads <- round(s)
  chance <- sprintf("%.2g", 100 * p)
  msg <- paste0(
    paste0("If the test hypothesis (", test_parameter, " = ", test_value) " and all model assumptions were true, ",
    "there is a ", chance, "% chance of observing this outcome. How weird is that? ",
    "It's hardly more surprising than getting ", all_heads, " heads in a row with fair coin tosses."
  )
  insight::format_alert(msg)
}
