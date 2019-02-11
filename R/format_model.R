#' Model Name Formatting
#'
#' @param model A statistical model.
#'
#' @examples
#' model <- lm(Sepal.Length ~ Species, data=iris)
#' @export
format_model <- function(model) {
  info <- insight::model_info(model)

  type <- ""

  if(info$is_bayesian0) type <- paste0(type, "Bayesian ")

  if(info$is_logit){
    type <- paste0(type, "logistic ")
    # TODO: is_probit
  } else if(info$is_linear){
    type <- paste0(type, "linear ")
  } else{
    type <- paste0(type, "general linear ")
  }


  if(info$is_zeroinf) type <- paste0(type, "zero-inflated ")
  # if(info$is_mixed) type <- paste0(type, "mixed ")

  type <- paste0(type, "model")

  if(stringr::str_detect(type, "general linear")){
    type <- paste0(type,
                   " (",
                   info$family,
                   " family with a ",
                   info$link_function,
                   " link)")
  }
  return(type)
}
