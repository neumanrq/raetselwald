install.packages("shiny", version = "1.0.5", dependencies = TRUE)
additional_packages = c("magrittr")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}
invisible(sapply(additional_packages, install_if_missing))
