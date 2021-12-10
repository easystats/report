test_that("report_participants", {
  data <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "M", "I", "I"),
    "Gender" = c("W", "W", "M", "M", "N", "N"),
    "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
  )

  expect_equal(
    report_participants(data, age = "Age", sex = "Sex", participant = "Participant"),
    "3 participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; Sex: 33.3% females, 33.3% males, 33.3% other; Gender: 33.3% women, 33.3% men, 33.33% non-binary)"
  )

  expect_equal(nchar(report_participants(data, participant = "Participant", spell_n = TRUE)), 160)
  expect_equal(
    report_participants(data, participant = "Participant", spell_n = TRUE),
    "Three participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; Sex: 33.3% females, 33.3% males, 33.3% other; Gender: 33.3% women, 33.3% men, 33.33% non-binary)"
  )

  data2 <- data.frame(
    "Age" = c(22, 22, 54, 54, 8, 8),
    "Sex" = c("F", "F", "M", "O", "F", "O"),
    "Gender" = c("W", "W", "M", "O", "W", "O")
  )

  expect_equal(
    report_participants(data2),
    "6 participants (Mean age = 28.0, SD = 21.1, range: [8, 54]; Sex: 50.0% females, 16.7% males, 33.3% other; Gender: 50.0% women, 16.7% men, 33.33% non-binary)"
  )

  # TO DO : discuss if this is the correct approach to report in case of missing values

  ###### David Feinberg Comments ##########
  # There was no reporting of missing values for Age, but there was for Sex,
  # So I reported missing values for Age, Sex, and Gender.
  # I didn't touch education. There are no tests for education.
  # I belive these shouldn't be NA's in tests for Sex and Gender,
  # because NA means not available
  # but empty strings are available... they exist...
  # try:
  # > is.na("")
  # [1] FALSE
  # I suggest testing for empty strings as I put below.
  # NA works for age because that's supposed to be a number. Not sure if it's
  # going to work in all cases though...
  ###### David Feinberg Comments ##########

  data3 <- data.frame(
    "Age" = c(22, 82, NA, NA, NA, NA),
    "Sex" = c("F", "F", "", "", "", ""),
    "Gender" = c("W", "W", "", "", "", "")
  )

  expect_equal(
    report_participants(data3),
    "6 participants (Mean age = 52.0, SD = 42.4, range: [22, 82], 66.7% missing; Sex: 33.3% females, 0.0% males, 66.7% other, 0.00% missing; Gender: 33.3% women, 0.0% men, 66.67% non-binary, 0.00% missing)"
  )
})
