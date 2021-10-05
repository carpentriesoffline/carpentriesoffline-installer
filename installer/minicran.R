# install minicran
install.packages("miniCRAN")

# load minicran library
library("miniCRAN")

# Download packages
pkgs <- c("tidyverse")
makeRepo(pkgDep(pkgs), path="/var/www/html/MiniCRAN/")
