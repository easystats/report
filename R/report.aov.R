#' ANOVAs Report
#'
#' Create a report of an ANOVA.
#'
#' @param model Object of class \code{aov}, \code{anova} or \code{aovlist}.
#' @param omega_squared Compute omega squared as indices of effect size. Can be \code{NULL}, "partial" (default) or "raw" for non-partial indices.
#' @param effsize Effect size interpretation set of rules.
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' data <- iris
#' data$Cat1 <- rep(c("X", "X", "Y"), length.out = nrow(data))
#' data$Cat2 <- rep(c("A", "B"), length.out = nrow(data))
#' model <- aov(Sepal.Length ~ Species * Cat1 * Cat2, data=data)
#' report(model)
#'
#'
#' \dontrun{
#' report(circus::aov_1)
#' report(circus::anova_1)
#' report(circus::aovlist_1)
#' }
#' @seealso report
#'
#' @export
report.aov <- function(model, omega_squared = "partial", effsize = "field2013", ...) {

  table_full <- parameters::model_parameters(model, omega_squared=omega_squared, ...)
  table <- table_full

  params <- table_full[table_full$Parameter != "Residuals", ]
  if("Group" %in% names(params)){
    params <- params[params$Group == "Within", ]
  }

  if("Residuals" %in% table_full$Parameter){
    DoF_residual <- table_full[table_full$Parameter == "Residuals", "DoF"]
  } else{
    DoF_residual <- NULL
  }

  text <- sapply(params$Parameter, .format_aov_varname, simplify = TRUE, USE.NAMES=FALSE)

  text <- paste0(
    text,
    " is ",
    interpret_p(params$p),
    " (F(",
    format_value_unless_integers(params$DoF))

  if(!is.null(DoF_residual)){
    text <- paste0(text, ", ", format_value_unless_integers(DoF_residual))
  } else if("DoF_Residuals" %in% names(params)){
    text <- paste0(text, ", ", format_value_unless_integers(params$DoF_Residuals))
  }


  text <- paste0(
    text,
    ") = ",
    format_value(params$`F`),
    ", p ",
    format_p(params$p),
    ") and can be considered as ",
    interpret_omega_squared(params$Omega_Squared_partial),
    " (partial omega squared = ",
    format_value(params$Omega_Squared_partial),
    ").")

  if("Group" %in% names(params)){
    text <- paste0("The repeated-measures ANOVA suggests that:\n\n", paste0(text, collapse = "\n"))
  } else{
    text <- paste0("The ANOVA suggests that:\n\n", paste0(text, collapse = "\n"))
  }


  out <- list(
    text = text,
    text_full = text,
    table = table,
    table_full = table_full,
    values = as.list(table_full)
  )

  return(as.report(out))
}


#' @export
report.anova <- report.aov


#' @export
report.aovlist <- report.aov









.format_aov_varname <- function(names){
  if (grepl(":", names)) {
    varname <- format_text_collapse(unlist(strsplit(names, ":", fixed=TRUE)))
    varname <- paste0("  - The interaction between ", varname)
  } else {
    varname <- paste0("  - The effect of ", names)
  }
  return(varname)
}