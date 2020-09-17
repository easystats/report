#' @rdname model_table
#' @inheritParams parameters::model_parameters.default
#' @export
model_table.lm <- function(model, ...) {
  .model_table_regression(model, ...)
}

#' @export
model_table.glm <- model_table.lm

#' @export
model_table.merMod <- model_table.lm

#' @export
model_table.stanreg <- model_table.lm








#' @importFrom parameters model_parameters
#' @importFrom effectsize standardize_parameters
#' @importFrom performance model_performance
#' @keywords internal
.model_table_regression <- function(model, performance = NULL, ci = 0.95, ci_method = NULL, df_method = NULL, bootstrap = FALSE, iterations = 500, centrality = "median", dispersion = FALSE, test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), standardize = "refit", ...) {

  # Sanity checks --------------------------------------------------------------
  info <- insight::model_info(model)

  # Multiple CIs
  if (length(ci) > 1) {
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }




  # Parameters -----------------------------------------------------------------
  if (bootstrap & !info$is_bayesian) {
    parameters <- parameters::model_parameters(model, ci = ci, bootstrap = bootstrap, iterations = iterations, df_method = df_method, standardize = NULL)
  } else {
    parameters <- parameters::model_parameters(model, ci = ci, bootstrap = bootstrap, iterations = iterations, df_method = df_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, standardize = NULL)
  }


  # Effect Size ----------------------------------------------------------------
  if (!is.null(standardize)) {
    effsize <- effectsize::standardize_parameters(model, method = "refit", robust = FALSE, two_sd = FALSE, centrality = centrality, ...)

    # fix CI column names
    ci_columns <- grep("^CI_", colnames(effsize))
    colnames(effsize)[ci_columns] <- paste0("Std_", colnames(effsize)[ci_columns])

    # find common columns for merging
    merge_by <- intersect(c("Parameter", "Component"), unique(c(colnames(effsize), colnames(parameters))))
    parameters <- merge(parameters, effsize, by = merge_by, sort = FALSE)
    parameters$CI <- NULL
  }


  # Performance ----------------------------------------------------------------
  if (is.null(performance)) {
    performance <- performance::model_performance(model, metrics = "all", ...)
  }



  # Combine --------------------------------------------------------------------
  table_full <- .add_performance_table(parameters, performance)
  table <- .add_performance_table(
    parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")],
    performance[names(performance) %in% c("R2", "R2_adjusted", "R2_Tjur", "R2_Nagelkerke", "R2_McFadden", "R2_conditional", "R2_marginal")]
  )

  # Return output
  as.model_table(table, table_full)
}
