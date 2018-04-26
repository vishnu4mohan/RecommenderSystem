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
		get_free_ram <- function(){
		system <- Sys.info()[["sysname"]]
		if(system == "Windows"){
			x <- system2("wmic", args =  "OS get FreePhysicalMemory /Value", stdout = TRUE)
			x <- x[grepl("FreePhysicalMemory", x)]
			x <- gsub("FreePhysicalMemory=", "", x, fixed = TRUE)
			x <- gsub("\r", "", x, fixed = TRUE)
			as.integer(x)
		} else if (system == "Linux"){
			x <- system('grep MemFree /proc/meminfo', intern = TRUE)
			x <- gsub("MemFree:        ", "",x, fixed = TRUE)
			x <- gsub(" kB", "", x, fixed = TRUE)
			as.integer(x)
		}  
		else {
				stop("Only supported on Windows and Linux OS")
			}
		}
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
