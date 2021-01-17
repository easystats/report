if (requireNamespace("spelling", quietly = TRUE)) {

  # Fails for now  (see https://github.com/ropensci/spelling/issues/58)

  # spelling::spell_check_test(
  #   vignettes = TRUE,
  #   error = FALSE,
  #   skip_on_cran = TRUE
  # )


  # files <- list.files("./", recursive = TRUE)
  # files <- files[files != "README.md"]
  #
  # for(i in files){
  #   if(stringr::str_detect(i, ".png|.jpg|.svg|.ai")) {
  #     next
  #   }
  #   # print(i)
  #   spelling::spell_check_files(i)
  # }

}
