#' @export
text_model.lavaan <- function(model, standardize = TRUE, effsize = "funder2019", ...) {



  text_full <- paste0("The ",
                 toupper(model@call$model.type),
                 " model (estimated using ",
                 model@Model@estimator,
                 " and the ",
                 model@Options$optim.method,
                 " optimizer)"
                 )

  text <- paste0("We ran a ",
                 toupper(model@call$model.type),
                 " model"
  )


  convergence <- paste0(
    ifelse(model@optim$converged, "successfuly converged", "dit not converge"),
    " (AIC = ",
    insight::format_value(model@loglik$AIC),
    ", BIC = ",
    insight::format_value(model@loglik$BIC2),
    ").")


  list("text" = paste(text, convergence),
       "text_full" = paste(text_full, convergence))
}
