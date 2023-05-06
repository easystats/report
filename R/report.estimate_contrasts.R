#' Reporting `estimate_contrasts` objects
#'
#' Create reports for `estimate_contrasts` objects.
#'
#' @param x Object of class `estimate_contrasts`.
#' @param table Provide the output of  `report_table()` to avoid its
#'   re-computation.
#' @param effectsize Provide the output of `report_effectsize()` to avoid
#'   its re-computation.
#' @inheritParams report
#'
#' @inherit report return seealso
#'
#' @examplesIf requireNamespace("modelbased", quietly = TRUE)
#' library(modelbased)
#' model <- lm(Sepal.Width ~ Species, data = iris)
#' contr <- estimate_contrasts(model)
#' report(contr)
#' @return An object of class [report()].
#' @export
report.estimate_contrasts <- function(x, ...) {
  table <- report_table(x, ...)
  text <- report_text(x, table = table, ...)

  as.report(text, table = table, ...)
}


# report_effectsize -------------------------------------------------------

#' @rdname report.estimate_contrasts
#' @export
report_effectsize.estimate_contrasts <- function(x, ...) {

  att <- attributes(x)
  dat <- insight::get_data(att$model)

  dat_wide <- datawizard::data_to_wide(
    dat,
    values_from = "Sepal.Width",
    names_from = "Species")

  eff <- lapply(seq(nrow(x)), function(i) {
    effectsize::cohens_d(x = x$Level1[i], y = x$Level2[i], data = dat_wide)
  })

  eff <- do.call(rbind, eff)

  names(eff)[-1] <- paste0("Cohens_d_", names(eff)[-1])

  eff
}


# report_table ------------------------------------------------------------


#' @rdname report.estimate_contrasts
#' @export
report_table.estimate_contrasts <- function(x, effectsize = NULL, ...) {

  if (is.null(effectsize)) {
    effectsize <- report_effectsize(x)
  }
  out <- as.report_table(cbind(x, effectsize))

  # Return output
  out
}

# report_text ------------------------------------------------------------

#' @rdname report.estimate_contrasts
#' @export
report_text.estimate_contrasts <- function(x, table = NULL, ...) {

  f.table <- insight::format_table(table)

  text <- paste0("The difference between ", x$Level1, " and ", x$Level2, " is ",
                ifelse(x$Difference < 0, " negative,", "positive,"), " statistically ",
                ifelse(x$p < .05, "significant,", "non-significant,"), " and ",
                effectsize::interpret_cohens_d(table$Cohens_d), " ",
                "(difference = ", f.table$Difference, ", 95% CI ", f.table$CI, ", ",
                names(f.table)[6], " = ", f.table[[6]], ", ", insight::format_p(table$p),
                ", ", "Cohen's d = ", f.table$`Cohen's d`, ", 95% CI ", f.table$`Cohens_d 95% CI`,
                ")", sep = ". "
                )

  text <- paste("The marginal contrasts analysis suggests the following.", paste0(text, collapse = ""))

  as.report_text(text)

}
