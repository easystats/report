# Reporting the participant data

A helper function to help you format the participants data (age, sex,
...) in the participants section.

## Usage

``` r
report_participants(
  data,
  age = NULL,
  sex = NULL,
  gender = NULL,
  education = NULL,
  country = NULL,
  race = NULL,
  participants = NULL,
  by = NULL,
  spell_n = FALSE,
  digits = 1,
  threshold = 10,
  group = NULL,
  ...
)
```

## Arguments

- data:

  A data frame.

- age:

  The name of the column containing the age of the participant.

- sex:

  The name of the column containing the sex of the participant. The
  classes should be one of `c("Male", "M", "Female", "F")`. Note that
  you can specify other characters here as well (e.g., `"Intersex"`),
  but the function will group all individuals in those groups as
  `"Other"`.

- gender:

  The name of the column containing the gender of the classes should be
  one of
  `c("Man", "M", "Male", Woman", "W", "F", "Female", Non-Binary", "N")`.
  Note that you can specify other characters here as well (e.g.,
  `"Gender Fluid"`), but the function will group all individuals in
  those groups as `"Non-Binary"`.

- education:

  The name of the column containing education information.

- country:

  The name of the column containing country information.

- race:

  The name of the column containing race/ethnicity information.

- participants:

  The name of the participants' identifier column (for instance in the
  case of repeated measures).

- by:

  A character vector indicating the name(s) of the column(s) used for
  stratified description.

- spell_n:

  Logical, fully spell the sample size (`"Three participants"` instead
  of `"3 participants"`).

- digits:

  Number of significant digits.

- threshold:

  Percentage after which to combine, e.g., countries (default is 10%, so
  countries that represent less than 10% will be combined in the "other"
  category).

- group:

  Deprecated. Use `by` instead.

- ...:

  Arguments passed to or from other methods.

## Value

A character vector with description of the "participants", based on the
information provided in `data`.

## Examples

``` r
library(report)
data <- data.frame(
  "Age" = c(22, 23, 54, 21, 8, 42),
  "Sex" = c("Intersex", "F", "M", "M", "NA", NA),
  "Gender" = c("N", "W", "W", "M", "NA", NA)
)
report_participants(data, age = "Age", sex = "Sex")
#> [1] "6 participants (Mean age = 28.3, SD = 16.6, range: [8, 54]; Sex: 16.7% females, 33.3% males, 16.7% other, 33.33% missing; Gender: 33.3% women, 16.7% men, 16.67% non-binary, 33.33% missing)"

# Years of education (relative to high school graduation)
data$Education <- c(0, 8, -3, -5, 3, 5)
report_participants(data,
  age = "Age", sex = "Sex", gender = "Gender",
  education = "Education"
)
#> [1] "6 participants (Mean age = 28.3, SD = 16.6, range: [8, 54]; Sex: 16.7% females, 33.3% males, 16.7% other, 33.33% missing; Gender: 33.3% women, 16.7% men, 16.67% non-binary, 33.33% missing; Mean education = 1.3, SD = 4.9, range: [-5, 8])"

# Education as factor
data$Education2 <- c(
  "Bachelor", "PhD", "Highschool",
  "Highschool", "Bachelor", "Bachelor"
)
report_participants(data, age = "Age", sex = "Sex", gender = "Gender", education = "Education2")
#> [1] "6 participants (Mean age = 28.3, SD = 16.6, range: [8, 54]; Sex: 16.7% females, 33.3% males, 16.7% other, 33.33% missing; Gender: 33.3% women, 16.7% men, 16.67% non-binary, 33.33% missing; Education: Bachelor, 50.00%; Highschool, 33.33%; PhD, 16.67%)"

# Country
data <- data.frame(
  "Age" = c(22, 23, 54, 21, 8, 42, 18, 32, 24, 27, 45),
  "Sex" = c("Intersex", "F", "F", "M", "M", "M", "F", "F", "F", "F", "F"),
  "Gender" = c("N", "W", "W", "M", "M", "M", "W", "W", "W", "W", "W"),
  "Country" = c(
    "USA", NA, "Canada", "Canada", "India", "Germany",
    "USA", "USA", "USA", "USA", "Canada"
  )
)
report_participants(data)
#> [1] "11 participants (Mean age = 28.7, SD = 13.4, range: [8, 54]; Sex: 63.6% females, 27.3% males, 9.1% other; Gender: 63.6% women, 27.3% men, 9.09% non-binary; Country: 45.45% USA, 27.27% Canada, 27.27% other)"

# Country, control presentation treshold
report_participants(data, threshold = 5)
#> [1] "11 participants (Mean age = 28.7, SD = 13.4, range: [8, 54]; Sex: 63.6% females, 27.3% males, 9.1% other; Gender: 63.6% women, 27.3% men, 9.09% non-binary; Country: 45.45% USA, 27.27% Canada, 9.09% Germany, 9.09% India, 9.09% missing)"

# Race/ethnicity
data <- data.frame(
  "Age" = c(22, 23, 54, 21, 8, 42, 18, 32, 24, 27, 45),
  "Sex" = c("Intersex", "F", "F", "M", "M", "M", "F", "F", "F", "F", "F"),
  "Gender" = c("N", "W", "W", "M", "M", "M", "W", "W", "W", "W", "W"),
  "Race" = c(
    "Black", NA, "White", "Asian", "Black", "Arab", "Black",
    "White", "Asian", "Southeast Asian", "Mixed"
  )
)
report_participants(data)
#> [1] "11 participants (Mean age = 28.7, SD = 13.4, range: [8, 54]; Sex: 63.6% females, 27.3% males, 9.1% other; Gender: 63.6% women, 27.3% men, 9.09% non-binary; Race: 27.27% Black, 18.18% Asian, 18.18% White, 36.36% other)"

# Race/ethnicity, control presentation treshold
report_participants(data, threshold = 5)
#> [1] "11 participants (Mean age = 28.7, SD = 13.4, range: [8, 54]; Sex: 63.6% females, 27.3% males, 9.1% other; Gender: 63.6% women, 27.3% men, 9.09% non-binary; Race: 27.27% Black, 18.18% Asian, 18.18% White, 9.09% Arab, 9.09% Mixed, 9.09% Southeast Asian, 9.09% missing)"

# Repeated measures data
data <- data.frame(
  "Age" = c(22, 22, 54, 54, 8, 8),
  "Sex" = c("I", "F", "M", "M", "F", "F"),
  "Gender" = c("N", "W", "W", "M", "M", "M"),
  "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3")
)
report_participants(data, age = "Age", sex = "Sex", gender = "Gender", participants = "Participant")
#> [1] "3 participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; Sex: 33.3% females, 33.3% males, 33.3% other; Gender: 33.3% women, 33.3% men, 33.33% non-binary)"

# Grouped data
data <- data.frame(
  "Age" = c(22, 22, 54, 54, 8, 8, 42, 42),
  "Sex" = c("I", "I", "M", "M", "F", "F", "F", "F"),
  "Gender" = c("N", "N", "W", "M", "M", "M", "Non-Binary", "Non-Binary"),
  "Participant" = c("S1", "S1", "s2", "s2", "s3", "s3", "s4", "s4"),
  "Condition" = c("A", "A", "A", "A", "B", "B", "B", "B")
)

report_participants(data,
  age = "Age",
  sex = "Sex",
  gender = "Gender",
  participants = "Participant",
  by = "Condition"
)
#> [1] "For the 'Condition - A' group: 2 participants (Mean age = 38.0, SD = 22.6, range: [22, 54]; Sex: 0.0% females, 50.0% males, 50.0% other; Gender: 50.0% women, 0.0% men, 50.00% non-binary) and for the 'Condition - B' group: 2 participants (Mean age = 25.0, SD = 24.0, range: [8, 42]; Sex: 100.0% females, 0.0% males, 0.0% other; Gender: 0.0% women, 50.0% men, 50.00% non-binary)"

# Spell sample size
paste(
  report_participants(data, participants = "Participant", spell_n = TRUE),
  "were recruited in the study by means of torture and coercion."
)
#> [1] "Four participants (Mean age = 31.5, SD = 20.5, range: [8, 54]; Sex: 50.0% females, 25.0% males, 25.0% other; Gender: 25.0% women, 25.0% men, 50.00% non-binary) were recruited in the study by means of torture and coercion."
```
