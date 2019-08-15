#' Inclusion Bayes factor Report
#'
#' Create a report of an h-test object.
#'
#' @param model Object of class \code{bayesfactor_inclusion}.
#' @param ... Arguments passed to or from other methods.
#' @inheritParams interpret_bf
#'
#'
#' @examples
#' \dontrun{
#' library(bayestestR)
#' library(report)
#'
#' mo0 <- lm(Sepal.Length ~ 1, data = iris)
#' mo1 <- lm(Sepal.Length ~ Species, data = iris)
#' mo2 <- lm(Sepal.Length ~ Species + Petal.Length, data = iris)
#' mo3 <- lm(Sepal.Length ~ Species * Petal.Length, data = iris)
#'
#' BFmodels <- bayesfactor_models(mo1, mo2, mo3, denominator = mo0)
#' inc_bf <- bayesfactor_inclusion(BFmodels, prior_odds = c(1,2,3), match_models = TRUE)
#'
#' bf_report <- report(inc_bf, digits = 3)
#' to_table(bf_report)
#' to_text(bf_report, full = FALSE)
#'
#' }
#' @seealso report
#'
#' @export
report.bayesfactor_inclusion <- function(model, rules = "jeffreys1961", ...){
  matched <- attr(model,"matched")
  priorOdds <- attr(model,"priorOdds")

  #### text ####
  bf_text <- paste0(
    "We found ",
    paste0(
      paste0(interpret_bf(model$BF,rules = rules, include_value = TRUE),
             " including ", rownames(model)),
      collapse = "; "
    ),"."
  )

  #### text full ####
  bf_explain <- paste0(
    "Bayesian model averaging (BMA) was used to obtain the average evidence ",
    "for each predictor. Since each model has a prior probability",
    # custom priors?
    switch(!is.null(priorOdds) + 1,NULL,paste0(" (here we used subjective prior odds of ",
                                             paste0(priorOdds, collapse = ", "), ")")),
    ", it is possible to sum the prior probability of all models that include ",
    "a predictor of interest (the prior inclusion probability), and of all ",
    "models that do not include that predictor (the prior exclusion probability). ",
    "After the data are observed, we can similarly consider the sums of the ",
    "posterior models’ probabilities to obtain the posterior inclusion ",
    "probability and the posterior exclusion probability. The change from ",
    "prior to posterior inclusion odds is the Inclusion Bayes factor. ",
    # matched models?
    switch(!matched + 1,NULL,
           paste0(
             "For each predictor, averaging was done only across models that ",
             "did not include any interactions with that predictor; ",
             "additionally, for each interaction predictor, averaging was done ",
             "only across models that contained the main effect from which the ",
             "interaction predictor was comprised. This was done to prevent ",
             "Inclusion Bayes factors from being contaminated with non-relevant ",
             "evidence (see Mathot, 2017). "
           ))
  )
  bf_text_full <- paste0(bf_explain,bf_text)





  #### table ####
  bf_table <- as.data.frame(model)
  colnames(bf_table) <- c("Pr(prior)", "Pr(posterior)", "Inclusion BF")
  bf_table <- cbind(Terms = rownames(bf_table),bf_table)
  rownames(bf_table) <- NULL
  bf_table$`Inclusion BF` <- bayestestR:::.format_big_small(bf_table$`Inclusion BF`,...)
  bf_table[,2:3] <- parameters::format_value(bf_table[,2:3], ...)

  # make table footer
  table_footer <- matrix(rep("",12),nrow = 3)
  table_footer[2:3,1] <- c(
    ifelse(matched,
           "Across matched models only,",
           "Across all models,"),
    ifelse(is.null(priorOdds),
           "assuming unifor prior odds.",
           paste0("with custom prior odds (", paste0(priorOdds, collapse = ", "), ")."))
  )
  # pad with empty cells:
  colnames(table_footer) <- colnames(bf_table)

  bf_table <- rbind(bf_table,table_footer)


  #### table full ####
  bf_table_full <- bf_table


  #### values ####
  bf_values <- as.list(setNames(model$BF,rownames(model)))

  out <- list(
    text = bf_text,
    text_full = bf_text_full,
    table = bf_table,
    table_full = bf_table_full,
    values = bf_values
  )

  return(as.report(out, rules = rules, priorOdds = priorOdds, matched = matched, ...))
}

