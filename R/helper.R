string_split_matrix <- function(x, pattern) {
  l <- strsplit(x, pattern)
  max_length <- length(l[[which.max(lapply(l, length))]])

  l <- lapply(l, function(i) {
    length(i) <- prod(dim(matrix(i, ncol = max_length)))
    i[is.na(i)] <- ""
    i
  })

  matrix(unlist(l), nrow = length(l))
}
