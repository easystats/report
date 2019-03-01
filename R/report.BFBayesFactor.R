#' #' Bayesian Models Values
#' #'
#' #' Extract all values of Bayesian models.
#' #'
#' #' @inheritParams report.stanreg
#' #'
#' #' @examples
#' #' \dontrun{
#' #' model <- BayesFactor::ttestBF(iris$Sepal.Length, iris$Sepal.Width, paired=TRUE)
#' #' model <- BayesFactor::ttestBF(formula=mpg ~ am, data=dplyr::mutate(mtcars, am=as.factor(am)))
#' #' model <- BayesFactor::correlationBF(iris$Sepal.Length, iris$Petal.Length)
#' #' model <- BayesFactor::anovaBF(Sepal.Length ~ Species, data=iris)
#' #' model <- BayesFactor::anovaBF(mpg ~ gear * am, data=dplyr::mutate(mtcars, gear=as.factor(gear), am=as.factor(am)))
#' #' }
#' #'
#' #'
#' #' @importFrom insight model_info
#' #' @importFrom parameters model_parameters
#' #' @importFrom performance model_performance
#' #' @export
#' model_values.BFBayesFactor <- function(model, ci = 0.90, ...) {
#'
#'
#'   if(any(class(model@denominator) %in% c("BFcorrelation"))){
#'
#'   } else if(any(class(model@denominator) %in% c("BFoneSample"))){
#'
#'   } else if(any(class(model@denominator) %in% c("BFindepSample"))){
#'
#'   } else{
#'     stop(paste0("BayesFactor objects of type ", class(model@denominator)[1], " not supported yet."))
#'   }
#'
#'
#'   return(out)
#' }
