.support_unicode <- l10n_info()$`UTF-8` |
  isTRUE(.Options$cli.unicode) |
  nzchar(Sys.getenv("RSTUDIO_USER_IDENTITY"))
