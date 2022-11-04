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

