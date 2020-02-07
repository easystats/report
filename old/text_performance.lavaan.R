#' @export
text_performance.lavaan <- function(model, performance, ...) {

  # Initialialize
  text <- ""
  perf_table <- data.frame(Name = "TEMP", Value = NA, Interpretation = NA, Threshold = NA)

  # Chisq
  if(all(c("Chisq_p", "Chisq", "Chisq_df") %in% names(performance))){
    sig <- "significantly"
    if(performance$Chisq_p > .05){
      sig <- "not significantly"
    }
    text <- paste0(text,
                   "The model is ",
                   sig,
                   " different from a baseline model (Chi2(",
                   insight::format_value(performance$Chisq_df, protect_integers = TRUE),
                   ") = ",
                   insight::format_value(performance$Chisq),
                   ", ",
                   parameters::format_p(performance$Chisq_p), ").")
  }


  # GFI
  if("GFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "GFI",
                                   Value = performance$GFI,
                                   Interpretation = interpret_gfi(performance$GFI),
                                   Threshold = 0.95))
  }

  # AGFI
  if("AGFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "AGFI",
                                   Value = performance$AGFI,
                                   Interpretation = interpret_agfi(performance$AGFI),
                                   Threshold = 0.90))
  }

  # NFI
  if("NFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "NFI",
                                   Value = performance$NFI,
                                   Interpretation = interpret_nfi(performance$NFI, rules = "byrne1994"),
                                   Threshold = 0.90))
  }

  # NNFI
  if("NNFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "NNFI",
                                   Value = performance$NNFI,
                                   Interpretation = interpret_nnfi(performance$NNFI, rules = "byrne1994"),
                                   Threshold = 0.90))
  }

  # CFI
  if("CFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "CFI",
                                   Value = performance$CFI,
                                   Interpretation = interpret_cfi(performance$CFI),
                                   Threshold = 0.90))
  }

  # RMSEA
  if("RMSEA" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "RMSEA",
                                   Value = performance$RMSEA,
                                   Interpretation = interpret_rmsea(performance$RMSEA),
                                   Threshold = 0.05))
  }

  # SRMR
  if("SRMR" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "SRMR",
                                   Value = performance$SRMR,
                                   Interpretation = interpret_srmr(performance$SRMR),
                                   Threshold = 0.08))
  }

  # RFI
  if("RFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "RFI",
                                   Value = performance$RFI,
                                   Interpretation = interpret_rfi(performance$RFI),
                                   Threshold = 0.90))
  }

  # IFI
  if("IFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "IFI",
                                   Value = performance$IFI,
                                   Interpretation = interpret_ifi(performance$IFI),
                                   Threshold = 0.90))
  }

  # IFI
  if("PNFI" %in% names(performance)){
    perf_table <- rbind(perf_table,
                        data.frame(Name = "PNFI",
                                   Value = performance$PNFI,
                                   Interpretation = interpret_pnfi(performance$PNFI),
                                   Threshold = 0.50))
  }


  # Format
  perf_table <- perf_table[perf_table$Name != "TEMP", ]
  perf_table$Text <- paste0(
    perf_table$Name,
    " (",
    substring(insight::format_value(perf_table$Value), 2),
    ifelse(perf_table$Value > perf_table$Threshold, " > ", " < "),
    substring(insight::format_value(perf_table$Threshold), 2),
    ")"
  )

  # Satisfactory
  if(length(perf_table[perf_table$Interpretation == "satisfactory", "Text"]) >= 1){
    text_satisfactory <- paste0(
      "The ",
      report::format_text(perf_table[perf_table$Interpretation == "satisfactory", "Text"]),
      ifelse(length(perf_table[perf_table$Interpretation == "satisfactory", "Text"]) > 1, " suggest", " suggests"),
      " a satisfactory fit.")
  } else{
    text_satisfactory <- ""
  }

  # Poor
  if(length(perf_table[perf_table$Interpretation == "poor", "Text"]) >= 1){
    text_poor <- paste0(
      "The ",
      report::format_text(perf_table[perf_table$Interpretation == "poor", "Text"]),
      ifelse(length(perf_table[perf_table$Interpretation == "poor", "Text"]) > 1, " suggest", " suggests"),
      " a poor fit.")
  } else{
    text_poor <- ""
  }

  text <- paste(text, text_satisfactory, text_poor)


  text
}
