#' @export
text_model.estimate_contrasts <- function(model, details = FALSE, effsize = "funder2019", ...){

  description <- paste0("We ran a contrast anaysis based on estimated marginal means at different levels of the ", attributes(model)$levels, " factor")

  if(!is.null(attributes(model)$fixed)){
    description <- paste0(description,
                          " (adjusted for ",
                          attributes(model)$fixed,
                          ")")
  }

  description <- paste0(description, ".")

  # Details
  if(details){
    if(!is.null(attributes(model)$rope_range)){
      description <- paste0(description,
                            .text_rope(attributes(model)$rope_range, attributes(model)$rope_ci))
    }
    if(!is.null(attributes(model)$ci) && !is.null(attributes(model)$ci_method)){
      description <- paste0(description,
                            .text_ci(attributes(model)$ci, attributes(model)$ci_method))
    }
    if(!is.null(effsize)){
      description <- paste0(description,
                            .text_effsize(effsize))
    }
  }
  description <- paste0(description,
                        " Within this model:\n\n")
  description
}



#' @export
text_model.estimate_slopes <- function(model, details = FALSE, effsize = "funder2019", ...){

  description <- paste0("We estimated the marginal effect of ", attributes(model)$trend, " at different levels of the ", attributes(model)$levels, " factor")

  if(!is.null(attributes(model)$fixed)){
    description <- paste0(description,
                          " (adjusted for ",
                          attributes(model)$fixed,
                          ")")
  }

  description <- paste0(description, ".")

  # Details
  if(details){
    if(!is.null(attributes(model)$rope_range)){
      description <- paste0(description,
                            .text_rope(attributes(model)$rope_range, attributes(model)$rope_ci))
    }
    if(!is.null(attributes(model)$ci) && !is.null(attributes(model)$ci_method)){
      description <- paste0(description,
                            .text_ci(attributes(model)$ci, attributes(model)$ci_method))
    }
    if(!is.null(effsize)){
      description <- paste0(description,
                            .text_effsize(effsize))
    }
  }
  description <- paste0(description,
                        " Within this model:\n\n")
  description
}





#' @export
text_model.estimate_means <- function(model, details = FALSE, ...){

  levels <- attributes(model)$levels[!attributes(model)$levels %in% attributes(model)$fixed]
  description <- paste0("We estimated marginal means at different levels of the ", levels, " factor")

  if(!is.null(attributes(model)$fixed)){
    description <- paste0(description,
                          " (adjusted for ",
                          attributes(model)$fixed,
                          ")")
  }

  description <- paste0(description, ".")

  # Details
  if(details){
    if(!is.null(attributes(model)$ci) && !is.null(attributes(model)$ci_method)){
      description <- paste0(description,
                            .text_ci(attributes(model)$ci, attributes(model)$ci_method))
    }
  }
  description <- paste0(description,
                        " Within this model:\n\n")
  description
}