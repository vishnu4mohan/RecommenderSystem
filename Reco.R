rm(list = ls(all = TRUE))
options(scipen = 999)
pkgLoad <- function(package) {
    if (!require(package, character.only = TRUE)) {
        install.packages(package, dep=TRUE, repos = "http://cran.csie.ntu.edu.tw/")
        if(!require(package, character.only = TRUE)) stop("Package not found")
    }
    suppressMessages(library(package, character.only=TRUE))
}
pkgLoad("dplyr")
pkgLoad("data.table")
pkgLoad("xlsx")
pkgLoad("h2o")
pkgLoad("caret")
pkgLoad("properties")
#props<-read.properties("reco.property")
#setwd(props$work_dir)
if(!"h2o" %in% installed.packages()){
	stop("Please install h2o package to continue.")
}
else{
	try(h2o.init(nthreads=-1, max_mem_size = paste(ceiling(get_free_ram()/1024^2),"g", sep = "")), silent = TRUE)
	if(h2o.clusterIsUp()){
		cluster_status <- h2o.clusterStatus()
		print(paste("H2O Cluster Total Memory", as.numeric(cluster_status$free_mem), sep = "-"))
		print(paste("Number of CPUs in Use", as.numeric(cluster_status$num_cpus), sep = "-"))
	}
	else{
		stop("Couldn't Connect to H2O Cluster.")
	}
}
