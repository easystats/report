test_that("report_participants", {
  data <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "M", "I", "I"),
    "Gender" = c("W", "W", "M", "M", "N", "N"),
    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3"),
    stringsAsFactors = FALSE
  )

  expect_snapshot(
    variant = "windows",
    report_participants(data, age = "Age", sex = "Sex", participant = "Participant")
  )
  expect_snapshot(
    variant = "windows",
    report_participants(data, participant = "Participant", spell_n = TRUE)
  )

  expect_equal(nchar(report_participants(data, participant = "Participant", spell_n = TRUE)), 160, ignore_attr = TRUE)

  data2 <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "O", "F", "O"),
    "Gender" = c("W", "W", "M", "O", "W", "O"),
    stringsAsFactors = FALSE
  )

  expect_snapshot(
    variant = "windows",
    report_participants(data2)
  )

  data3 <- data.frame(
    "Age" = c(22, 82, NA, NA, NA, NA),
    "Sex" = c("F", "F", "", "", "NA", NA),
    "Gender" = c("W", "W", "", "", "NA", NA),
    stringsAsFactors = FALSE
  )

  expect_snapshot(
    variant = "windows",
    report_participants(data3)
  )

  # Add tests for education, country, race
  data4 <- data.frame(
    "Education" = c(0, 8, -3, -5, 3, 5, NA),
    "Education2" = c("Bachelor", "PhD", "Highschool", "Highschool", "Bachelor", "Bachelor", NA),
    "Country" = c("USA", "Canada", "Canada", "India", "Germany", "USA", NA),
    "Race" = c("Black", NA, "White", "Asian", "Black", "Black", "White"),
    stringsAsFactors = FALSE
  )

  expect_snapshot(
    variant = "windows",
    report_participants(data4)
  )
  expect_snapshot(
    variant = "windows",
    report_participants(data4, education = "Education2")
  )
  expect_snapshot(
    variant = "windows",
    report_participants(data4, threshold = 15)
  )
})

test_that("report_participants test NAs no warning", {
  data <- data.frame(
    "Age" = c(22, 23, 54, 21, 8, 42),
    "Sex" = (c("Intersex", "F", "M", "M", "NA", NA)),
    "Gender" = (c("N", "W", "W", "M", "NA", NA)),
    "Country" = (c("USA", NA, "Canada", "Canada", "India", "Germany")),
    "Education" = factor(c(0, 8, -3, -5, 3, 5)),
    "Race" = c(LETTERS[1:5], NA)
  )
  expect_snapshot(
    variant = "windows",
    report_participants(data)
  )

  data <- data.frame(
    "Age" = factor(c(22, 23, 54, 21, 8, 42)),
    "Sex" = factor(c("Intersex", "F", "M", "M", "NA", NA)),
    "Gender" = factor(c("N", "W", "W", "M", "NA", NA)),
    "Country" = factor(c("USA", NA, "Canada", "Canada", "India", "Germany")),
    "Education" = factor(c(0, 8, -3, -5, 3, 5)),
    "Race" = factor(c(LETTERS[1:5], NA))
  )
  expect_snapshot(
    variant = "windows",
    report_participants(data, age = "Age", sex = "Sex")
  )
})
