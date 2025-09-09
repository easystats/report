#' Reporting Models' Bayes Factor
#'
#' Create reports of Bayes factors for model comparison.
#'
#' @param x Object of class `bayesfactor_inclusion`.
#' @param interpretation Effect size interpretation set of rules (see
#'   [interpret_bf][effectsize::interpret_bf]).
#' @inheritParams report
#' @inheritParams effectsize::interpret_bf
#' @inherit report return seealso
#'
#' @examplesIf requireNamespace("bayestestR", quietly = TRUE)
#' library(bayestestR)
#' # Bayes factor - models
#' mo0 <- lm(Sepal.Length ~ 1, data = iris)
#' mo1 <- lm(Sepal.Length ~ Species, data = iris)
#' mo2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
#' mo3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)
#' BFmodels <- bayesfactor_models(mo1, mo2, mo3, denominator = mo0)
#'
#' r <- report(BFmodels)
#' r
#'
#' # Bayes factor - inclusion
#' inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)
#'
#' r <- report(inc_bf)
#' r
#' as.data.frame(r)
#' @return An object of class [report()].
#' @export
report.bayesfactor_models <- function(x,
                                      interpretation = "jeffreys1961",
                                      exact = TRUE,
                                      protect_ratio = TRUE,
                                      ...) {
  out <- .report.bayesfactor_models(
    x,
    interpretation = interpretation,
    exact = exact,
    protect_ratio = protect_ratio,
    ...
  )

  as.report(
    text = as.report_text(out$text_full, summary = out$text_short),
    table = as.report_table(out$table_full, summary = out$table_short),
    rules = out$rules,
    denominator = out$denominator,
    BF_method = out$BF_method
  )
}


#' @export
report_table.bayesfactor_models <- function(x,
                                            interpretation = "jeffreys1961",
                                            exact = TRUE,
                                            protect_ratio = TRUE,
                                            ...) {
  out <-
    .report.bayesfactor_models(
      x,
      interpretation = interpretation,
      exact = exact,
      protect_ratio = protect_ratio,
      ...
    )

  as.report_table(out$table_full,
    summary = out$table_short,
    rules = out$rules,
    denominator = out$denominator,
    BF_method = out$BF_method
  )
}

#' @export
report_text.bayesfactor_models <- function(x,
                                           table = NULL,
                                           interpretation = "jeffreys1961",
                                           exact = TRUE,
                                           protect_ratio = TRUE,
                                           ...) {
  out <- .report.bayesfactor_models(
    x,
    interpretation = interpretation,
    exact = exact,
    protect_ratio = protect_ratio,
    ...
  )

  as.report_text(out$text_full,
    summary = out$text_short,
    rules = out$rules,
    denominator = out$denominator,
    BF_method = out$BF_method
  )
}


#' @keywords internal
.report.bayesfactor_models <- function(model,
                                       interpretation = "jeffreys1961",
                                       exact = TRUE,
                                       protect_ratio = TRUE,
                                       ...) {
  model$Model[model$Model == "1"] <- "(Intercept only)"
  denominator <- attr(model, "denominator")
  BF_method <- attr(model, "BF_method")
  max_den <- which.max(exp(model$log_BF))
  min_den <- which.min(exp(model$log_BF))

  #### text ####
  model_ind <- rep("", nrow(model))
  model_ind[max_den] <- " (the most supported model)"
  model_ind[min_den] <- " (the least supported model)"

  summ_inds <- c(max_den, min_den)
  summ_inds <- summ_inds[summ_inds != denominator]
  bf_text <- paste0(
    "Compared to the ", model$Model[denominator], " model", model_ind[denominator], ", ",
    "we found ",
    paste0(
      effectsize::interpret_bf(exp(model$log_BF)[summ_inds],
        rules = interpretation, include_value = TRUE,
        exact = exact, protect_ratio = protect_ratio
      ),
      " the ", model$Model[summ_inds], " model", model_ind[summ_inds],
      collapse = "; "
    ),
    "."
  )


  #### text full ####
  if (grepl("BIC", BF_method, fixed = TRUE)) {
    bf_explain <- paste0(
      "Bayes factors were computed using the BIC approximation, ",
      "by which BF10 = exp((BIC0 - BIC1)/2). "
    )
  } else if (grepl("JZS", BF_method, fixed = TRUE)) {
    bf_explain <- paste0(
      "Bayes factors were computed with the `BayesFactor` package, ",
      "using JZS priors. "
    )
  } else if (grepl("bridgesampling", BF_method, fixed = TRUE)) {
    bf_explain <- paste0(
      "Bayes factors were computed by comparing marginal likelihoods, ",
      "using the `bridgesampling` package. "
    )
  }

  bf_text_full <- paste0(bf_explain, paste0(
    "Compared to the ", model$Model[denominator], " model", model_ind[denominator], ", ",
    "we found ",
    paste0(
      effectsize::interpret_bf(exp(model$log_BF)[-denominator],
        rules = interpretation, include_value = TRUE,
        exact = exact, protect_ratio = protect_ratio
      ),
      " the ", model$Model[-denominator], " model", model_ind[-denominator],
      collapse = "; "
    ),
    "."
  ))


  #### table ####
  model$Model <- paste0(" [", seq_len(nrow(model)), "] ", model$Model)
  bf_table <- as.data.frame(model)
  bf_table$BF <- insight::format_bf(exp(model$log_BF),
    name = NULL,
    exact = exact,
    protect_ratio = protect_ratio
  )
  colnames(bf_table) <- c("Model", "Bayes factor")

  footer <- list(
    paste0("\nBayes Factor Type: ", BF_method),
    paste0("\nAgainst denominator: Model ", denominator)
  )
  attr(bf_table, "table_footer") <- footer


  #### table full ####
  bf_table_full <- bf_table
  bf_table_full$BF2 <- insight::format_bf(exp(model$log_BF) / exp(model$log_BF)[max_den],
    name = NULL,
    exact = exact,
    protect_ratio = protect_ratio
  )

  colnames(bf_table_full) <- c(
    "Model",
    paste0("BF against model ", denominator, ""),
    paste0("BF against model ", max_den, " (best model)")
  )

  # Output
  out <- list(
    table_full = bf_table_full,
    table_short = bf_table,
    text_full = bf_text_full,
    text_short = bf_text,
    rules = interpretation,
    denominator = denominator,
    BF_method = BF_method
  )
}


# bayesfactor_inclusion ---------------------------------------------------

#' @rdname report.bayesfactor_models
#' @export
report.bayesfactor_inclusion <- function(x,
                                         interpretation = "jeffreys1961",
                                         exact = TRUE,
                                         protect_ratio = TRUE,
                                         ...) {
  out <- .report.bayesfactor_inclusion(
    x,
    interpretation = interpretation,
    exact = exact,
    protect_ratio = protect_ratio,
    ...
  )

  as.report(
    text = as.report_text(out$text_full, summary = out$text_short),
    table = as.report_table(out$table_full, summary = out$table_short),
    interpretation = out$interpretation,
    priorOdds = out$priorOdds,
    matched = out$matched
  )
}


#' @export
report_table.bayesfactor_inclusion <- function(x,
                                               interpretation = "jeffreys1961",
                                               exact = TRUE,
                                               protect_ratio = TRUE,
                                               ...) {
  out <- .report.bayesfactor_inclusion(
    x,
    interpretation = interpretation,
    exact = exact,
    protect_ratio = protect_ratio,
    ...
  )

  as.report_table(out$table_full,
    summary = out$table_short,
    interpretation = out$interpretation,
    priorOdds = out$priorOdds,
    matched = out$matched
  )
}

#' @export
report_text.bayesfactor_inclusion <- function(x,
                                              table = NULL,
                                              interpretation = "jeffreys1961",
                                              exact = TRUE,
                                              protect_ratio = TRUE,
                                              ...) {
  out <- .report.bayesfactor_inclusion(
    x,
    interpretation = interpretation,
    exact = exact,
    protect_ratio = protect_ratio,
    ...
  )

  as.report_text(out$text_full,
    summary = out$text_short,
    interpretation = out$interpretation,
    priorOdds = out$priorOdds,
    matched = out$matched
  )
}


#' @keywords internal
.report.bayesfactor_inclusion <- function(model,
                                          interpretation = "jeffreys1961",
                                          exact = TRUE,
                                          protect_ratio = TRUE,
                                          ...) {
  matched <- attr(model, "matched")
  priorOdds <- attr(model, "priorOdds")

  #### text ####
  bf_results <- data.frame(Term = rownames(model), stringsAsFactors = FALSE)
  bf_results$evidence <- effectsize::interpret_bf(exp(model$log_BF),
    rules = interpretation, include_value = TRUE,
    exact = exact, protect_ratio = protect_ratio
  )
  bf_results$postprob <- paste0(round(model$p_posterior * 100, ...), "%")

  bf_text <- paste0(
    "Bayesian model averaging (BMA) was used to obtain the average evidence ",
    "for each predictor. We found ",
    paste(
      paste0(bf_results$evidence, " including ", bf_results$Term),
      collapse = "; "
    ), "."
  )

  #### text full ####
  bf_explain <- paste0(
    "Bayesian model averaging (BMA) was used to obtain the average evidence ",
    "for each predictor. Since each model has a prior probability",
    # custom priors?
    if (is.null(priorOdds)) {
      NULL
    } else {
      paste0(
        " (here we used subjective prior odds of ",
        toString(priorOdds), ")"
      )
    },
    ", it is possible to sum the prior probability of all models that include ",
    "a predictor of interest (the prior inclusion probability), and of all ",
    "models that do not include that predictor (the prior exclusion probability). ",
    "After the data are observed, we can similarly consider the sums of the ",
    "posterior models' probabilities to obtain the posterior inclusion ",
    "probability and the posterior exclusion probability. The change from ",
    "prior to posterior inclusion odds is the Inclusion Bayes factor. ",
    # matched models?
    if (matched) {
      paste0(
        "For each predictor, averaging was done only across models that ",
        "did not include any interactions with that predictor; ",
        "additionally, for each interaction predictor, averaging was done ",
        "only across models that contained the main effect from which the ",
        "interaction predictor was comprised. This was done to prevent ",
        "Inclusion Bayes factors from being contaminated with non-relevant ",
        "evidence (see Mathot, 2017). "
      )
    } else {
      NULL
    }
  )

  bf_text_full <- paste0(
    bf_explain,
    paste0(
      "We found ",
      paste(
        paste0(
          bf_results$evidence, " including ", bf_results$Term,
          ", with models including ", bf_results$Term,
          " having an overall posterior probability of ", bf_results$postprob
        ),
        collapse = "; "
      ), "."
    )
  )

  #### table ####
  bf_table <- as.data.frame(model)
  colnames(bf_table) <- c("Pr(prior)", "Pr(posterior)", "Inclusion BF")
  bf_table <- cbind(Terms = rownames(bf_table), bf_table)
  rownames(bf_table) <- NULL
  bf_table$`Inclusion BF` <- insight::format_bf(
    bf_table$`Inclusion BF`,
    name = NULL,
    exact = exact,
    protect_ratio = protect_ratio
  )
  bf_table[, 2:3] <- insight::format_value(bf_table[, 2:3], ...)

  # make table footer
  footer <- list(
    sprintf("\nAcross %s", ifelse(matched, "matched models only.", "all models.")),
    ifelse(is.null(priorOdds),
      "\nAssuming unifor prior odds.",
      paste0("\nWith custom prior odds of [", toString(priorOdds), "].")
    )
  )
  attr(bf_table, "table_footer") <- footer


  #### table full ####
  bf_table_full <- bf_table


  #### out ####
  out <- list(
    table_full = bf_table_full,
    table_short = bf_table,
    text_full = bf_text_full,
    text_short = bf_text,
    interpretation = interpretation,
    priorOdds = priorOdds,
    matched = matched, ...
  )
}
