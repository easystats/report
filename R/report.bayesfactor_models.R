#' @export
report.bayesfactor_models <- function(model, rules = "jeffreys1961", ...){

  model$Model[model$Model == "1"] <- "(Intercept only)"
  denominator <- attr(model,"denominator")
  BF_method <- attr(model,"BF_method")

  #### text ####
  bf_text <- paste0(
    "Compared to the ", model$Model[denominator]," model, ",
    "we found ",
    paste0(
      interpret_bf(model$BF[-denominator],rules = rules, include_value = TRUE),
      " the ", model$Model[-denominator]," model",
      collapse = "; "
    ),
    "."
  )


  #### text full ####
  # add methods: JZS, BIC, bridgesampling
  bf_text_full <- bf_text


  #### table ####
  model$Model <- paste0(" [", seq_len(nrow(model)), "] ", model$Model)

  bf_table <- as.data.frame(model)
  bf_table$BF <- bayestestR:::.format_big_small(model$BF, ...)
  colnames(bf_table) <- c("Model","Bayes factor")

  table_footer <- matrix(rep("",6),nrow = 3)
  table_footer[2,1] <- paste0("Bayes Factor Type: ",BF_method)
  table_footer[3,1] <- paste0("Against denominator - model ",denominator)
  colnames(table_footer) <- colnames(bf_table)
  bf_table <- rbind(bf_table,table_footer)


  #### table full ####

  bf_table_full <- head(bf_table, -1)
  max_den <- which.max(model$BF)
  bf_table_full$BF2 <- c(bayestestR:::.format_big_small(model$BF/model$BF[max_den]),"","")

  colnames(bf_table_full) <- c("Model",
                               paste0("BF (against model ",denominator,")"),
                               paste0("BF (against best model ",max_den,")"))





  #### values ####
  bf_values <- as.list(setNames(model$BF,model$Model))

  out <- list(
    text = bf_text,
    text_full = bf_text_full,
    table = bf_table,
    table_full = bf_table_full,
    values = bf_values
  )

  return(as.report(out, rules = rules, denominator = denominator, BF_method = BF_method, ...))
}

