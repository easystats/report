#' Standardization
#'
#' Standardize (scale and reduce, Z-score) X so that the values are expressed in terms of standard deviation (i.e., mean = 0, SD = 1).
#'
#' @param x Object.
#' @param robust If TRUE, the standardization will be based on \link{median} and \link{mad} instead of \link{mean} and \link{sd} (default).
#' @param select For a data.frame, character or list of characters of column names to be
#' standardized.
#' @param exclude For a data.frame, character or list of characters of column names to be excluded
#' from standardization.
#' @param ... Arguments passed to or from other methods.
#'
#' @author \href{https://dominiquemakowski.github.io/}{Dominique Makowski}
#'
#' @export
standardize <- function(x, robust=FALSE, select = NULL, exclude=NULL, ...) {
  UseMethod("standardize")
}











#' @inherit standardize
#' @importFrom stats median mad
#' @export
standardize.numeric <- function(x, robust=FALSE, ...){

  # Warning if all NaNs
  if (all(is.na(x))) {
    return(x)
  }

  # Warning if logical vector
  if(length(unique(x)) == 2){
    if(is.null(names(x))){
      name <- deparse(substitute(x))
    } else{
      name <- names(x)
    }
    warning(paste0("Variable `", name, "` contains only two different values. Consider converting it to a factor."))
  }


  if (robust == FALSE) {
    return(as.vector(scale(x, ...)))
  } else {
    return(as.vector((x - median(x, na.rm=TRUE))/mad(x, na.rm=TRUE)))
  }
}










#' @inherit standardize
#' @export
standardize.factor <- function(x, ...){
  return(x)
}




#' @inheritParams standardize
#' @export
standardize.grouped_df <- function(x, robust=FALSE, select = NULL, exclude=NULL, ...){
  x <- x %>%
    dplyr::do_("standardize(., select = select, exclude = exclude, robust = robust, ...)")
  return(x)
}




#' @inheritParams standardize
#' @importFrom purrr map_dfc
#' @export
standardize.data.frame <- function(x, robust=FALSE, select = NULL, exclude=NULL, ...){
  if(is.null(select)){
    select = names(x)
  } else{
    select <- c(select)
  }

  if(!is.null(exclude)){
    select <- select[!select %in% c(exclude)]
  }

  x[select] <- purrr::map_dfc(x[select], standardize, robust=robust)
  return(x)
}
