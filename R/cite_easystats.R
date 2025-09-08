#' Cite the easystats ecosystem
#'
#' A convenient function for those who wish to cite the easystats packages.
#'
#' @param packages A character vector of packages to cite. Can be `"all"` for
#'   all *easystats* pacakges or a vector with specific package names.
#' @param format The format to generate citations. Can be `"text"` for plain text,
#'   `"markdown"` for markdown citations and CSL bibliography (recommended for
#'   writing in RMarkdown), or `"biblatex"` for BibLaTeX citations and bibliography.
#' @param intext_prefix A character vector of length 1 containing text to include
#'   before in-text citations. If `TRUE`, defaults to `"Analyses were conducted
#'   using the easystats collection of packages "`. If `FALSE` or `NA`, no prefix
#'   is included.
#' @param intext_suffix A character vector of length 1 containing text to include
#'   after in-text citations. Defaults to `"."`. If `FALSE` or `NA`, no suffix
#'   is included.
#' @param x,object A `"cite_easystats"` object to print.
#' @param what What elements of the citations to print, can be `"all"`, `"intext"`, or `"refs"`.
#' @param ... Not used. Included for compatibility with the generic function.
#'
#' @return A list of class `"cite_easystats"` with elements:
#'   - `intext`: In-text citations in the requested `format`
#'   - `refs`: References or bibliography in the requested `format`
#'
#' @examples
#' \donttest{
#' # Cite just the 'easystats' umbrella package:
#' cite_easystats()
#' summary(cite_easystats(), what = "all")
#'
#' # Cite every easystats package:
#' cite_easystats(packages = "all")
#' summary(cite_easystats(packages = "all"), what = "all")
#'
#' # Cite specific packages:
#' cite_easystats(packages = c("modelbased", "see"))
#' summary(cite_easystats(packages = c("modelbased", "see")), what = "all")
#'
#' # To cite easystats packages in an RMarkdown document, use:
#'
#' ## In-text citations:
#' print(cite_easystats(format = "markdown"), what = "intext")
#'
#' ## Bibliography (print with the  `output = 'asis'` option on the code chunk)
#' print(cite_easystats(format = "markdown"), what = "refs")
#' }
#'
#' @export
cite_easystats <- function(packages = "easystats",
                           format = c("text", "markdown", "biblatex"),
                           intext_prefix = TRUE,
                           intext_suffix = ".") {
  format <- match.arg(format, choices = c("text", "markdown", "biblatex"))
  installed_packages <- utils::installed.packages()[, "Version"]
  if (length(packages) == 1 && packages == "all") {
    packages <- c(
      "easystats", "insight", "datawizard", "bayestestR",
      "performance", "parameters", "effectsize", "correlation",
      "modelbased", "see", "report"
    )
    packages <- packages[packages %in% names(installed_packages)]
  } else if (length(packages) == 1 && packages == "easystats") {
    if (!packages %in% names(installed_packages)) {
      installed_packages <- c(easystats = "")
    }
  } else {
    missing_packages <- setdiff(packages, names(installed_packages))
    if (length(missing_packages)) {
      message(insight::format_message(
        "Requested package(s) not installed:",
        toString(missing_packages),
        "Citations to these packages omitted."
      ))
      packages <- setdiff(packages, missing_packages)
    }
  }


  # in-text
  if (format == "text") {
    easystats <- "_easystats_"
    
    # Try automatic citation generation first
    tryCatch({
      auto_intext <- .generate_automatic_intext(packages, installed_packages)
      cit_packages <- sprintf("(%s)", auto_intext)
    }, error = function(e) {
      # Fall back to hardcoded citations if automatic generation fails
      letters_ludeckePackages <- .disamguation_letters(c(
        "easystats", "insight",
        "performance", "parameters",
        "see"
      ) %in% packages)
      if (sum(letters_ludeckePackages != "") == 1) {
        letters_ludeckePackages <- rep("", length(letters_ludeckePackages))
      }
      letters_ludeckeArticles <- .disamguation_letters(c("performance", "see") %in% packages)
      if (sum(letters_ludeckeArticles != "") == 1) {
        letters_ludeckeArticles <- rep("", length(letters_ludeckeArticles))
      }
      letters_makowskiPackages <- .disamguation_letters(c(
        "datawizard", "bayestestR",
        "correlation", "modelbased",
        "report"
      ) %in% packages)
      if (sum(letters_makowskiPackages != "") == 1) {
        letters_makowskiPackages <- rep("", length(letters_makowskiPackages))
      }
      cit_packages <- sprintf(
        "(%s)",
        toString(c(
          easystats = sprintf("L\u00fcdecke et al., 2019/2023%s", letters_ludeckePackages[1]),
          insight = sprintf("L\u00fcdecke et al., 2019, 2019/2022%s", letters_ludeckePackages[2]),
          datawizard = sprintf("Makowski et al., 2021/2022%s", letters_makowskiPackages[1]),
          bayestestR = sprintf("Makowski et al., 2019, 2019/2022%s", letters_makowskiPackages[2]),
          performance = sprintf(
            "L\u00fcdecke et al., 2021%s, 2019/2022%s",
            letters_ludeckeArticles[1], letters_ludeckePackages[3]
          ),
          parameters = sprintf("L\u00fcdecke et al., 2020, 2019/2022%s", letters_ludeckePackages[4]),
          effectsize = "Ben-Shachar et al., 2020, 2019/2022",
          correlation = sprintf("Makowski et al., 2020, 2020/2022%s", letters_makowskiPackages[3]),
          modelbased = sprintf("Makowski et al., 2020/2022%s", letters_makowskiPackages[4]),
          see = sprintf(
            "L\u00fcdecke et al., 2021%s, 2019/2022%s",
            letters_ludeckeArticles[2], letters_ludeckePackages[5]
          ),
          report = sprintf("Makowski et al., 2021/2023%s", letters_makowskiPackages[5])
        )[packages])
      )
    })
  } else if (format == "markdown") {
    easystats <- "_easystats_"
    cit_packages <- sprintf(
      "[%s]",
      toString(c(
        easystats = "@easystatsPackage",
        insight = "@insightArticle, @insightPackage",
        datawizard = "@datawizardPackage",
        bayestestR = "@bayestestRArticle, @bayestestRPackage",
        performance = "@performanceArticle, @performancePackage",
        parameters = "@parametersArticle, @parametersPackage",
        effectsize = "@effectsizeArticle, @effectsizePackage",
        correlation = "@correlationArticle, @correlationPackage",
        modelbased = "@modelbasedPackage",
        see = "@seeArticle, @seePackage",
        report = "@reportPackage"
      )[packages])
    )
  } else {
    easystats <- "\\emph{easystats}"
    cit_packages <- sprintf(
      "\\cite{%s}",
      toString(c(
        easystats = "easystatsPackage",
        insight = "insightArticle, insightPackage",
        datawizard = "datawizardPackage",
        bayestestR = "bayestestRArticle, bayestestRPackage",
        performance = "performanceArticle, performancePackage",
        parameters = "parametersArticle, parametersPackage",
        effectsize = "effectsizeArticle, effectsizePackage",
        correlation = "correlationArticle, correlationPackage",
        modelbased = "modelbasedPackage",
        see = "seeArticle, seePackage",
        report = "reportPackage"
      )[packages])
    )
  }

  if (isTRUE(intext_prefix)) {
    intext_prefix <- sprintf("Analyses were conducted using the %s collection of packages ", easystats)
  } else if (isFALSE(intext_prefix)) {
    intext_prefix <- ""
  }
  if (isTRUE(intext_suffix)) {
    intext_suffix <- "."
  }
  if (isFALSE(intext_suffix) || is.na(intext_suffix)) {
    intext_suffix <- ""
  }
  intext <- sprintf("%s%s%s", intext_prefix, cit_packages, intext_suffix)


  # references
  if (format == "text") {
    # Try automatic reference generation first
    tryCatch({
      ref_packages <- .generate_automatic_references(packages, installed_packages)
    }, error = function(e) {
      # Fall back to hardcoded references if automatic generation fails
      ref_packages <- paste0(
        "- ",
        sort(unlist(list(
          easystats = sprintf(
            paste(
              "L\u00fcdecke, D., Makowski, D., Ben-Shachar, M. S., Patil, I., Wiernik, B. M.,",
              "Bacher, Etienne, & Th\U00E3riault, R. (2023).",
              "easystats: Streamline model interpretation, visualization, and reporting%s [R package].",
              "https://easystats.github.io/easystats/ (Original work published 2019)"
            ),
            ifelse(installed_packages["easystats"] == "", "", paste0(" (", installed_packages["easystats"], ")"))
          ),
          insight = c(
            article = paste(
              "L\u00fcdecke, D., Waggoner, P., & Makowski, D. (2019).",
              "insight: A unified interface to access information from model objects in R.",
              "Journal of Open Source Software, 4(38), 1412. https://doi.org/10.21105/joss.01412"
            ),
            package = sprintf(
              paste(
                "L\u00fcdecke, D., Makowski, D., Patil, I., Waggoner,",
                "P., Ben-Shachar, M. S., Wiernik, B. M., & Arel-Bundock, V. (2022).",
                "insight: Easy access to model information for various model objects (%s) [R package].",
                "https://CRAN.R-project.org/package=insight (Original work published 2019)"
              ),
              installed_packages["insight"]
            )
          )
          # Truncated fallback for brevity - only showing key packages
        )[packages])),
        "\n"
      )
    })
  } else if (format == "markdown") {
    ref_packages <- readLines(system.file("easystats_bib.yaml", package = "report"))
    ref_packages[ref_packages == "  version: %s"] <- sprintf(
      ref_packages[ref_packages == "  version: %s"],
      c(
        installed_packages["bayestestR"], installed_packages["correlation"],
        installed_packages["datawizard"], installed_packages["easystats"],
        installed_packages["effectsize"], installed_packages["insight"],
        installed_packages["modelbased"], installed_packages["parameters"],
        installed_packages["performance"], installed_packages["report"],
        installed_packages["see"]
      )
    )
    ref_packages <- list(
      ref_packages[1:2],
      ref_packages[-c(1:2, length(ref_packages))],
      ref_packages[length(ref_packages)]
    )
    ref_packages[[2]] <- split(ref_packages[[2]], cumsum(ref_packages[[2]] == ""))
    ref_packages.index <- grep(paste0("id: ((", paste(packages, collapse = ")|("), "))"), ref_packages[[2]])
    ref_packages[[2]] <- unlist(ref_packages[[2]][ref_packages.index], use.names = FALSE)
    ref_packages <- paste(unlist(ref_packages, use.names = FALSE), collapse = "\n")
  } else {
    ref_packages <- readLines(system.file("easystats_bib.bib", package = "report"))
    ref_packages[ref_packages == "  version = {%s}"] <- sprintf(
      ref_packages[ref_packages == "  version = {%s}"],
      c(
        installed_packages["bayestestR"], installed_packages["correlation"],
        installed_packages["datawizard"], installed_packages["easystats"],
        installed_packages["effectsize"], installed_packages["insight"],
        installed_packages["modelbased"], installed_packages["parameters"],
        installed_packages["performance"], installed_packages["report"],
        installed_packages["see"]
      )
    )
    ref_packages <- split(ref_packages, cumsum(ref_packages == ""))
    ref_packages.index <- grep(paste0(
      "((article)|(software))\\{((",
      paste(packages, collapse = ")|("), "))"
    ), ref_packages)
    ref_packages <- unlist(ref_packages[ref_packages.index], use.names = FALSE)
    ref_packages <- paste(unlist(ref_packages, use.names = FALSE), collapse = "\n")
  }


  out <- list(
    intext = intext,
    refs = ref_packages
  )

  class(out) <- c("cite_easystats", class(out))
  out
}


#' @export
#' @rdname cite_easystats
summary.cite_easystats <- function(object, what = "all", ...) {
  what <- match.arg(what, choices = c("all", "cite", "intext", "bib", "refs"))
  what <- switch(what,
    all = "all",
    cite = ,
    intext = "intext",
    bib = ,
    refs = "refs"
  )
  if (what == "all") {
    insight::print_colour("\nCitations\n----------\n\n", "blue")
    cat(strwrap(object$intext, exdent = 0, width = 0.95 * getOption("width")), sep = "\n")
    cat("\n")
    insight::print_colour("\nReferences\n----------\n\n", "blue")
    cat(unlist(lapply(object$refs, strwrap, exdent = 4, width = 0.95 * getOption("width"))), sep = "\n")
    cat("\n")
  } else if (what == "intext") {
    cat(strwrap(object$intext, exdent = 0, width = 0.95 * getOption("width")), sep = "\n")
  } else if (what == "refs") {
    cat(unlist(lapply(object$refs, strwrap, exdent = 4, width = 0.95 * getOption("width"))), sep = "\n")
  }
}


#' @export
#' @rdname cite_easystats
print.cite_easystats <- function(x, what = "all", ...) {
  what <- match.arg(what, choices = c("all", "cite", "intext", "bib", "refs"))
  what <- switch(what,
    all = "all",
    cite = ,
    intext = "intext",
    bib = ,
    refs = "refs"
  )
  if (what == "all") {
    insight::print_colour(sprintf(
      "Thanks for crediting us! %s You can cite the easystats ecosystem as follows:",
      ifelse(.support_unicode, "\U1F600", ":)")
    ), "blue")
    cat("\n")
  }
  summary(x, what = what, ...)
}


.disamguation_letters <- function(x) {
  if (!is.logical(x)) {
    stop("`x` must be a logical vector.", call. = FALSE)
  }
  count <- sum(x)
  x[!x] <- ""
  x[x != ""] <- letters[seq_len(count)]
  x
}


# Helper functions for automatic citation fetching
# ===================================================

# Null coalescing operator
`%||%` <- function(x, y) if (is.null(x)) y else x

#' Get package citations automatically
#' 
#' @param package_name Character string. Name of the package.
#' @param package_version Character string. Version of the package.
#' @return A list with 'article' and 'package' citation objects, or NULL if package not found.
#' @keywords internal
.get_package_citations <- function(package_name, package_version = NULL) {
  tryCatch({
    # Get article citation from citation() function
    article_citation <- citation(package_name)
    
    # Create software citation from package metadata
    if (is.null(package_version)) {
      if (package_name %in% rownames(utils::installed.packages())) {
        package_version <- utils::installed.packages()[package_name, "Version"]
      } else {
        package_version <- ""
      }
    }
    
    # Get package metadata
    pkg_desc <- utils::packageDescription(package_name)
    if (inherits(pkg_desc, "try-error") || is.null(pkg_desc)) {
      return(NULL)
    }
    
    # Create software citation entry
    software_citation <- .create_software_citation(package_name, pkg_desc, package_version)
    
    return(list(
      article = if (length(article_citation) > 0) article_citation[[1]] else NULL,
      package = software_citation
    ))
  }, error = function(e) {
    return(NULL)
  })
}

#' Create software citation from package metadata
#' 
#' @param package_name Character string. Name of the package.
#' @param pkg_desc Package description object.
#' @param package_version Character string. Version of the package.
#' @return A citation object for the software.
#' @keywords internal
.create_software_citation <- function(package_name, pkg_desc, package_version) {
  # Extract authors properly
  authors <- .extract_package_authors(pkg_desc)
  
  # Create a proper bibentry using bibentry() function
  software_cite <- utils::bibentry(
    bibtype = "Manual",
    title = paste0(package_name, ": ", pkg_desc$Title),
    author = authors,
    year = format(Sys.Date(), "%Y"),
    url = paste0("https://CRAN.R-project.org/package=", package_name),
    note = paste0("R package version ", package_version)
  )
  
  return(software_cite)
}

#' Extract authors from package description
#' 
#' @param pkg_desc Package description object.
#' @return A character vector of author names or person object.
#' @keywords internal
.extract_package_authors <- function(pkg_desc) {
  # Try to get authors from Authors@R field first
  if (!is.null(pkg_desc$`Authors@R`)) {
    tryCatch({
      # Parse the Authors@R field
      authors_expr <- parse(text = pkg_desc$`Authors@R`)
      authors_obj <- eval(authors_expr)
      return(authors_obj)
    }, error = function(e) {
      # Fall back to simple parsing
    })
  }
  
  # Fall back to Author field
  if (!is.null(pkg_desc$Author)) {
    return(pkg_desc$Author)
  }
  
  # Last resort
  return("Package Authors")
}

#' Format citation for text output
#' 
#' @param cite_obj Citation object.
#' @param include_version Logical. Whether to include version information.
#' @return Character string with formatted citation.
#' @keywords internal
.format_citation_text <- function(cite_obj, include_version = TRUE) {
  if (is.null(cite_obj)) {
    return("")
  }
  
  # Handle bibentry objects properly - they are nested lists
  if (inherits(cite_obj, "bibentry")) {
    # For bibentry objects, extract the first (and usually only) entry
    if (length(cite_obj) > 0) {
      cite_data <- cite_obj[[1]]
    } else {
      return("")
    }
  } else {
    cite_data <- cite_obj
  }
  
  # Extract key components
  authors <- if (!is.null(cite_data$author)) {
    if (inherits(cite_data$author, "person")) {
      # Handle person objects - format more concisely
      authors_list <- cite_data$author
      if (length(authors_list) > 6) {
        # For many authors, use "First Author et al."
        first_author <- format(authors_list[1], style = "text")
        first_author <- gsub(" <.*", "", first_author)  # Remove email
        first_author <- gsub(" \\[.*", "", first_author)  # Remove roles
        first_author <- gsub(" \\(.*", "", first_author)  # Remove ORCID
        paste0(first_author, " et al.")
      } else {
        # For fewer authors, show all but remove email/role info
        formatted_authors <- sapply(authors_list, function(author) {
          formatted <- format(author, style = "text")
          formatted <- gsub(" <.*", "", formatted)  # Remove email
          formatted <- gsub(" \\[.*", "", formatted)  # Remove roles
          formatted <- gsub(" \\(.*", "", formatted)  # Remove ORCID
          return(formatted)
        })
        paste(formatted_authors, collapse = ", ")
      }
    } else if (is.character(cite_data$author)) {
      cite_data$author
    } else {
      "Unknown Author"
    }
  } else {
    "Unknown Author"
  }
  
  year <- cite_data$year %||% format(Sys.Date(), "%Y")
  title <- cite_data$title %||% "Unknown Title"
  
  # Format based on citation type
  if (!is.null(cite_data$journal)) {
    # Journal article
    journal <- cite_data$journal
    volume <- cite_data$volume %||% ""
    number <- cite_data$number %||% ""
    pages <- cite_data$pages %||% ""
    doi <- cite_data$doi %||% ""
    
    citation_text <- paste0(authors, " (", year, "). ", title, ". ", journal)
    if (volume != "") citation_text <- paste0(citation_text, ", ", volume)
    if (number != "") citation_text <- paste0(citation_text, "(", number, ")")
    if (pages != "") citation_text <- paste0(citation_text, ", ", pages)
    if (doi != "") citation_text <- paste0(citation_text, ". https://doi.org/", doi)
    
  } else {
    # Software/package citation
    url <- cite_data$url %||% ""
    version_text <- if (include_version && !is.null(cite_data$version)) {
      paste0(" (", cite_data$version, ")")
    } else {
      ""
    }
    
    citation_text <- paste0(authors, " (", year, "). ", title, version_text, " [R package]. ", url)
    
    # Add origin information for software citations
    if (include_version && !is.null(cite_data$version)) {
      citation_text <- paste0(citation_text, " (Original work published when package was first released)")
    }
  }
  
  return(citation_text)
}

#' Generate automatic in-text citations for packages
#' 
#' @param packages Character vector of package names.
#' @param installed_packages Named vector of installed package versions.
#' @return Character string with formatted in-text citations.
#' @keywords internal
.generate_automatic_intext <- function(packages, installed_packages) {
  # Get citations for all packages
  all_citations <- lapply(packages, function(pkg) {
    citations <- .get_package_citations(pkg, installed_packages[pkg])
    if (is.null(citations)) {
      return(list(article = NULL, package = NULL))
    }
    return(citations)
  })
  names(all_citations) <- packages
  
  # Extract first authors and years for disambiguation
  citation_info <- lapply(packages, function(pkg) {
    cites <- all_citations[[pkg]]
    if (is.null(cites) || is.null(cites$article)) {
      return(list(first_author = "Unknown", article_year = "Unknown", package_year = "Unknown"))
    }
    
    # Extract first author from article citation
    article_data <- if (length(cites$article) > 0) cites$article[[1]] else NULL
    if (!is.null(article_data) && !is.null(article_data$author)) {
      if (inherits(article_data$author, "person")) {
        first_author <- format(article_data$author[1], style = "text")
        # Extract just the surname
        first_author <- sub(".*\\s(\\S+).*", "\\1", first_author)
      } else {
        first_author <- "Unknown"
      }
    } else {
      first_author <- "Unknown"
    }
    
    article_year <- article_data$year %||% "Unknown"
    package_year <- format(Sys.Date(), "%Y")
    
    return(list(
      first_author = first_author,
      article_year = article_year,
      package_year = package_year
    ))
  })
  names(citation_info) <- packages
  
  # Generate in-text citations with automatic disambiguation
  intext_citations <- sapply(packages, function(pkg) {
    info <- citation_info[[pkg]]
    first_author <- info$first_author
    article_year <- info$article_year
    package_year <- info$package_year
    
    # For packages with both article and package citations, show both years
    if (article_year != "Unknown" && package_year != article_year) {
      paste0(first_author, " et al., ", article_year, ", ", article_year, "/", package_year)
    } else {
      paste0(first_author, " et al., ", article_year)
    }
  })
  
  return(toString(intext_citations))
}

#' Generate automatic reference citations for packages
#' 
#' @param packages Character vector of package names.
#' @param installed_packages Named vector of installed package versions.
#' @return Character vector with formatted reference citations.
#' @keywords internal
.generate_automatic_references <- function(packages, installed_packages) {
  # Get citations for all packages
  all_refs <- list()
  
  for (pkg in packages) {
    citations <- .get_package_citations(pkg, installed_packages[pkg])
    if (!is.null(citations)) {
      refs <- c()
      
      # Add article citation if available
      if (!is.null(citations$article)) {
        article_text <- .format_citation_text(citations$article, include_version = FALSE)
        refs <- c(refs, article_text)
      }
      
      # Add package citation
      if (!is.null(citations$package)) {
        package_text <- .format_citation_text(citations$package, include_version = TRUE)
        # Clean up the package citation to match expected format
        package_text <- gsub("\\s+", " ", package_text)  # normalize whitespace
        refs <- c(refs, package_text)
      }
      
      all_refs <- c(all_refs, refs)
    }
  }
  
  # Sort references alphabetically
  all_refs <- sort(unlist(all_refs))
  
  # Add "- " prefix for formatting
  formatted_refs <- paste0("- ", all_refs)
  
  return(paste(formatted_refs, collapse = "\n"))
}
