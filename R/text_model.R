#' Model description textual reporting
#'
#' Model textual description.
#'
#' @param model Object.
#' @param details Add details.
#' @param ... Arguments passed to or from other methods.
#'
#'
#' @seealso report
#'
#' @export
text_model <- function(model, details = FALSE, ...) {
  UseMethod("text_model")
}





.text_effsize <- function(effsize){
  # Effect size
  if (!is.null(effsize)) {
    if (is.character(effsize)) {
      effsize_name <- ifelse(effsize == "cohen1988", "Cohen's (1988)",
                             ifelse(effsize == "sawilowsky2009", "Savilowsky's (2009)",
                                    ifelse(effsize == "gignac2016", "Gignac's (2016)",
                                           ifelse(effsize == "funder2019", "Funder's (2019)",
                                                  ifelse(effsize == "chen2010", "Chen's (2010)", effsize)
                                           )
                                    )
                             )
      )
      text <- paste0(" Effect sizes were labelled following ", effsize_name, " recommendations.")
    } else {
      text <- paste0(" Effect sizes were labelled following a custom set of rules.")
    }
  } else{
    text <- ""
  }
  text
}


#' @keywords internal
.text_ci <- function(ci, ci_method, p_method = NULL){

  text <- ""
  # Frequentist --------------------------------

  # wald
  if(ci_method == "wald"){
    if(!is.null(p_method) && p_method == "wald"){
      text <- paste0(" The ", parameters::format_value(ci*100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) and p values were computed using Wald approximation")
    } else{
      text <- paste0(" The ", parameters::format_value(ci*100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were computed using Wald approximation")
    }
  }

  # bootstrap
  if(ci_method == "boot") text <- paste0(" The ", parameters::format_value(ci*100, protect_integers = TRUE), "%", " Confidence Intervals (CIs) were obtained through bootstrapping")

  # P values
  if(!is.null(p_method)){
    if(text != "") text <- paste0(text, " and ")
    if(p_method == "wald" & ci_method != "wald") text <- paste0(text, "p values were computed using Wald approximation")
    if(p_method == "kenward") text <- paste0(text, "p values were computed using Kenward-Roger approximation")
  }


  # Bayesian --------------------------------
  if(tolower(ci_method) == "hdi"){
    text <- paste0(" The ", parameters::format_value(ci*100, protect_integers = TRUE), "%", " Credible Intervals (CIs) were based on Highest Density Intervals (HDI)")
  }

  if(tolower(ci_method) %in% c("eti", "quantile", "ci")){
    text <- paste0(" The ", parameters::format_value(ci*100, protect_integers = TRUE), "%", " Credible Intervals (CIs) are Equal-Tailed Intervals (ETI) computed using quantiles")
  }

  paste0(text, ".")

}





#' @keywords internal
.text_rope <- function(rope_range, rope_ci){
  if (rope_ci == 1) {
    text <- paste0(
      " The Region of Practical Equivalence (ROPE) ",
      "percentage was defined as the proportion of the ",
      "posterior distribution within the [",
      parameters::format_value(rope_range[1]),
      ", ",
      parameters::format_value(rope_range[2]),
      "] range."
    )
  } else {
    text <- paste0(
      " The Region of Practical Equivalence (ROPE) ",
      "percentage was defined as the proportion of the ",
      rope_ci * 100, "% CI within the [",
      parameters::format_value(rope_range[1]),
      ", ",
      parameters::format_value(rope_range[2]),
      "] range."
    )
  }
  text
}