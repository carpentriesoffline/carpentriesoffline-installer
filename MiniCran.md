# Installing miniCRAN

[miniCRAN website](https://github.com/andrie/miniCRAN)

- Open a Python terminal
'''python
install.packages("miniCRAN")
library("miniCRAN")
library(devtools)
install_github("andrie/miniCRAN")

# Download packages

pkgs <- c("tidyverse")
makeRepo(pkgDep(pkgs), path=file.path(tempdir(), "miniCRAN"))
```



