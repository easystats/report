# @examples
# model <- lm(Sepal.Length ~ Species, data=iris)
# effsize = "default"; ci = 0.95; standardize = "refit"; standardize_robust = FALSE; bootstrap = FALSE; iterations = 500; performance_metrics = "all"; p_method = NULL; ci_method = NULL; centrality = "median"; dispersion = FALSE; test = c("pd", "rope"); rope_range = "default"; rope_ci = 1; bf_prior = NULL; diagnostic = c("ESS", "Rhat")
#' @keywords internal
.model_text_regression <- function(model, interpretation = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", p_method = NULL, ci_method = NULL, centrality = "median", dispersion = FALSE, test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), ...) {
  tables <- model_table(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, ...)


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

  text <- "text"
  text_full <- "text_full"
  # Description
  text_model <- .text_description(model, tables, ci = ci, standardize = standardize, standardize_robust = standardize_robust, interpretation = interpretation, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci)
  #
  # # Performance
  # text_perf <- text_performance(model, performance = performance)
  #
  # # Intercept
  # text_intercept <- text_initial(model, parameters = parameters, ci = ci)
  #
  # # Params
  # text_params <- text_parameters(model, parameters = parameters, prefix = "  - ", ci = ci, effsize = effsize)
  #
  # # Combine text
  # text <- paste0(text_model$text, text_perf$text, text_intercept$text, " Within this model:\n\n", text_params$text)
  # text_full <- paste0(text_model$text_full, text_perf$text_full, text_intercept$text_full, " Within this model:\n\n", text_params$text_full)


  # Return output
  as.model_text(text, text_full)
}
