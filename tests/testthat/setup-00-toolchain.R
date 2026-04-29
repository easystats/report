# Neutralize any C/C++ flags leaking into test compiles
Sys.setenv(
  R_MAKEVARS_USER = "",
  R_MAKEVARS_SITE = "",
  R_MAKEVARS = ""
)

# Unset env vars that force Stan/RcppEigen includes into ALL compilations
vars <- c(
  "PKG_CPPFLAGS",
  "CPPFLAGS",
  "CFLAGS",
  "CXXFLAGS",
  "CXX11FLAGS",
  "CXX14FLAGS",
  "CXX17FLAGS",
  "CPLUS_INCLUDE_PATH",
  "INCLUDE"
)
Sys.unsetenv(vars)

# (Optional) double-check during tests
# message("FLAGS after cleanup:\n",
#         paste(sprintf("%s='%s'", vars, Sys.getenv(vars)), collapse="\n"))
