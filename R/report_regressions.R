#' @keywords internal
.report_regressions <- function(model, effsize = "default", ci = 0.95, standardize = "refit", standardize_robust = FALSE, bootstrap = FALSE, iterations = 500, performance_metrics = "all", p_method = NULL, ci_method = NULL, centrality = "median", dispersion = FALSE, test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), ...) {

  info <- insight::model_info(model)

  # Sanity checks -----------------------------------------------------------
  # Multiple CIs
  if(length(c(ci)) > 1){
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }

  # Default effsize
  if(!is.null(effsize) && effsize == "default"){
    if(info$is_binomial){
      effsize <- "chen2010"
    } else{
      effsize <- "funder2019"
    }
  }


  # Tables -------------------
  performance <- performance::model_performance(model, metrics = performance_metrics, ...)

  if(bootstrap & !info$is_bayesian){
    if(is.null(ci_method) || ci_method %in% c("wald", "boot")) ci_method <- "quantile" # Avoid issues in parameters_bootstrap for mixed models
    parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, ...)
  } else{
    parameters <- parameters::model_parameters(model, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, ...)
  }



  table_full <- .add_performance_table(parameters, performance)
  table <- .add_performance_table(parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")],
                                  performance[names(performance) %in%  c('R2', 'R2_adjusted', 'R2_Tjur', 'R2_Nagelkerke', 'R2_McFadden', 'R2_conditional', 'R2_marginal')])



  # Text -------------------
  # Description
  text_model <- text_model(model, parameters, ci = ci, standardize = standardize, standardize_robust = standardize_robust, effsize = effsize, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci)

  # Performance
  text_perf <- text_performance(model, performance = performance)

  # Intercept
  text_intercept <- text_initial(model, parameters = parameters, ci = ci)

  # Params
  text_params <- text_parameters(model, parameters = parameters, prefix = "  - ", ci = ci, effsize = effsize)

  # Combine text
  text <- paste0(text_model$text, text_perf$text, text_intercept$text, " Whithin this model:\n\n", text_params$text)
  text_full <- paste0(text_model$text_full, text_perf$text_full, text_intercept$text_full, " Whithin this model:\n\n", text_params$text_full)


  out <- list(
    table = table,
    table_full = table_full,
    text = text,
    text_full = text_full,
    values = c(to_values(parameters), as.list(performance))
  )

  rep <- as.report(out, effsize = effsize, ci = ci, standardize = standardize, standardize_robust = standardize_robust, bootstrap = bootstrap, iterations = iterations, performance_metrics = performance_metrics, ...)
  rep
}