#' Parameters table printing
#'
#' @param x Object of class \code{table_report}.
#' @param digits Number of digits.
#' @param ... Arguments passed to or from other methods.
#'
#' @export
print.report_table <- function(x, digits=2, ...){
  x %>%
    mutate_if(is.numeric, format_value, digits=digits) %>%
    .colour_column_if("beta", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Median", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("Mean", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("MAP", condition=`>`, threshold=0, colour_if="green", colour_else="red") %>%
    .colour_column_if("p", condition=`<`, threshold=0.05, colour_if="yellow", colour_else=NULL) %>%
    .display()
}