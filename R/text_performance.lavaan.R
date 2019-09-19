#' @export
text_performance.lm <- function(model, performance, ...) {
  text <- ""
  text_full <- ""


  # Datatable


  # Chisq
  if(all(c("Chisq_p", "Chisq", "Chisq_DoF") %in% names(performance))){
    sig <- "can be rejected"
    if(interpret_p(performance$Chisq_p) == "significant"){
      sig <- "is plausible"
    }
    text <- paste0(text,
                   "The hypothesis of a good fit ",
                   sig,
                   "Chisq(",
                   insight::format_value(performance$Chisq_DoF))
  }

  list(
    "text" = text,
    "text_full" = text_full
  )
}