# report.factor

    Code
      r
    Output
      x: 3 levels, namely A (n = 10, 33.33%), B (n = 10, 33.33%) and C (n = 10,
      33.33%)

# report.data.frame

    Code
      r
    Output
      The data contains 150 observations, grouped by Species, of the following 5
      variables:
      
      - setosa (n = 50):
        - Sepal.Length: n = 50, Mean = 5.01, SD = 0.35, Median = 5.00, MAD = 0.30,
      range: [4.30, 5.80], Skewness = 0.12, Kurtosis = -0.25, 0 missing
        - Sepal.Width: n = 50, Mean = 3.43, SD = 0.38, Median = 3.40, MAD = 0.37,
      range: [2.30, 4.40], Skewness = 0.04, Kurtosis = 0.95, 0 missing
        - Petal.Length: n = 50, Mean = 1.46, SD = 0.17, Median = 1.50, MAD = 0.15,
      range: [1, 1.90], Skewness = 0.11, Kurtosis = 1.02, 0 missing
        - Petal.Width: n = 50, Mean = 0.25, SD = 0.11, Median = 0.20, MAD = 0.00,
      range: [0.10, 0.60], Skewness = 1.25, Kurtosis = 1.72, 0 missing
      
      - versicolor (n = 50):
        - Sepal.Length: n = 50, Mean = 5.94, SD = 0.52, Median = 5.90, MAD = 0.52,
      range: [4.90, 7], Skewness = 0.11, Kurtosis = -0.53, 0 missing
        - Sepal.Width: n = 50, Mean = 2.77, SD = 0.31, Median = 2.80, MAD = 0.30,
      range: [2, 3.40], Skewness = -0.36, Kurtosis = -0.37, 0 missing
        - Petal.Length: n = 50, Mean = 4.26, SD = 0.47, Median = 4.35, MAD = 0.52,
      range: [3, 5.10], Skewness = -0.61, Kurtosis = 0.05, 0 missing
        - Petal.Width: n = 50, Mean = 1.33, SD = 0.20, Median = 1.30, MAD = 0.22,
      range: [1, 1.80], Skewness = -0.03, Kurtosis = -0.41, 0 missing
      
      - virginica (n = 50):
        - Sepal.Length: n = 50, Mean = 6.59, SD = 0.64, Median = 6.50, MAD = 0.59,
      range: [4.90, 7.90], Skewness = 0.12, Kurtosis = 0.03, 0 missing
        - Sepal.Width: n = 50, Mean = 2.97, SD = 0.32, Median = 3.00, MAD = 0.30,
      range: [2.20, 3.80], Skewness = 0.37, Kurtosis = 0.71, 0 missing
        - Petal.Length: n = 50, Mean = 5.55, SD = 0.55, Median = 5.55, MAD = 0.67,
      range: [4.50, 6.90], Skewness = 0.55, Kurtosis = -0.15, 0 missing
        - Petal.Width: n = 50, Mean = 2.03, SD = 0.27, Median = 2.00, MAD = 0.30,
      range: [1.40, 2.50], Skewness = -0.13, Kurtosis = -0.60, 0 missing

# report.data.frame - with NAs

    Code
      report_grouped_df
    Output
      The data contains 32 observations, grouped by cyl, of the following 11
      variables:
      
      - 4 (n = 11):
        - mpg: n = 11, Mean = 26.66, SD = 4.51, Median = 26.00, MAD = 6.52, range:
      [21.40, 33.90], Skewness = 0.35, Kurtosis = -1.43, 0 missing
        - disp: n = 11, Mean = 105.14, SD = 26.87, Median = 108.00, MAD = 43.00, range:
      [71.10, 146.70], Skewness = 0.16, Kurtosis = -1.41, 0 missing
        - hp: n = 11, Mean = 82.64, SD = 20.93, Median = 91.00, MAD = 32.62, range:
      [52, 113], Skewness = 8.41e-03, Kurtosis = -1.56, 0 missing
        - drat: n = 11, Mean = 4.07, SD = 0.37, Median = 4.08, MAD = 0.34, range:
      [3.69, 4.93], Skewness = 1.34, Kurtosis = 2.13, 0 missing
        - wt: n = 11, Mean = 2.29, SD = 0.57, Median = 2.20, MAD = 0.54, range: [1.51,
      3.19], Skewness = 0.40, Kurtosis = -0.85, 0 missing
        - qsec: n = 11, Mean = 19.14, SD = 1.68, Median = 18.90, MAD = 1.48, range:
      [16.70, 22.90], Skewness = 0.74, Kurtosis = 1.84, 0 missing
        - vs: n = 11, Mean = 0.91, SD = 0.30, Median = 1.00, MAD = 0.00, range: [0, 1],
      Skewness = -3.32, Kurtosis = 11.00, 0 missing
        - am: n = 11, Mean = 0.73, SD = 0.47, Median = 1.00, MAD = 0.00, range: [0, 1],
      Skewness = -1.19, Kurtosis = -0.76, 0 missing
        - gear: n = 11, Mean = 4.09, SD = 0.54, Median = 4.00, MAD = 0.00, range: [3,
      5], Skewness = 0.15, Kurtosis = 1.86, 0 missing
        - carb: n = 11, Mean = 1.55, SD = 0.52, Median = 2.00, MAD = 0.00, range: [1,
      2], Skewness = -0.21, Kurtosis = -2.44, 0 missing
      
      - 6 (n = 6):
        - mpg: n = 6, Mean = 19.53, SD = 1.47, Median = 19.45, MAD = 2.15, range:
      [17.80, 21.40], Skewness = 0.14, Kurtosis = -1.77, 0 missing
        - disp: n = 6, Mean = 187.20, SD = 44.11, Median = 167.60, MAD = 22.39, range:
      [145, 258], Skewness = 1.04, Kurtosis = -0.49, 0 missing
        - hp: n = 6, Mean = 124.33, SD = 25.90, Median = 116.50, MAD = 9.64, range:
      [105, 175], Skewness = 2.02, Kurtosis = 4.34, 0 missing
        - drat: n = 6, Mean = 3.53, SD = 0.50, Median = 3.76, MAD = 0.24, range: [2.76,
      3.92], Skewness = -0.94, Kurtosis = -1.02, 0 missing
        - wt: n = 6, Mean = 3.20, SD = 0.31, Median = 3.33, MAD = 0.18, range: [2.77,
      3.46], Skewness = -0.71, Kurtosis = -1.84, 0 missing
        - qsec: n = 6, Mean = 18.23, SD = 1.72, Median = 18.60, MAD = 1.79, range:
      [15.50, 20.22], Skewness = -0.72, Kurtosis = -0.20, 0 missing
        - vs: n = 6, Mean = 0.67, SD = 0.52, Median = 1.00, MAD = 0.00, range: [0, 1],
      Skewness = -0.97, Kurtosis = -1.88, 0 missing
        - am: n = 6, Mean = 0.33, SD = 0.52, Median = 0.00, MAD = 0.00, range: [0, 1],
      Skewness = 0.97, Kurtosis = -1.87, 0 missing
        - gear: n = 6, Mean = 3.83, SD = 0.75, Median = 4.00, MAD = 0.74, range: [3,
      5], Skewness = 0.31, Kurtosis = -0.10, 0 missing
        - carb: n = 6, Mean = 3.33, SD = 1.97, Median = 4.00, MAD = 1.48, range: [1,
      6], Skewness = -0.22, Kurtosis = -1.08, 0 missing
      
      - 8 (n = 14):
        - mpg: n = 14, Mean = 15.10, SD = 2.56, Median = 15.20, MAD = 1.56, range:
      [10.40, 19.20], Skewness = -0.46, Kurtosis = 0.33, 0 missing
        - disp: n = 14, Mean = 353.10, SD = 67.77, Median = 350.50, MAD = 73.39, range:
      [275.80, 472], Skewness = 0.57, Kurtosis = -0.86, 0 missing
        - hp: n = 14, Mean = 209.21, SD = 50.98, Median = 192.50, MAD = 44.48, range:
      [150, 335], Skewness = 1.14, Kurtosis = 1.46, 0 missing
        - drat: n = 14, Mean = 3.23, SD = 0.37, Median = 3.12, MAD = 0.16, range:
      [2.76, 4.22], Skewness = 1.68, Kurtosis = 3.14, 0 missing
        - wt: n = 14, Mean = 4.00, SD = 0.76, Median = 3.75, MAD = 0.41, range: [3.17,
      5.42], Skewness = 1.24, Kurtosis = 0.08, 0 missing
        - qsec: n = 14, Mean = 16.77, SD = 1.20, Median = 17.18, MAD = 0.79, range:
      [14.50, 18], Skewness = -1.01, Kurtosis = -0.28, 0 missing
        - vs: n = 14, Mean = 0.00, SD = 0.00, Median = 0.00, MAD = 0.00, range: [0, 0],
      Skewness = , Kurtosis = , 0 missing
        - am: n = 14, Mean = 0.14, SD = 0.36, Median = 0.00, MAD = 0.00, range: [0, 1],
      Skewness = 2.29, Kurtosis = 3.79, 0 missing
        - gear: n = 14, Mean = 3.29, SD = 0.73, Median = 3.00, MAD = 0.00, range: [3,
      5], Skewness = 2.29, Kurtosis = 3.79, 0 missing
        - carb: n = 14, Mean = 3.50, SD = 1.56, Median = 3.50, MAD = 0.74, range: [2,
      8], Skewness = 1.86, Kurtosis = 5.14, 0 missing

# report.data.frame - with list columns

    Code
      report(dplyr::starwars)
    Output
      The data contains 87 observations of the following 11 variables:
      
        - name: 87 entries, such as Ackbar (n = 1); Adi Gallia (n = 1); Anakin
      Skywalker (n = 1) and 84 others (0 missing)
        - height: n = 87, Mean = 174.60, SD = 34.77, Median = , MAD = 17.79, range:
      [66, 264], Skewness = -1.09, Kurtosis = 2.13, 6 missing
        - mass: n = 87, Mean = 97.31, SD = 169.46, Median = , MAD = 16.31, range: [15,
      1358], Skewness = 7.34, Kurtosis = 55.42, 28 missing
        - hair_color: 11 entries, such as none (n = 38); brown (n = 18); black (n = 13)
      and 8 others (5 missing)
        - skin_color: 31 entries, such as fair (n = 17); light (n = 11); dark (n = 6)
      and 28 others (0 missing)
        - eye_color: 15 entries, such as brown (n = 21); blue (n = 19); yellow (n = 11)
      and 12 others (0 missing)
        - birth_year: n = 87, Mean = 87.57, SD = 154.69, Median = , MAD = 29.65, range:
      [8, 896], Skewness = 4.45, Kurtosis = 20.59, 44 missing
        - sex: 4 entries, such as male (n = 60); female (n = 16); none (n = 6) and 1
      other (4 missing)
        - gender: 2 entries, such as masculine (n = 66); feminine (n = 17); NA (4
      missing)
        - homeworld: 48 entries, such as Naboo (n = 11); Tatooine (n = 10); Alderaan (n
      = 3) and 45 others (10 missing)
        - species: 37 entries, such as Human (n = 35); Droid (n = 6); Gungan (n = 3)
      and 34 others (4 missing)

