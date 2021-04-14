#' Cite the easystats ecosystem
#'
#' A convenient function for those who wish to cite the easystats packages.
#'
#' @examples
#' cite_easystats()
#' summary(cite_easystats())
#' as.data.frame(cite_easystats())
#'
#' @return An object of class \code{cite_easystats} that can be printed, summarized (using \code{summary()}), or transformed into a table (using \code{as.data.frame()}).
#'
#' @export
cite_easystats <- function() {
  intro <- "Thanks for crediting us :) You can cite the 'easystats' ecosystem as follows:"

  # TODO: How to deal with your umlaut Daniel :( ?

  intext <- "Data analysis was carried out using the 'easystats' collection of packagaes (Ludecke, Waggoner, & Makowski, 2019; Makowski, Ben-Shachar, & Ludecke, 2019; Makowski, Ben-Shachar, Patil, & Ludecke, 2020; Ludecke, Ben-Shachar, Patil, & Makowski, 2020; Ben-Shachar, Ludecke, & Makowski, 2020)."


  # References
  ref_insight <- "Ludecke, D., Waggoner, P. D., & Makowski, D. (2019). insight: A Unified Interface to Access Information from Model Objects in R. Journal of Open Source Software, 4, 1412. doi: 10.21105/joss.01412"

  ref_bayestestR <- "Makowski, D., Ben-Shachar, M.S., & Ludecke, D. (2019). bayestestR: Describing Effects and their Uncertainty, Existence and Significance within the Bayesian Framework. Journal of Open Source Software, 4(40), 1541. 10.21105/joss.01541"

  ref_parameters <- "Ludecke, D., Ben-Shachar, M.S., Patil, I., Makowski, D. (2020). parameters: Extracting, Computing and Exploring the Parameters of Statistical Models using R. Journal of Open Source Software, 5(53), 2445. doi: 10.21105/joss.02445"

  ref_effectsize <- "Ben-Shachar, M.S., Ludecke, D., Makowski, D. (2020). effectsize: Estimation of Effect Size Indices and Standardized Parameters. Journal of Open Source Software, 5(56), 2815. doi: 10.21105/joss.02815"

  ref_correlation <- "Makowski, D., Ben-Shachar, M.S., Patil, I., & Ludecke, D. (2019). Methods and Algorithms for Correlation Analysis in R. Journal of Open Source Software, 5(51), 2306. 10.21105/joss.02306"

  refs <- c(ref_insight, ref_bayestestR, ref_parameters, ref_effectsize, ref_correlation)

  table <- data.frame(Reference = refs)

  bib <- "
  @article{ludecke2019insight,
    journal = {Journal of Open Source Software},
    doi = {10.21105/joss.01412},
    issn = {2475-9066},
    number = {38},
    publisher = {The Open Journal},
    title = {insight: A Unified Interface to Access Information from Model Objects in R},
    url = {http://dx.doi.org/10.21105/joss.01412},
    volume = {4},
    author = {L{\"u}decke, Daniel and Waggoner, Philip and Makowski, Dominique},
    pages = {1412},
    date = {2019-06-25},
    year = {2019},
    month = {6},
    day = {25}
  }


  @article{makowski2019bayestestr,
      title = {{bayestestR}: {Describing} {Effects} and their {Uncertainty}, {Existence} and {Significance} within the {Bayesian} {Framework}},
      volume = {4},
      issn = {2475-9066},
      shorttitle = {{bayestestR}},
      url = {https://joss.theoj.org/papers/10.21105/joss.01541},
      doi = {10.21105/joss.01541},
      number = {40},
      urldate = {2019-08-13},
      journal = {Journal of Open Source Software},
      author = {Makowski, Dominique and Ben-Shachar, Mattan S. and L{\"u}decke, Daniel},
      month = aug,
      year = {2019},
      pages = {1541}
  }

  @article{makowski2020correlation,
    doi={10.21105/joss.02306},
    title={Methods and Algorithms for Correlation Analysis in R},
    author={Makowski, Dominique and Ben-Shachar, Mattan S. and Patil, Indrajeet and L{\"u}decke, Daniel},
    journal={Journal of Open Source Software},
    volume={5},
    number={51},
    pages={2306},
    year={2020}
  }

  @article{ludecke20202parameters,
    title = {parameters: Extracting, Computing and Exploring the Parameters of Statistical Models using {R}.},
    volume = {5},
    doi = {10.21105/joss.02445},
    number = {53},
    journal = {Journal of Open Source Software},
    author = {Daniel L{\"u}decke and Mattan S. Ben-Shachar and Indrajeet Patil and Dominique Makowski},
    year = {2020},
    pages = {2445},
  }

  @article{benchashar2020effectsize,
    title = {{e}ffectsize: Estimation of Effect Size Indices and Standardized Parameters},
    author = {Mattan S. Ben-Shachar and Daniel L{\"u}decke and Dominique Makowski},
    year = {2020},
    journal = {Journal of Open Source Software},
    volume = {5},
    number = {56},
    pages = {2815},
    publisher = {The Open Journal},
    doi = {10.21105/joss.02815},
    url = {https://doi.org/10.21105/joss.02815},
  }
  "

  out <- list(intro = intro, intext = intext, refs = refs, table = table, bib = bib)

  class(out) <- c("cite_easystats", class(out))
  out
}


#' @export
as.data.frame.cite_easystats <- function(x, ...) {
  x$table
}

#' @export
as.report_table.cite_easystats <- as.data.frame.cite_easystats


#' @export
summary.cite_easystats <- function(object, ...) {
  cat(object$intext)
  insight::print_colour("\n\nReferences\n----------\n\n", "blue")
  cat(paste0(paste("-", object$refs), collapse = "\n"))
}


#' @export
print.cite_easystats <- function(x, ...) {
  insight::print_colour(x$intro, "blue")
  cat("\n\n")
  cat(x$intext)
  insight::print_colour("\n\nReferences\n----------\n\n", "blue")
  cat(paste0(paste("-", x$refs), collapse = "\n"))
  insight::print_colour("\n\nBibtex entries:\n---------------\n\n", "blue")
  cat(x$bib)
}
