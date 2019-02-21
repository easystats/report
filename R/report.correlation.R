#' Correlation Report
#'
#' Create a report of a correlation object.
#'
#' @param model Object of class correlation
#' @param effsize Effect size interpretation set of rules.
#' @param stars Add significance stars in table. For frequentist correlations: \*p < .05, \*\*p < .01, \*\*\*p < .001. For Bayesian correlations: \*\*\*BF > 30, \*\*BF > 10, \*BF > 3.
#' @param reorder Should the tables be reordered based on correlation pattern (currently only works with square matrices)?
#' @param ... Arguments passed to or from other methods.
#'
#'
#'
#' @examples
#' model <- correlation(iris)
#' report(model)
#' @seealso report
#'
#' @export
report.correlation <- function(model, effsize = "cohen1988", stars=TRUE, reorder=TRUE, ...) {

  # Text ----


  info <- as.list(model)

  if(info$bayesian){
    if(info$ci == "default"){
      info$ci <- .9
    }
    description <- paste0(
      "We ran a Bayesian correlation analysis (prior scale set to ",
      info$prior,
      ").",
      .format_ROPE_description(info$rope_full, info$rope_bounds, info$ci))
  } else{
    if(info$ci == "default"){
      info$ci <- .95
    }

    if(info$partial == TRUE){
      description <- "We ran a partial correlation analysis"
    } else if(info$partial == "semi"){
      description <- "We ran a semi-partial correlation analysis"
    } else{
      description <- "We ran a correlation analysis"
    }

    if(info$p_adjust != "none"){
      description <- paste0(description, " with p-values adjusted using ", info$p_adjust, " correction")
    }
    description <- paste0(description, ".")
  }

  description <- paste0(description, .format_effsize_description(effsize))

  estimate <- c("rho", "r", "tau", "Median")[c("rho", "r", "tau", "Median") %in% names(model)]
  if("Group" %in% names(model)){
    group <- paste0("In ", model$Group, ", the")
  } else{
    group <- "the"
  }

  if("CI_low" %in% names(model)){
    ci_text <- paste0(", ", format_ci(model$CI_low, model$CI_high, info$ci))
  } else{
    ci_text <- ""
  }

  if(info$bayesian == FALSE){
    text <- paste0(
      "  - ",
      group,
      " correlation between ",
      model$Parameter1,
      " and ",
      model$Parameter2,
      " is ",
      interpret_direction(model[[estimate]]),
      ", ",
      interpret_p(model$p),
      " and ",
      interpret_r(model[[estimate]], rules=effsize),
      " (",
      estimate,
      " = ",
      format_value(model[[estimate]]),
      ci_text,
      ", p ",
      format_p(model$p, stars = FALSE),
      ")."
    )
  } else{
    text <- paste0(
      "  - There is ",
      interpret_bf(model$BF, include_bf=TRUE),
      " a ",
      interpret_direction(model[[estimate]]),
      " and ",
      interpret_r(model[[estimate]], rules=effsize),
      " correlation between ",
      model$Parameter1,
      " and ",
      model$Parameter2,
      " (r's median = ",
      format_value(model[[estimate]]),
      ci_text,
      ", ",
      format_pd(model$pd),
      ", ",
      format_rope(model$ROPE_Percentage),
      ")."
    )
  }

  text <- paste0(text, collapse = "\n")
  text <- paste0(description, "\n\n", text)
  text_full <- text


  # Tables ----
  # TODO: Improvements needed for a more efficient method
  data <- model
  if("Median" %in% names(data)){
    data$Cell <- data$Median
  } else{
    data$Cell <- data$r
  }
  r <- .create_cor_matrix(data, coltarget = "Cell", reorder=FALSE, lower=FALSE)
  r$Parameter <- NULL



  if("Median" %in% names(data)){
    data$Cell <- format_value(data$Median)
  } else{
    data$Cell <- format_value(data$r)
  }
  if(stars){
    data$Cell <- paste0(data$Cell, .add_stars(data))
  }
  table <- .create_cor_matrix(data, "Cell", reorder=reorder, lower=TRUE, dmat=r)

  if("Median" %in% names(data)){
    data$Cell <- paste0("r's median = ", format_value(data$Median))
  } else{
    data$Cell <- paste0("r = ", format_value(data$r))
  }
  if("CI_low" %in% names(data)){
    data$Cell <- paste0(data$Cell, ", ", format_ci(data$CI_low, data$CI_high, info$ci))
  }
  if("p" %in% names(data)){
    data$Cell <- paste0(data$Cell, ", p ", format_p(data$p))
  }
  if("BF" %in% names(data)){
    data$Cell <- paste0(data$Cell, ", ", format_bf(data$BF))
  }
  if(stars){
    data$Cell <- paste0(data$Cell, .add_stars(data))
  }
  table_full <- .create_cor_matrix(data, "Cell", reorder=reorder, lower=TRUE, dmat=r)


  # Reorder columns
  if("Group" %in% names(table)){
    table <- table[c('Group', 'Parameter', names(table)[!names(table) %in% c('Group', 'Parameter')])]
    table_full <- table_full[c('Group', 'Parameter', names(table_full)[!names(table_full) %in% c('Group', 'Parameter')])]
  } else{
    table <- table[c('Parameter', names(table)[!names(table) %in% c('Parameter')])]
    table_full <- table_full[c('Parameter', names(table_full)[!names(table_full) %in% c('Parameter')])]
  }

  # Remove empty
  table <- table[,colSums(is.na(table))<nrow(table)]
  table_full <- table_full[,colSums(is.na(table_full))<nrow(table_full)]

  out <- list(
    text = text,
    text_full = text_full,
    table = table,
    table_full = table_full,
    values = as.list(model)
  )

  return(as.report(out))
}



#' @keywords internal
.add_stars <- function(data){
  if("p" %in% names(data)){
    stars <- ifelse(data$p < .001, "***",
           ifelse(data$p < .01, "**",
                  ifelse(data$p < .05, "*", "")))
  } else if("BF" %in% names(data)){
    stars <- ifelse(data$BF > 30, "***",
                    ifelse(data$BF > 10, "**",
                           ifelse(data$BF > 3, "*", "")))
  } else{
    stars <- ""
  }
  return(stars)
}







#' @keywords internal
.create_cor_matrix <- function(data, coltarget, reorder=TRUE, lower=TRUE, dmat = NULL){
  if("Group" %in% names(data)){
    datalist <- split(data, data$Group)
    m <- data.frame()
    for(group in names(datalist)){
      dat <- datalist[[group]]
      dat$Group <- NULL
      dat <- .create_cor_matrix_core(dat, coltarget, reorder=FALSE, lower=lower, dmat = dmat)
      dat$Group <- group
      dat[nrow(dat) + 1, ] <- NA
      m <- rbind(m, dat)
    }
    m <- m[-nrow(m),]
  } else{
    m <- .create_cor_matrix_core(data, coltarget, reorder=reorder, lower=lower, dmat = dmat)
  }
  return(m)
}


#' @keywords internal
.create_cor_matrix_core <- function(data, coltarget, reorder=TRUE, lower=TRUE, dmat = NULL){
  rows <- sort(unique(data$Parameter1))
  cols <- sort(unique(data$Parameter2))
  m <- data.frame(matrix(ncol=length(cols), nrow=length(rows)), row.names = rows)
  colnames(m) <- cols

  for(col in cols){
    for(row in rows){
      if(is.null(data[data$Parameter1 == row & data$Parameter2 == col, coltarget])){
        cell <- NA
      } else{
        cell <- data[data$Parameter1 == row & data$Parameter2 == col, coltarget]
      }
      m[row, col] <- cell
    }
  }


  if (reorder == TRUE & all(unique(rownames(m)) == unique(names(m)))) {
    m <- .reorder_cor_matrix(m, dmat = dmat)
  }
  # Remove upper
  if(lower==TRUE & all(unique(rownames(m)) == unique(names(m)))){
    m[upper.tri(m, diag = TRUE)] <- NA
  }

  m$Parameter <- row.names(m)
  row.names(m) <- NULL

  return(m)
}







#' @importFrom stats as.dist hclust
#' @keywords internal
.reorder_cor_matrix <- function(mat, dmat = NULL) {
  if (is.null(dmat)) {
    dmat <- mat
    dmat$Parameter <- NULL
    dmat$Group <- NULL
  }

  if (ncol(mat) != nrow(mat) | ncol(dmat) != nrow(dmat)) {
    warning("Matrix must be squared to be re-arranged.")
    return(mat)
  }

  dmat <- as.dist((1 - dmat) / 2, diag = TRUE, upper = TRUE)
  hc <- hclust(dmat)
  mat <- mat[hc$order, hc$order]
  return(mat)
}