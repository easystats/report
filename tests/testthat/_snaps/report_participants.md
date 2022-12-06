# report_participants

    Code
      report_participants(data, age = "Age", sex = "Sex", participant = "Participant")
    Output
      [1] "3 participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; Sex: 33.3% females, 33.3% males, 33.3% other; Gender: 33.3% women, 33.3% men, 33.33% non-binary)"

---

    Code
      report_participants(data, participant = "Participant", spell_n = TRUE)
    Output
      [1] "Three participants (Mean age = 28.0, SD = 23.6, range: [8, 54]; Sex: 33.3% females, 33.3% males, 33.3% other; Gender: 33.3% women, 33.3% men, 33.33% non-binary)"

---

    Code
      report_participants(data2)
    Output
      [1] "6 participants (Mean age = 28.0, SD = 21.1, range: [8, 54]; Sex: 50.0% females, 16.7% males, 33.3% other; Gender: 50.0% women, 16.7% men, 33.33% non-binary)"

---

    Code
      report_participants(data3)
    Output
      [1] "6 participants (Mean age = 52.0, SD = 42.4, range: [22, 82], 66.7% missing; Sex: 33.3% females, 0.0% males, 0.0% other, 66.67% missing; Gender: 33.3% women, 0.0% men, 0.00% non-binary, 66.67% missing)"

---

    Code
      report_participants(data4)
    Output
      [1] "7 participants (Mean education = 1.3, SD = 4.9, range: [-5, 8]; Country: 28.57% Canada, 28.57% USA, 14.29% Germany, 14.29% India, 14.29% missing; Race: 42.86% Black, 28.57% White, 14.29% Asian, 14.29% missing)"

---

    Code
      report_participants(data4, education = "Education2")
    Output
      [1] "7 participants (Education: Bachelor, 42.86%; Highschool, 28.57%; PhD, 14.29%; missing, 14.29%; Country: 28.57% Canada, 28.57% USA, 14.29% Germany, 14.29% India, 14.29% missing; Race: 42.86% Black, 28.57% White, 14.29% Asian, 14.29% missing)"

---

    Code
      report_participants(data4, threshold = 15)
    Output
      [1] "7 participants (Mean education = 1.3, SD = 4.9, range: [-5, 8]; Country: 28.57% Canada, 28.57% USA, 42.86% other; Race: 42.86% Black, 28.57% White, 28.57% other)"

# report_participants test NAs no warning

    Code
      report_participants(data)
    Output
      [1] "6 participants (Mean age = 28.3, SD = 16.6, range: [8, 54]; Sex: 16.7% females, 33.3% males, 16.7% other, 33.33% missing; Gender: 33.3% women, 16.7% men, 16.67% non-binary, 33.33% missing; Education: -5, 16.67%; -3, 16.67%; 0, 16.67%; 3, 16.67%; 5, 16.67%; 8, 16.67%; Country: 33.33% Canada, 16.67% Germany, 16.67% India, 16.67% USA, 16.67% missing; Race: 16.67% A, 16.67% B, 16.67% C, 16.67% D, 16.67% E, 16.67% missing)"

---

    Code
      report_participants(data, age = "Age", sex = "Sex")
    Output
      [1] "6 participants (8, n = 1; 21, n = 1; 22, n = 1; 23, n = 1; 42, n = 1; 54, n = 1; Sex: 16.7% females, 33.3% males, 16.7% other, 33.33% missing; Gender: 33.3% women, 16.7% men, 16.67% non-binary, 33.33% missing; Education: -5, 16.67%; -3, 16.67%; 0, 16.67%; 3, 16.67%; 5, 16.67%; 8, 16.67%; Country: 33.33% Canada, 16.67% Germany, 16.67% India, 16.67% USA, 16.67% missing; Race: 16.67% A, 16.67% B, 16.67% C, 16.67% D, 16.67% E, 16.67% missing)"

