#' @rdname model_table
#' @export
model_table.default <- function(model, ...) {
  out <- tryCatch(
    {
      .model_table_regression(model, ...)
    },
    error = function(e) { NULL }
  )

  if (is.null(out)) {
    warning("Models of class ", class(model)[1], " are not yet supported.", call. = FALSE)
  }

  out
}





# Model table for mixed models ----------------------


#' @export
model_table.lme <- function(model, standardize = NULL, ...) {
  out <- tryCatch(
    {
      .model_table_regression(model, standardize = NULL, ...)
    },
    error = function(e) { NULL }
  )

  if (is.null(out)) {
    warning("Models of class ", class(model)[1], " are not yet supported.", call. = FALSE)
  }

  out
}


#' @export
model_table.glmmTMB <- model_table.lme

#' @export
model_table.lmerMod <- model_table.lme

#' @export
model_table.merMod <- model_table.lme

#' @export
model_table.MixMod <- model_table.lme

#' @export
model_table.mixed <- model_table.lme






# Workhorse ---------------------------


#' @importFrom parameters model_parameters
#' @importFrom effectsize standardize_parameters
#' @importFrom performance model_performance
#' @keywords internal
.model_table_regression <- function(model, performance = NULL, ci = 0.95, ci_method = NULL, df_method = NULL, bootstrap = FALSE, iterations = 500, centrality = "median", dispersion = FALSE, test = c("pd", "rope"), rope_range = "default", rope_ci = 1, bf_prior = NULL, diagnostic = c("ESS", "Rhat"), standardize = "refit", ...) {

  # Sanity checks --------------------------------------------------------------
  info <- insight::model_info(model)

  # correct DF method
  if (is.null(df_method)) {
    if (class(model)[1] == "glm") {
      df_method <- "profile"
    } else {
      df_method <- "wald"
    }
  }

  # Multiple CIs
  if (length(ci) > 1) {
    warning(paste0("report does not support multiple `ci` values yet. Using ci = ", ci[1]), ".")
    ci <- ci[1]
  }




  # Parameters -----------------------------------------------------------------
  if (bootstrap & !info$is_bayesian) {
    parameters <- parameters::model_parameters(model, ci = ci, bootstrap = bootstrap, iterations = iterations, df_method = df_method, standardize = NULL, wb_component = FALSE)
  } else {
    parameters <- parameters::model_parameters(model, ci = ci, bootstrap = bootstrap, iterations = iterations, df_method = df_method, ci_method = ci_method, centrality = centrality, dispersion = dispersion, test = test, rope_range = rope_range, rope_ci = rope_ci, bf_prior = bf_prior, diagnostic = diagnostic, standardize = NULL, wb_component = FALSE)
  }

  # save pretty names
  pretty_names <- attributes(parameters)$pretty_names


  # Effect Size ----------------------------------------------------------------
  if (!is.null(standardize)) {
    effsize <- effectsize::standardize_parameters(model, method = "refit", robust = FALSE, two_sd = FALSE, centrality = centrality, ...)

    # fix CI column names
    ci_columns <- grep("^CI_", colnames(effsize))
    colnames(effsize)[ci_columns] <- paste0("Std_", colnames(effsize)[ci_columns])

    # find common columns for merging
    merge_by <- intersect(c("Parameter", "Component"), intersect(colnames(effsize), colnames(parameters)))
    parameters <- merge(parameters, effsize, by = merge_by, sort = FALSE)
    parameters$CI <- NULL
  }


  # Performance ----------------------------------------------------------------
  if (is.null(performance)) {
    performance <- performance::model_performance(model, metrics = "all", ...)
  }


  # add pretty names -----------------------------------------------------------
  if (!is.null(pretty_names)) {
    parameters$Parameter <- pretty_names
  }


  # Combine --------------------------------------------------------------------
  table_full <- .add_performance_table(parameters, performance)
  table <- .add_performance_table(
    parameters[names(parameters) %in% c("Parameter", "Coefficient", "Median", "Mean", "MAP", "CI_low", "CI_high", "p", "pd", "ROPE_Percentage", "BF", "Std_Coefficient", "Std_Median", "Std_Mean", "Std_MAP")],
    performance[names(performance) %in% c("R2", "R2_adjusted", "R2_Tjur", "R2_Nagelkerke", "R2_McFadden", "R2_conditional", "R2_marginal")]
  )

  # Return output
  out <- as.model_table(table, table_full)
  attr(out, "performance_table") <- performance

  out
}
