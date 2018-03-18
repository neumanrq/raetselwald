if (!require("devtools"))
  install.packages("devtools")
devtools::install_github("shiny")

additional_packages = c("shiny", "magrittr")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p, dependencies = TRUE)
  }
  else {
    cat(paste("Skipping already installed package:", p, "\n"))
  }
}
invisible(sapply(additional_packages, install_if_missing))
