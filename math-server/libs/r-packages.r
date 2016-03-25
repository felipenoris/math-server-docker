
pkgs <- c(
	"cubature",
	"DEoptim",
	"data.table",
	"DEoptim",
	"devtools",
	"doParallel",
	"foreach",
	"ggplot2",
	"gmp",
	"Hmisc",
	"lubridate",
	"microbenchmark",
	"NMOF",
	"pbivnorm",
	"Rcpp",
	"RCurl",
	"Rmpfr",
	"roxygen2",
	"RQuantLib",
	"RSQLite",
	"sqldf",
	"stringr",
	"plyr",
	"XML",
	"zoo"
	)

install.packages(pkgs)

# rjulia
devtools::install_github("armgong/rjulia", ref="master")
