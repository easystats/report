#' @export
text_performance.lm <- function(model, performance, ...) {
  text <- ""
  text_full <- ""

  # Intercept-only
  if(all(insight::find_parameters(model, flatten = FALSE) == "(Intercept)")){
    return(list("text" = text, "text_full" = text_full))
  }

  # R2
  if ("R2" %in% names(performance)) {

    r2 <- attributes(performance)$r2

    text <- paste0(
      "\n\nThe model's explanatory power is ",
      interpret_r2(performance$R2, rules = "cohen1988"),
      " (R2 = ",
      parameters::format_value(performance$R2)
    )
    text_full <- paste0(
      "\n\nThe model explains a ",
      interpret_p(r2$p),
      " and ",
      interpret_r2(performance$R2, rules = "cohen1988"),
      " proportion of variance (R2 = ",
      parameters::format_value(performance$R2),
      ", F(",
      parameters::format_value(r2$df, protect_integers = TRUE),
      ", ",
      parameters::format_value(r2$df_residual, protect_integers = TRUE),
      ") = ",
      parameters::format_value(r2$`F`),
      ", ",
      parameters::format_p(r2$p)
    )

    if ("R2_adjusted" %in% names(performance)) {
      text <- paste0(
        text, ", adj. R2 = ",
        parameters::format_value(performance$R2_adjusted),
        ")."
      )
      text_full <- paste0(
        text_full, ", adj. R2 = ",
        parameters::format_value(performance$R2_adjusted),
        ")."
      )
    } else {
      text <- paste0(text, ".")
      text_full <- paste0(text_full, ").")
    }
  }


  list(
    "text" = text,
    "text_full" = text_full
  )
}





#' @export
# model_text_performance_logistic <- function(performance, ...) {
#   text <- ""
#   text_full <- ""
#
#   # R2
#   if ("R2_Tjur" %in% names(performance)) {
#     text <- paste0(
#       "The model's explanatory power is ",
#       interpret_r2(performance$R2_Tjur, rules = "cohen1988"),
#       " (Tjur's R2 = ",
#       format_value(performance$R2_Tjur),
#       ")."
#     )
#     text_full <- text
#   }
#   if ("R2_Nagelkerke" %in% names(performance)) {
#     text <- paste0(
#       "The model's explanatory power is ",
#       interpret_r2(performance$R2_Nagelkerke, rules = "cohen1988"),
#       " (Nagelkerke's R2 = ",
#       format_value(performance$R2_Nagelkerke),
#       ")."
#     )
#     text_full <- text
#   }
#   if ("R2_McFadden" %in% names(performance)) {
#     text <- paste0(
#       "The model's explanatory power is ",
#       interpret_r2(performance$R2_McFadden, rules = "cohen1988"),
#       " (McFadden's R2 = ",
#       format_value(performance$R2_McFadden),
#       ")."
#     )
#
#     text_full <- text
#   }
#
#   out <- list(
#     "text" = text,
#     "text_full" = text_full
#   )
#   return(out)
# }






#' @keywords internal
# model_text_performance_bayesian <- function(performance, ci = 0.90, ...) {
#   text <- ""
#   text_full <- ""
#
#   # R2
#   if ("R2_Median" %in% names(performance)) {
#     text <- paste0(
#       "The model's explanatory power is ",
#       interpret_r2(performance$R2_Median, rules = "cohen1988"),
#       " (R2's median = ",
#       format_value(performance$R2_Median)
#     )
#     text_full <- paste0(
#       "The model's total explanatory power is ",
#       interpret_r2(performance$R2_Median, rules = "cohen1988"),
#       " (R2's median = ",
#       format_value(performance$R2_Median),
#       ", MAD = ",
#       format_value(performance$R2_MAD),
#       ", ",
#       format_ci(performance$R2_CI_low, performance$R2_CI_high, ci = ci)
#     )
#
#     if ("R2_LOO_adjusted" %in% names(performance)) {
#       text <- paste0(
#         text, ", LOO adj. R2 = ",
#         format_value(performance$R2_LOO_adjusted),
#         ")."
#       )
#       text_full <- paste0(
#         text_full, ", LOO adj. R2 = ",
#         format_value(performance$R2_LOO_adjusted),
#         ")."
#       )
#     } else {
#       text <- paste0(text, ").")
#       text_full <- paste0(text_full, ").")
#     }
#   }
#
#   if ("R2_marginal_Median" %in% names(performance)) {
#     if (text != "") {
#       text <- paste0(text, " ")
#       text_full <- paste0(text_full, " ")
#     }
#
#     text <- paste0(
#       text,
#       "Within this model, the explanatory power related to the",
#       " fixed effects alone (marginal R2's median) is of ",
#       format_value(performance$R2_marginal_Median),
#       "."
#     )
#
#     text_full <- paste0(
#       text_full,
#       "Within this model, the explanatory power related to the",
#       " fixed effects alone (marginal R2's median) is of ",
#       format_value(performance$R2_marginal_Median),
#       " (MAD = ",
#       format_value(performance$R2_marginal_MAD),
#       ", ",
#       format_ci(performance$R2_marginal_CI_high, performance$R2_marginal_CI_high, ci = ci),
#       ")."
#     )
#   }
#
#   out <- list(
#     "text" = text,
#     "text_full" = text_full
#   )
#   return(out)
# }







#' @keywords internal
# model_text_performance_mixed <- function(performance, ...) {
#   text <- ""
#
#   # R2 Conditional
#   if ("R2_conditional" %in% names(performance)) {
#     text <- paste0(
#       "The model's total explanatory power is ",
#       interpret_r2(performance$R2_conditional, rules = "cohen1988"),
#       " (conditional R2 = ",
#       format_value(performance$R2_conditional),
#       ")")
#   }
#
#   # R2 marginal
#   if ("R2_marginal" %in% names(performance)) {
#     if(text == ""){
#       text <- "The"
#     } else{
#       text <- paste0(text, " and the")
#     }
#     text <- paste0(text,
#                    " part related to the",
#                    " fixed effects alone (marginal R2) is of ",
#                    format_value(performance$R2_marginal),
#                    ".")
#   } else{
#     text <- paste0(text, ".")
#   }
#
#
#   text_full <- text
#
#   # ICC
#   # ?
#
#   out <- list(
#     "text" = text,
#     "text_full" = text_full
#   )
#   return(out)
# }
