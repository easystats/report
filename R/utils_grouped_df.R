# returns the row-indices for grouped data frames
#' @keywords internal
.group_indices <- function(x) {
  # dplyr < 0.8.0 returns attribute "indices"
  grps <- attr(x, "groups", exact = TRUE)

  # dplyr < 0.8.0?
  if (is.null(grps)) {
    attr(x, "indices", exact = TRUE)
  } else {
    grps[[".rows"]]
  }
}


# returns the variables that were used for grouping data frames (dplyr::group_var())
#' @keywords internal
.group_vars <- function(x) {
  # dplyr < 0.8.0 returns attribute "indices"
  grps <- attr(x, "groups", exact = TRUE)

  # dplyr < 0.8.0?
  if (is.null(grps)) {
    ## TODO fix for dplyr < 0.8
    attr(x, "vars", exact = TRUE)
  } else {
    setdiff(colnames(grps), ".rows")
  }
}


# returns the 'drop' setting for groups on the data frame
#' @keywords internal
.groups_drop <- function(x) {
  !isFALSE(attr(attr(x, "groups"), ".drop"))
}


# returns if the data frame has groups
#' @keywords internal
.has_groups <- function(x) {
  if (length(.group_vars(x)) == 0L) FALSE else TRUE
}


# recompute group indices grouped_df, used after subsetting
#' @keywords internal
.calculate_groups <- function(x, groups, drop = .groups_drop(x)) {
  # if the dplyr namespace is attached, its `[.grouped_df` method produces
  # erroneous warnings and coerces output to tbl_df
  subset_data <- `[.data.frame`
  x <- .ungroup(x)
  unknown <- setdiff(groups, colnames(x))

  if (length(unknown) > 0L) {
    stop(
      insight::format_message(
        sprintf("`groups` missing from `x`: %s.", toString(groups))
      ),
      call. = FALSE
    )
  }

  unique_groups <- unique(x[, groups, drop = FALSE])
  is_factor <- do.call(c, lapply(unique_groups, is.factor))
  n_comb <- nrow(unique_groups)
  rows <- rep(list(NA), n_comb)

  for (i in seq_len(n_comb)) {
    rows[[i]] <- which(
      interaction(x[, groups, drop = TRUE]) %in%
        interaction(unique_groups[i, groups])
    )
  }

  if (!isTRUE(drop) && any(is_factor)) {
    na_lvls <- do.call(
      expand.grid,
      lapply(
        unique_groups,
        function(x) {
          if (is.factor(x)) {
            levels(x)[!(levels(x) %in% x)]
          } else {
            NA
          }
        }
      )
    )
    unique_groups <- rbind(unique_groups, na_lvls)
    for (i in seq_len(nrow(na_lvls))) {
      rows[[length(rows) + 1]] <- integer(0)
    }
  }

  unique_groups[[".rows"]] <- rows
  unique_groups <- unique_groups[
    do.call(
      order,
      lapply(groups, function(x) unique_groups[, x])
    ),
    ,
    drop = FALSE
  ]

  rownames(unique_groups) <- NULL

  structure(unique_groups, .drop = drop)
}


# ungroup data frame
#' @keywords internal
.ungroup <- function(x) {
  attr(x, "groups") <- NULL
  class(x) <- setdiff(class(x), "grouped_df")
  x
}


# re-sets the groups for a grouped_df, used after subsetting
#' @keywords internal
.groups_set <- function(x, groups, drop = .groups_drop(x)) {
  attr(x, "groups") <- if (is.null(groups) || length(groups) == 0L) {
    NULL
  } else {
    .calculate_groups(x, groups, drop)
  }
  x
}
