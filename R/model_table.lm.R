#' @export
model_table.lm <- function(model, ci = 0.95, bootstrap = FALSE, iterations = 500, ...){
  .model_table_regression(model, ci=ci, bootstrap=bootstrap, iterations=iteration)
}












#' @keywords internal
.model_table_regression <- function(model, ci = 0.95, ci_method = NULL, p_method = NULL, bootstrap = FALSE, iterations = 500, centrality = "median", dispersion = FALSE, test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), ...){

  # Sanity checks --------------------------------------------------------------
  info <- insight::model_info(model)

  # Multiple CIs
  if(length(c(ci)) > 1){
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }




  # Parameters -----------------------------------------------------------------
  if(bootstrap & !info$is_bayesian){
    if(is.null(ci_method) || ci_method %in% c("wald", "boot")) ci_method <- "quantile" # Avoid issues in parameters_bootstrap for mixed models
    parameters <- parameters::model_parameters(model, ci = ci, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, ...)
  } else{
    parameters <- parameters::model_parameters(model, ci = ci, bootstrap = bootstrap, iterations = iterations, p_method = p_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, ...)
  }


  # Effect Size ----------------------------------------------------------------
  effsize <- effectsize::standardize_parameters(model, method = "refit", robust = FALSE, two_sd = FALSE, centrality = centrality, ...)
  effsize <- effsize[order(parameters$Parameter),]
  effsize$Parameter <- NULL
  parameters <- cbind(parameters, effsize)

  # Performance ----------------------------------------------------------------
  performance <- performance::model_performance(model, metrics = "all", ...)




  # Combine --------------------------------------------------------------------
  table_full <- .add_performance_table(parameters, performance)
  table <- .add_performance_table(parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")],
                                  performance[names(performance) %in%  c('R2', 'R2_adjusted', 'R2_Tjur', 'R2_Nagelkerke', 'R2_McFadden', 'R2_conditional', 'R2_marginal')])

  # Return output
  .model_table_return_output(table, table_full)
}
