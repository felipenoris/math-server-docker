
pkgs <- c(
	"sqldf",
	"plyr",
	"gmp",
	"Rmpfr",
	"doParallel",
	"foreach",
	"DEoptim",
	"pbivnorm",
	"cubature",
	"ggplot2",
	"microbenchmark",
	"Rcpp",
	"RCurl",
	"roxygen2",
	"RQuantLib",
	"RSQLite",
	"devtools"
	)

install.packages(pkgs)

# rjulia
devtools::install_github("armgong/rjulia", ref="master")
