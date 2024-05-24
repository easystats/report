# report_sample default

    Code
      report_sample(airquality)
    Output
      # Descriptive Statistics
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  42.13 (32.99)
      Mean Solar.R (SD) | 185.93 (90.06)
      Mean Wind (SD)    |    9.96 (3.52)
      Mean Temp (SD)    |   77.88 (9.47)
      Mean Month (SD)   |    6.99 (1.42)
      Mean Day (SD)     |   15.80 (8.86)

---

    Code
      report_sample(mtcars)
    Output
      # Descriptive Statistics
      
      Variable       |         Summary
      --------------------------------
      Mean mpg (SD)  |    20.09 (6.03)
      Mean cyl (SD)  |     6.19 (1.79)
      Mean disp (SD) | 230.72 (123.94)
      Mean hp (SD)   |  146.69 (68.56)
      Mean drat (SD) |     3.60 (0.53)
      Mean wt (SD)   |     3.22 (0.98)
      Mean qsec (SD) |    17.85 (1.79)
      Mean vs (SD)   |     0.44 (0.50)
      Mean am (SD)   |     0.41 (0.50)
      Mean gear (SD) |     3.69 (0.74)
      Mean carb (SD) |     2.81 (1.62)

---

    Code
      report_sample(iris)
    Output
      # Descriptive Statistics
      
      Variable                |     Summary
      -------------------------------------
      Mean Sepal.Length (SD)  | 5.84 (0.83)
      Mean Sepal.Width (SD)   | 3.06 (0.44)
      Mean Petal.Length (SD)  | 3.76 (1.77)
      Mean Petal.Width (SD)   | 1.20 (0.76)
      Species [setosa], %     |        33.3
      Species [versicolor], % |        33.3
      Species [virginica], %  |        33.3

# report_sample n = TRUE

    Code
      report_sample(airquality, n = TRUE)
    Output
      # Descriptive Statistics
      
      Variable             |             Summary
      ------------------------------------------
      Mean Ozone (SD), n   |  42.13 (32.99), 116
      Mean Solar.R (SD), n | 185.93 (90.06), 146
      Mean Wind (SD), n    |    9.96 (3.52), 153
      Mean Temp (SD), n    |   77.88 (9.47), 153
      Mean Month (SD), n   |    6.99 (1.42), 153
      Mean Day (SD), n     |   15.80 (8.86), 153

---

    Code
      report_sample(mtcars, n = TRUE)
    Output
      # Descriptive Statistics
      
      Variable          |             Summary
      ---------------------------------------
      Mean mpg (SD), n  |    20.09 (6.03), 32
      Mean cyl (SD), n  |     6.19 (1.79), 32
      Mean disp (SD), n | 230.72 (123.94), 32
      Mean hp (SD), n   |  146.69 (68.56), 32
      Mean drat (SD), n |     3.60 (0.53), 32
      Mean wt (SD), n   |     3.22 (0.98), 32
      Mean qsec (SD), n |    17.85 (1.79), 32
      Mean vs (SD), n   |     0.44 (0.50), 32
      Mean am (SD), n   |     0.41 (0.50), 32
      Mean gear (SD), n |     3.69 (0.74), 32
      Mean carb (SD), n |     2.81 (1.62), 32

---

    Code
      report_sample(iris, n = TRUE)
    Output
      # Descriptive Statistics
      
      Variable                   |          Summary
      ---------------------------------------------
      Mean Sepal.Length (SD), n  | 5.84 (0.83), 150
      Mean Sepal.Width (SD), n   | 3.06 (0.44), 150
      Mean Petal.Length (SD), n  | 3.76 (1.77), 150
      Mean Petal.Width (SD), n   | 1.20 (0.76), 150
      Species [setosa], %, n     |         33.3, 50
      Species [versicolor], %, n |         33.3, 50
      Species [virginica], %, n  |         33.3, 50

# report_sample CI

    Code
      report_sample(iris, select = c("Sepal.Length", "Species"), ci = 0.95,
      ci_method = "wald")
    Output
      # Descriptive Statistics
      
      Variable                |           Summary
      -------------------------------------------
      Mean Sepal.Length (SD)  |       5.84 (0.83)
      Species [setosa], %     | 33.3 [25.8, 40.9]
      Species [versicolor], % | 33.3 [25.8, 40.9]
      Species [virginica], %  | 33.3 [25.8, 40.9]

---

    Code
      report_sample(iris, select = c("Sepal.Length", "Species"), ci = 0.95,
      ci_method = "wilson")
    Output
      # Descriptive Statistics
      
      Variable                |           Summary
      -------------------------------------------
      Mean Sepal.Length (SD)  |       5.84 (0.83)
      Species [setosa], %     | 33.3 [26.3, 41.2]
      Species [versicolor], % | 33.3 [26.3, 41.2]
      Species [virginica], %  | 33.3 [26.3, 41.2]

---

    Code
      report_sample(d, ci = 0.95, select = "x", ci_method = "wald")
    Output
      # Descriptive Statistics
      
      Variable |        Summary
      -------------------------
      x [1], % | 2.9 [1.9, 3.9]

---

    Code
      report_sample(d, ci = 0.95, select = "x", ci_method = "wilson")
    Output
      # Descriptive Statistics
      
      Variable |        Summary
      -------------------------
      x [1], % | 2.9 [2.0, 4.1]

---

    Code
      report_sample(d, ci = 0.95, ci_correct = TRUE, select = "x", ci_method = "wald")
    Output
      # Descriptive Statistics
      
      Variable |        Summary
      -------------------------
      x [1], % | 2.9 [1.8, 4.0]

---

    Code
      report_sample(d, ci = 0.95, ci_correct = TRUE, select = "x", ci_method = "wilson")
    Output
      # Descriptive Statistics
      
      Variable |        Summary
      -------------------------
      x [1], % | 2.9 [2.0, 4.2]

# report_sample by

    Code
      report_sample(airquality, by = "Month")
    Output
      # Descriptive Statistics
      
      Variable          |        5 (n=31) |       6 (n=30) |       7 (n=31) |       8 (n=31) |       9 (n=30) |  Total (n=153)
      ------------------------------------------------------------------------------------------------------------------------
      Mean Ozone (SD)   |   23.62 (22.22) |  29.44 (18.21) |  59.12 (31.64) |  59.96 (39.68) |  31.45 (24.14) |  42.13 (32.99)
      Mean Solar.R (SD) | 181.30 (115.08) | 190.17 (92.88) | 216.48 (80.57) | 171.86 (76.83) | 167.43 (79.12) | 185.93 (90.06)
      Mean Wind (SD)    |    11.62 (3.53) |   10.27 (3.77) |    8.94 (3.04) |    8.79 (3.23) |   10.18 (3.46) |    9.96 (3.52)
      Mean Temp (SD)    |    65.55 (6.85) |   79.10 (6.60) |   83.90 (4.32) |   83.97 (6.59) |   76.90 (8.36) |   77.88 (9.47)
      Mean Day (SD)     |    16.00 (9.09) |   15.50 (8.80) |   16.00 (9.09) |   16.00 (9.09) |   15.50 (8.80) |   15.80 (8.86)

---

    Code
      report_sample(mtcars, by = "cyl")
    Output
      # Descriptive Statistics
      
      Variable       |       4 (n=11) |        6 (n=7) |       8 (n=14) |    Total (n=32)
      -----------------------------------------------------------------------------------
      Mean mpg (SD)  |   26.66 (4.51) |   19.74 (1.45) |   15.10 (2.56) |    20.09 (6.03)
      Mean disp (SD) | 105.14 (26.87) | 183.31 (41.56) | 353.10 (67.77) | 230.72 (123.94)
      Mean hp (SD)   |  82.64 (20.93) | 122.29 (24.26) | 209.21 (50.98) |  146.69 (68.56)
      Mean drat (SD) |    4.07 (0.37) |    3.59 (0.48) |    3.23 (0.37) |     3.60 (0.53)
      Mean wt (SD)   |    2.29 (0.57) |    3.12 (0.36) |    4.00 (0.76) |     3.22 (0.98)
      Mean qsec (SD) |   19.14 (1.68) |   17.98 (1.71) |   16.77 (1.20) |    17.85 (1.79)
      Mean vs (SD)   |    0.91 (0.30) |    0.57 (0.53) |    0.00 (0.00) |     0.44 (0.50)
      Mean am (SD)   |    0.73 (0.47) |    0.43 (0.53) |    0.14 (0.36) |     0.41 (0.50)
      Mean gear (SD) |    4.09 (0.54) |    3.86 (0.69) |    3.29 (0.73) |     3.69 (0.74)
      Mean carb (SD) |    1.55 (0.52) |    3.43 (1.81) |    3.50 (1.56) |     2.81 (1.62)

---

    Code
      report_sample(iris, by = "Species")
    Output
      # Descriptive Statistics
      
      Variable               | setosa (n=50) | versicolor (n=50) | virginica (n=50) | Total (n=150)
      ---------------------------------------------------------------------------------------------
      Mean Sepal.Length (SD) |   5.01 (0.35) |       5.94 (0.52) |      6.59 (0.64) |   5.84 (0.83)
      Mean Sepal.Width (SD)  |   3.43 (0.38) |       2.77 (0.31) |      2.97 (0.32) |   3.06 (0.44)
      Mean Petal.Length (SD) |   1.46 (0.17) |       4.26 (0.47) |      5.55 (0.55) |   3.76 (1.77)
      Mean Petal.Width (SD)  |   0.25 (0.11) |       1.33 (0.20) |      2.03 (0.27) |   1.20 (0.76)

# report_sample centrality

    Code
      report_sample(airquality, centrality = "mean")
    Output
      # Descriptive Statistics
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  42.13 (32.99)
      Mean Solar.R (SD) | 185.93 (90.06)
      Mean Wind (SD)    |    9.96 (3.52)
      Mean Temp (SD)    |   77.88 (9.47)
      Mean Month (SD)   |    6.99 (1.42)
      Mean Day (SD)     |   15.80 (8.86)

---

    Code
      report_sample(mtcars, centrality = "mean")
    Output
      # Descriptive Statistics
      
      Variable       |         Summary
      --------------------------------
      Mean mpg (SD)  |    20.09 (6.03)
      Mean cyl (SD)  |     6.19 (1.79)
      Mean disp (SD) | 230.72 (123.94)
      Mean hp (SD)   |  146.69 (68.56)
      Mean drat (SD) |     3.60 (0.53)
      Mean wt (SD)   |     3.22 (0.98)
      Mean qsec (SD) |    17.85 (1.79)
      Mean vs (SD)   |     0.44 (0.50)
      Mean am (SD)   |     0.41 (0.50)
      Mean gear (SD) |     3.69 (0.74)
      Mean carb (SD) |     2.81 (1.62)

---

    Code
      report_sample(iris, centrality = "mean")
    Output
      # Descriptive Statistics
      
      Variable                |     Summary
      -------------------------------------
      Mean Sepal.Length (SD)  | 5.84 (0.83)
      Mean Sepal.Width (SD)   | 3.06 (0.44)
      Mean Petal.Length (SD)  | 3.76 (1.77)
      Mean Petal.Width (SD)   | 1.20 (0.76)
      Species [setosa], %     |        33.3
      Species [versicolor], % |        33.3
      Species [virginica], %  |        33.3

---

    Code
      report_sample(airquality, centrality = "median")
    Output
      # Descriptive Statistics
      
      Variable             |        Summary
      -------------------------------------
      Median Ozone (MAD)   |  31.50 (25.95)
      Median Solar.R (MAD) | 205.00 (98.59)
      Median Wind (MAD)    |    9.70 (3.41)
      Median Temp (MAD)    |   79.00 (8.90)
      Median Month (MAD)   |    7.00 (1.48)
      Median Day (MAD)     |  16.00 (11.86)

---

    Code
      report_sample(mtcars, centrality = "median")
    Output
      # Descriptive Statistics
      
      Variable          |         Summary
      -----------------------------------
      Median mpg (MAD)  |    19.20 (5.41)
      Median cyl (MAD)  |     6.00 (2.97)
      Median disp (MAD) | 196.30 (140.48)
      Median hp (MAD)   |  123.00 (77.10)
      Median drat (MAD) |     3.70 (0.70)
      Median wt (MAD)   |     3.33 (0.77)
      Median qsec (MAD) |    17.71 (1.42)
      Median vs (MAD)   |     0.00 (0.00)
      Median am (MAD)   |     0.00 (0.00)
      Median gear (MAD) |     4.00 (1.48)
      Median carb (MAD) |     2.00 (1.48)

---

    Code
      report_sample(iris, centrality = "median")
    Output
      # Descriptive Statistics
      
      Variable                  |     Summary
      ---------------------------------------
      Median Sepal.Length (MAD) | 5.80 (1.04)
      Median Sepal.Width (MAD)  | 3.00 (0.44)
      Median Petal.Length (MAD) | 4.35 (1.85)
      Median Petal.Width (MAD)  | 1.30 (1.04)
      Species [setosa], %       |        33.3
      Species [versicolor], %   |        33.3
      Species [virginica], %    |        33.3

# report_sample select

    Code
      report_sample(airquality, select = "Temp")
    Output
      # Descriptive Statistics
      
      Variable       |      Summary
      -----------------------------
      Mean Temp (SD) | 77.88 (9.47)

---

    Code
      report_sample(mtcars, select = c("mpg", "disp"))
    Output
      # Descriptive Statistics
      
      Variable       |         Summary
      --------------------------------
      Mean mpg (SD)  |    20.09 (6.03)
      Mean disp (SD) | 230.72 (123.94)

---

    Code
      report_sample(iris, select = "Petal.Width")
    Output
      # Descriptive Statistics
      
      Variable              |     Summary
      -----------------------------------
      Mean Petal.Width (SD) | 1.20 (0.76)

# report_sample exclude

    Code
      report_sample(airquality, exclude = "Temp")
    Output
      # Descriptive Statistics
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  42.13 (32.99)
      Mean Solar.R (SD) | 185.93 (90.06)
      Mean Wind (SD)    |    9.96 (3.52)
      Mean Month (SD)   |    6.99 (1.42)
      Mean Day (SD)     |   15.80 (8.86)

---

    Code
      report_sample(mtcars, exclude = c("mpg", "disp"))
    Output
      # Descriptive Statistics
      
      Variable       |        Summary
      -------------------------------
      Mean cyl (SD)  |    6.19 (1.79)
      Mean hp (SD)   | 146.69 (68.56)
      Mean drat (SD) |    3.60 (0.53)
      Mean wt (SD)   |    3.22 (0.98)
      Mean qsec (SD) |   17.85 (1.79)
      Mean vs (SD)   |    0.44 (0.50)
      Mean am (SD)   |    0.41 (0.50)
      Mean gear (SD) |    3.69 (0.74)
      Mean carb (SD) |    2.81 (1.62)

---

    Code
      report_sample(iris, exclude = "Petal.Width")
    Output
      # Descriptive Statistics
      
      Variable                |     Summary
      -------------------------------------
      Mean Sepal.Length (SD)  | 5.84 (0.83)
      Mean Sepal.Width (SD)   | 3.06 (0.44)
      Mean Petal.Length (SD)  | 3.76 (1.77)
      Species [setosa], %     |        33.3
      Species [versicolor], % |        33.3
      Species [virginica], %  |        33.3

# report_sample total

    Code
      report_sample(airquality, total = TRUE)
    Output
      # Descriptive Statistics
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  42.13 (32.99)
      Mean Solar.R (SD) | 185.93 (90.06)
      Mean Wind (SD)    |    9.96 (3.52)
      Mean Temp (SD)    |   77.88 (9.47)
      Mean Month (SD)   |    6.99 (1.42)
      Mean Day (SD)     |   15.80 (8.86)

---

    Code
      report_sample(airquality, total = FALSE)
    Output
      # Descriptive Statistics
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  42.13 (32.99)
      Mean Solar.R (SD) | 185.93 (90.06)
      Mean Wind (SD)    |    9.96 (3.52)
      Mean Temp (SD)    |   77.88 (9.47)
      Mean Month (SD)   |    6.99 (1.42)
      Mean Day (SD)     |   15.80 (8.86)

---

    Code
      report_sample(airquality, by = "Month", total = TRUE)
    Output
      # Descriptive Statistics
      
      Variable          |        5 (n=31) |       6 (n=30) |       7 (n=31) |       8 (n=31) |       9 (n=30) |  Total (n=153)
      ------------------------------------------------------------------------------------------------------------------------
      Mean Ozone (SD)   |   23.62 (22.22) |  29.44 (18.21) |  59.12 (31.64) |  59.96 (39.68) |  31.45 (24.14) |  42.13 (32.99)
      Mean Solar.R (SD) | 181.30 (115.08) | 190.17 (92.88) | 216.48 (80.57) | 171.86 (76.83) | 167.43 (79.12) | 185.93 (90.06)
      Mean Wind (SD)    |    11.62 (3.53) |   10.27 (3.77) |    8.94 (3.04) |    8.79 (3.23) |   10.18 (3.46) |    9.96 (3.52)
      Mean Temp (SD)    |    65.55 (6.85) |   79.10 (6.60) |   83.90 (4.32) |   83.97 (6.59) |   76.90 (8.36) |   77.88 (9.47)
      Mean Day (SD)     |    16.00 (9.09) |   15.50 (8.80) |   16.00 (9.09) |   16.00 (9.09) |   15.50 (8.80) |   15.80 (8.86)

---

    Code
      report_sample(airquality, by = "Month", total = FALSE)
    Output
      # Descriptive Statistics
      
      Variable          |        5 (n=31) |       6 (n=30) |       7 (n=31) |       8 (n=31) | 9 (n=30) (n=153)
      ---------------------------------------------------------------------------------------------------------
      Mean Ozone (SD)   |   23.62 (22.22) |  29.44 (18.21) |  59.12 (31.64) |  59.96 (39.68) |    31.45 (24.14)
      Mean Solar.R (SD) | 181.30 (115.08) | 190.17 (92.88) | 216.48 (80.57) | 171.86 (76.83) |   167.43 (79.12)
      Mean Wind (SD)    |    11.62 (3.53) |   10.27 (3.77) |    8.94 (3.04) |    8.79 (3.23) |     10.18 (3.46)
      Mean Temp (SD)    |    65.55 (6.85) |   79.10 (6.60) |   83.90 (4.32) |   83.97 (6.59) |     76.90 (8.36)
      Mean Day (SD)     |    16.00 (9.09) |   15.50 (8.80) |   16.00 (9.09) |   16.00 (9.09) |     15.50 (8.80)

---

    Code
      report_sample(airquality, by = "Month", total = FALSE, n = TRUE)
    Output
      # Descriptive Statistics
      
      Variable             |            5 (n=31) |           6 (n=30) |           7 (n=31) |           8 (n=31) |   9 (n=30) (n=153)
      ------------------------------------------------------------------------------------------------------------------------------
      Mean Ozone (SD), n   |   23.62 (22.22), 26 |   29.44 (18.21), 9 |  59.12 (31.64), 26 |  59.96 (39.68), 26 |  31.45 (24.14), 29
      Mean Solar.R (SD), n | 181.30 (115.08), 27 | 190.17 (92.88), 30 | 216.48 (80.57), 31 | 171.86 (76.83), 28 | 167.43 (79.12), 30
      Mean Wind (SD), n    |    11.62 (3.53), 31 |   10.27 (3.77), 30 |    8.94 (3.04), 31 |    8.79 (3.23), 31 |   10.18 (3.46), 30
      Mean Temp (SD), n    |    65.55 (6.85), 31 |   79.10 (6.60), 30 |   83.90 (4.32), 31 |   83.97 (6.59), 31 |   76.90 (8.36), 30
      Mean Day (SD), n     |    16.00 (9.09), 31 |   15.50 (8.80), 30 |   16.00 (9.09), 31 |   16.00 (9.09), 31 |   15.50 (8.80), 30

---

    Code
      report_sample(airquality, by = "Month", total = TRUE, n = TRUE)
    Output
      # Descriptive Statistics
      
      Variable             |            5 (n=31) |           6 (n=30) |           7 (n=31) |           8 (n=31) |           9 (n=30) |       Total (n=153)
      ----------------------------------------------------------------------------------------------------------------------------------------------------
      Mean Ozone (SD), n   |   23.62 (22.22), 26 |   29.44 (18.21), 9 |  59.12 (31.64), 26 |  59.96 (39.68), 26 |  31.45 (24.14), 29 |  42.13 (32.99), 116
      Mean Solar.R (SD), n | 181.30 (115.08), 27 | 190.17 (92.88), 30 | 216.48 (80.57), 31 | 171.86 (76.83), 28 | 167.43 (79.12), 30 | 185.93 (90.06), 146
      Mean Wind (SD), n    |    11.62 (3.53), 31 |   10.27 (3.77), 30 |    8.94 (3.04), 31 |    8.79 (3.23), 31 |   10.18 (3.46), 30 |    9.96 (3.52), 153
      Mean Temp (SD), n    |    65.55 (6.85), 31 |   79.10 (6.60), 30 |   83.90 (4.32), 31 |   83.97 (6.59), 31 |   76.90 (8.36), 30 |   77.88 (9.47), 153
      Mean Day (SD), n     |    16.00 (9.09), 31 |   15.50 (8.80), 30 |   16.00 (9.09), 31 |   16.00 (9.09), 31 |   15.50 (8.80), 30 |   15.80 (8.86), 153

# report_sample digits

    Code
      report_sample(airquality, digits = 5)
    Output
      # Descriptive Statistics
      
      Variable          |              Summary
      ----------------------------------------
      Mean Ozone (SD)   |  42.12931 (32.98788)
      Mean Solar.R (SD) | 185.93151 (90.05842)
      Mean Wind (SD)    |    9.95752 (3.52300)
      Mean Temp (SD)    |   77.88235 (9.46527)
      Mean Month (SD)   |    6.99346 (1.41652)
      Mean Day (SD)     |   15.80392 (8.86452)

---

    Code
      report_sample(mtcars, digits = 5)
    Output
      # Descriptive Statistics
      
      Variable       |               Summary
      --------------------------------------
      Mean mpg (SD)  |    20.09062 (6.02695)
      Mean cyl (SD)  |     6.18750 (1.78592)
      Mean disp (SD) | 230.72188 (123.93869)
      Mean hp (SD)   |  146.68750 (68.56287)
      Mean drat (SD) |     3.59656 (0.53468)
      Mean wt (SD)   |     3.21725 (0.97846)
      Mean qsec (SD) |    17.84875 (1.78694)
      Mean vs (SD)   |     0.43750 (0.50402)
      Mean am (SD)   |     0.40625 (0.49899)
      Mean gear (SD) |     3.68750 (0.73780)
      Mean carb (SD) |     2.81250 (1.61520)

---

    Code
      report_sample(iris, digits = 5)
    Output
      # Descriptive Statistics
      
      Variable                |           Summary
      -------------------------------------------
      Mean Sepal.Length (SD)  | 5.84333 (0.82807)
      Mean Sepal.Width (SD)   | 3.05733 (0.43587)
      Mean Petal.Length (SD)  | 3.75800 (1.76530)
      Mean Petal.Width (SD)   | 1.19933 (0.76224)
      Species [setosa], %     |              33.3
      Species [versicolor], % |              33.3
      Species [virginica], %  |              33.3

# report_sample weights

    Code
      report_sample(airquality, weights = "Temp")
    Output
      # Descriptive Statistics (weighted)
      
      Variable          |        Summary
      ----------------------------------
      Mean Ozone (SD)   |  44.91 (33.54)
      Mean Solar.R (SD) | 188.84 (87.33)
      Mean Wind (SD)    |    9.76 (3.48)
      Mean Month (SD)   |    7.07 (1.37)
      Mean Day (SD)     |   15.66 (8.93)

---

    Code
      report_sample(mtcars, weights = "carb")
    Output
      # Descriptive Statistics (weighted)
      
      Variable       |         Summary
      --------------------------------
      Mean mpg (SD)  |    18.24 (5.17)
      Mean cyl (SD)  |     6.71 (1.57)
      Mean disp (SD) | 257.96 (120.25)
      Mean hp (SD)   |  175.29 (75.91)
      Mean drat (SD) |     3.57 (0.48)
      Mean wt (SD)   |     3.45 (0.95)
      Mean qsec (SD) |    17.20 (1.76)
      Mean vs (SD)   |     0.28 (0.45)
      Mean am (SD)   |     0.42 (0.50)
      Mean gear (SD) |     3.80 (0.81)

---

    Code
      report_sample(iris, weights = "Petal.Width")
    Output
      # Descriptive Statistics (weighted)
      
      Variable                |     Summary
      -------------------------------------
      Mean Sepal.Length (SD)  | 6.27 (0.72)
      Mean Sepal.Width (SD)   | 2.96 (0.36)
      Mean Petal.Length (SD)  | 4.83 (1.19)
      Species [setosa], %     |         6.8
      Species [versicolor], % |        36.9
      Species [virginica], %  |        56.3

# report_sample, with more than one grouping variable

    Code
      out
    Output
      # Descriptive Statistics
      
      Variable               | setosa, a (n=16) | versicolor, a (n=17) | virginica, a (n=9) | setosa, b (n=15) | versicolor, b (n=17) | virginica, b (n=22) | setosa, c (n=19) | versicolor, c (n=16) | virginica, c (n=19) | Total (n=150)
      -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Mean Sepal.Length (SD) |      5.13 (0.36) |          6.08 (0.48) |        6.59 (0.44) |      4.91 (0.31) |          5.84 (0.54) |         6.77 (0.63) |      4.97 (0.36) |          5.88 (0.53) |         6.38 (0.69) |   5.84 (0.83)
      Mean Sepal.Width (SD)  |      3.50 (0.42) |          2.76 (0.40) |        3.02 (0.25) |      3.34 (0.25) |          2.81 (0.25) |         3.05 (0.36) |      3.44 (0.43) |          2.74 (0.29) |         2.87 (0.30) |   3.06 (0.44)

# report_sample, print vertical

    Code
      print(out, layout = "vertical")
    Output
      # Descriptive Statistics
      
      Groups               | Mean Sepal.Length (SD) | Mean Sepal.Width (SD) | Mean Petal.Length (SD)
      ----------------------------------------------------------------------------------------------
      setosa, a (n=16)     |            5.13 (0.36) |           3.50 (0.42) |            1.50 (0.12)
      versicolor, a (n=17) |            6.08 (0.48) |           2.76 (0.40) |            4.37 (0.44)
      virginica, a (n=9)   |            6.59 (0.44) |           3.02 (0.25) |            5.57 (0.52)
      setosa, b (n=15)     |            4.91 (0.31) |           3.34 (0.25) |            1.47 (0.17)
      versicolor, b (n=17) |            5.84 (0.54) |           2.81 (0.25) |            4.25 (0.44)
      virginica, b (n=22)  |            6.77 (0.63) |           3.05 (0.36) |            5.73 (0.57)
      setosa, c (n=19)     |            4.97 (0.36) |           3.44 (0.43) |            1.43 (0.21)
      versicolor, c (n=16) |            5.88 (0.53) |           2.74 (0.29) |            4.16 (0.53)
      virginica, c (n=19)  |            6.38 (0.69) |           2.87 (0.30) |            5.34 (0.49)
      Total (n=150)        |            5.84 (0.83) |           3.06 (0.44) |            3.76 (1.77)

