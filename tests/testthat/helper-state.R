testthat::set_state_inspector(function() {
  skip()
  list(
    attached = search(),
    connections = nrow(showConnections()),
    cwd = getwd(),
    envvars = Sys.getenv(),
    libpaths = .libPaths(),
    locale = Sys.getlocale(),
    options = .Options,
    packages = .packages(all.available = TRUE),
    NULL
  )
})
