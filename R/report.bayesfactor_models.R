#' Report Models' Bayes Factor
#'
#' Create a report of Bayes factors for model comparison.
#'
#' @param x Object of class \code{bayesfactor_inclusion}.
#' @param interpretation Effect size interpretation set of rules (see \link[effectsize]{interpret_bf}).
#' @inheritParams report
#' @inherit report return seealso
#'
#' @examples
#' library(report)
#'
#' mo0 <- lm(Sepal.Length ~ 1, data = iris)
#' mo1 <- lm(Sepal.Length ~ Species, data = iris)
#' mo2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
#' mo3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)
#'
#' if (require("bayestestR")) {
#'   # Bayes factor - models
#'   BFmodels <- bayesfactor_models(mo1, mo2, mo3, denominator = mo0)
#'
#'   r <- report(BFmodels)
#'   r
#'   as.data.frame(r)
#'
#'   # Bayes factor - inclusion
#'   inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1, 2, 3), match_models = TRUE)
#'
#'   r <- report(inc_bf)
#'   r
#'   as.data.frame(r)
#' }
#' @importFrom effectsize interpret_bf
#' @importFrom stats setNames
#' @importFrom insight format_bf
#' @export
report.bayesfactor_models <- function(x, interpretation = "jeffreys1961", ...) {
  out <- .report.bayesfactor_models(x, interpretation=interpretation, ...)
  as.report(text = as.report_text(out$text_full, summary = out$text_short),
            table = as.report_table(out$table_full,summary = out$table_short),
            rules = out$rules,
            denominator = out$denominator,
            BF_method = out$BF_method)
}


#' @export
report_table.bayesfactor_models <- function(x, interpretation = "jeffreys1961", ...) {
  out <- .report.bayesfactor_models(x, interpretation=interpretation, ...)
  as.report_table(out$table_full,
                  summary = out$table_short,
                  rules = out$rules,
                  denominator = out$denominator,
                  BF_method = out$BF_method)
}

#' @export
report_text.bayesfactor_models <- function(x, table=NULL, interpretation = "jeffreys1961", ...) {
  out <- .report.bayesfactor_models(x, interpretation=interpretation, ...)
  as.report_text(out$text_full,
                  summary = out$text_short,
                  rules = out$rules,
                  denominator = out$denominator,
                  BF_method = out$BF_method)
}



#' @keywords internal
.report.bayesfactor_models <- function(model, interpretation = "jeffreys1961", ...) {
  model$Model[model$Model == "1"] <- "(Intercept only)"
  denominator <- attr(model, "denominator")
  BF_method <- attr(model, "BF_method")
  max_den <- which.max(model$BF)
  min_den <- which.min(model$BF)

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
      effectsize::interpret_bf(model$BF[summ_inds], rules = interpretation, include_value = TRUE,
                               protect_ratio = TRUE, exact = TRUE),
      " the ", model$Model[summ_inds], " model", model_ind[summ_inds],
      collapse = "; "
    ),
    "."
  )


  #### text full ####
  if (grepl("BIC", BF_method)) {
    bf_explain <- paste0(
      "Bayes factors were computed using the BIC approximation, ",
      "by which BF10 = exp((BIC0 - BIC1)/2). "
    )
  } else if (grepl("JZS", BF_method)) {
    bf_explain <- paste0(
      "Bayes factors were computed with the `BayesFactor` package, ",
      "using JZS priors. "
    )
  } else if (grepl("bridgesampling", BF_method)) {
    bf_explain <- paste0(
      "Bayes factors were computed by comparing marginal likelihoods, ",
      "using the `bridgesampling` package. "
    )
  }

  bf_text_full <- paste0(bf_explain, paste0(
    "Compared to the ", model$Model[denominator], " model", model_ind[denominator], ", ",
    "we found ",
    paste0(
      effectsize::interpret_bf(model$BF[-denominator], rules = interpretation, include_value = TRUE,
                               protect_ratio = TRUE, exact = TRUE),
      " the ", model$Model[-denominator], " model", model_ind[-denominator],
      collapse = "; "
    ),
    "."
  ))


  #### table ####
  model$Model <- paste0(" [", seq_len(nrow(model)), "] ", model$Model)
  bf_table <- as.data.frame(model)
  bf_table$BF <- insight::format_bf(model$BF, name = NULL, protect_ratio = TRUE, exact = TRUE)
  colnames(bf_table) <- c("Model", "Bayes factor")

  table_footer <- matrix(rep("", 6), nrow = 3)
  table_footer[2, 1] <- paste0("Bayes Factor Type: ", BF_method)
  table_footer[3, 1] <- paste0("Against denominator - model ", denominator)
  colnames(table_footer) <- colnames(bf_table)
  bf_table <- rbind(bf_table, table_footer)


  #### table full ####
  bf_table_full <- head(bf_table, -1)
  bf_table_full$BF2 <- c(insight::format_bf(model$BF / model$BF[max_den], name = NULL, protect_ratio = TRUE, exact = TRUE), "", "")

  colnames(bf_table_full) <- c(
    "Model",
    paste0("BF (against model ", denominator, ")"),
    paste0("BF (against best model ", max_den, ")")
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
#' @importFrom effectsize interpret_bf
#' @importFrom insight format_value
#' @importFrom stats setNames
#' @export
report.bayesfactor_inclusion <- function(x, interpretation = "jeffreys1961", ...) {
  out <- .report.bayesfactor_inclusion(x, interpretation=interpretation, ...)
  as.report(text = as.report_text(out$text_full, summary = out$text_short),
            table = as.report_table(out$table_full,summary = out$table_short),
            interpretation = out$interpretation,
            priorOdds = out$priorOdds,
            matched = out$matched)
}


#' @export
report_table.bayesfactor_inclusion <- function(x, interpretation = "jeffreys1961", ...) {
  out <- .report.bayesfactor_inclusion(x, interpretation=interpretation, ...)
  as.report_table(out$table_full,
                  summary = out$table_short,
                  interpretation = out$interpretation,
                  priorOdds = out$priorOdds,
                  matched = out$matched)
}

#' @export
report_text.bayesfactor_inclusion <- function(x, table=NULL, interpretation = "jeffreys1961", ...) {
  out <- .report.bayesfactor_inclusion(x, interpretation=interpretation, ...)
  as.report_text(out$text_full,
                 summary = out$text_short,
                 interpretation = out$interpretation,
                 priorOdds = out$priorOdds,
                 matched = out$matched)
}


#' @keywords internal
.report.bayesfactor_inclusion <- function(model, interpretation = "jeffreys1961", ...) {
  matched <- attr(model, "matched")
  priorOdds <- attr(model, "priorOdds")

  #### text ####
  bf_results <- data.frame(Term = rownames(model), stringsAsFactors = FALSE)
  bf_results$evidence <- effectsize::interpret_bf(model$BF, rules = interpretation, include_value = TRUE)
  bf_results$postprob <- paste0(round(model$p_posterior * 100, ...), "%")

  bf_text <- paste0(
    "Bayesian model averaging (BMA) was used to obtain the average evidence ",
    "for each predictor. We found ",
    paste0(
      paste0(bf_results$evidence, " including ", bf_results$Term),
      collapse = "; "
    ), "."
  )

  #### text full ####
  bf_explain <- paste0(
    "Bayesian model averaging (BMA) was used to obtain the average evidence ",
    "for each predictor. Since each model has a prior probability",
    # custom priors?
    if (is.null(priorOdds)) NULL else paste0(
      " (here we used subjective prior odds of ",
      paste0(priorOdds, collapse = ", "), ")"
    ),
    ", it is possible to sum the prior probability of all models that include ",
    "a predictor of interest (the prior inclusion probability), and of all ",
    "models that do not include that predictor (the prior exclusion probability). ",
    "After the data are observed, we can similarly consider the sums of the ",
    "posterior models' probabilities to obtain the posterior inclusion ",
    "probability and the posterior exclusion probability. The change from ",
    "prior to posterior inclusion odds is the Inclusion Bayes factor. ",
    # matched models?
    if (!matched) NULL else paste0(
      "For each predictor, averaging was done only across models that ",
      "did not include any interactions with that predictor; ",
      "additionally, for each interaction predictor, averaging was done ",
      "only across models that contained the main effect from which the ",
      "interaction predictor was comprised. This was done to prevent ",
      "Inclusion Bayes factors from being contaminated with non-relevant ",
      "evidence (see Mathot, 2017). "
    )
  )
  bf_text_full <- paste0(
    bf_explain,
    paste0(
      "We found ",
      paste0(
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
  bf_table$`Inclusion BF` <- insight::format_bf(bf_table$`Inclusion BF`, name = NULL, protect_ratio = TRUE)
  bf_table[, 2:3] <- insight::format_value(bf_table[, 2:3], ...)

  # make table footer
  table_footer <- matrix(rep("", 12), nrow = 3)
  table_footer[2:3, 1] <- c(
    ifelse(matched,
      "Across matched models only,",
      "Across all models,"
    ),
    ifelse(is.null(priorOdds),
      "assuming unifor prior odds.",
      paste0("with custom prior odds of [", paste0(priorOdds, collapse = ", "), "].")
    )
  )
  # pad with empty cells:
  colnames(table_footer) <- colnames(bf_table)

  bf_table <- rbind(bf_table, table_footer)


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
    matched = matched, ...)
}
