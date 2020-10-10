.safe_deparse <- function(string) {
  if (is.null(string)) {
    return(NULL)
  }
  paste0(sapply(deparse(string, width.cutoff = 500), trimws, simplify = TRUE), collapse = " ")
}
