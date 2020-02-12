# model <- lm(Sepal.Length ~ Species, data=iris)
# interpretation = "default"; ci = 0.95; standardize = "refit"; standardize_robust = FALSE; bootstrap = FALSE; iterations = 500; performance_metrics = "all"; p_method = NULL; ci_method = NULL; centrality = "median"; dispersion = FALSE; test = c("pd", "rope"); rope_range = "default"; rope_ci = 1; bf_prior = NULL; diagnostic = c("ESS", "Rhat")
#' @importFrom stats complete.cases
#' @keywords internal
.model_text_regression <- function(model, interpretation = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", p_method = NULL, ci_method = NULL, centrality = "median", dispersion = FALSE, test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), ...) {
  tables <- model_table(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, ...)

  # Get tables
  # TODO: it's a bit dumb to merge both tables and then re-separate them.
  performance <- performance::model_performance(model, metrics = performance_metrics, ...)
  tables <- model_table(model, performance = performance, ci = ci, standardize = standardize, standardize_robust = standardize_robust, interpretation = interpretation, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, ...)

  # Get back tables
  parameters <- tables$table_long
  if("Fit" %in% names(parameters)){
    parameters <- parameters[is.na(parameters$Fit) & !is.na(parameters$Parameter),]# Remove performance part
  }

  # Sanity checks -----------------------------------------------------------

  # Default effsize
  if (!is.null(interpretation) && interpretation == "default") {
    if (insight::model_info(model)$is_binomial) {
      interpretation <- "chen2010"
    } else {
      interpretation <- "funder2019"
    }
  }



  # Text -------------------

  # Description
  text_model <- report_model(model, parameters, ci = ci, standardize = standardize, standardize_robust = standardize_robust, interpretation = interpretation, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, ...)

  # Performance
  text_perf <- report_performance(model, performance = performance, ...)

  # Intercept
  text_intercept <- report_intercept(model, parameters = parameters, ci = ci)

  # Params
  text_params <- report_parameters(model, tables = tables$table_long, prefix = "  - ", ci = ci, interpretation = interpretation)
  #
  # # Combine text
  text_short <- paste0(text_model$text, text_perf$text, text_intercept$text, " Within this model:\n\n", text_params$text)
  text_long <- paste0(text_model$text_full, text_perf$text_full, text_intercept$text_full, " Within this model:\n\n", text_params$text_full)


  # Return output
  as.model_text(text_short, text_long)
}
