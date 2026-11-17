# Install packages
install.packages("ncdf4")
install.packages("RNetCDF")
install.packages("remotes")
library(remotes)

# Pin the rstan toolchain to the versions confirmed working in the last
# successfully built image (ghcr.io/swot-confluence/lakeflow_input:latest,
# built ~5 months ago): rstan 2.32.7 / StanHeaders 2.32.10 / RcppParallel
# 5.1.11-2 / Rcpp 1.1.1-1.1, on Debian 13 (trixie) with g++ 14.2.0 and
# R 4.5.0 (same OS/toolchain this image now builds on). Current CRAN
# "latest" StanHeaders (2.39.1.1) reorganizes Stan Math header paths, and
# current RcppParallel (6.2.1) switched to oneTBB and dropped the legacy
# tbb/task_scheduler_init.h header that StanHeaders's threadpool code
# includes -- both break compiling rstan/geoBAMr. upgrade="never" stops
# remotes from silently bumping these while resolving dependencies.
remotes::install_version("Rcpp", version = "1.1.1-1.1", repos = "https://cloud.r-project.org", upgrade = "never")
remotes::install_version("RcppParallel", version = "5.1.11-2", repos = "https://cloud.r-project.org", upgrade = "never")
remotes::install_version("StanHeaders", version = "2.32.10", repos = "https://cloud.r-project.org", upgrade = "never")
remotes::install_version("rstan", version = "2.32.7", repos = "https://cloud.r-project.org", upgrade = "never")
library(rstan)

remotes:: install_github("craigbrinkerhoff/geoBAMr", force=TRUE)
library(geoBAMr)
install.packages("foreign")
library(foreign)
install.packages("lubridate")
library(lubridate)
install.packages("data.table")
library(data.table)
install.packages("dplyr")
library(dplyr)
install.packages("s2")
library(s2)
install.packages("sf")
library(sf)
install.packages("raster")
library(raster)
install.packages("rstudioapi")
library(rstudioapi)
install.packages("jsonlite")
library(jsonlite)
install.packages("httr")
library(httr)
install.packages("BBmisc")
library(BBmisc)
install.packages("future")
library(future)
install.packages("future.apply")
library(future.apply)
install.packages("reticulate")
library(reticulate)
install.packages('bit64')
library(bit64)
install.packages("optparse")
library(optparse)
install.packages("paws.developer.tools")
install.packages("paws")
library(paws)
install.packages("logger")
library(logger)


#version <- "3.9.13"
#install_python(version)
#virtualenv_create("lakeflow_venv", version = version, requirements = "requirements.txt")
#use_virtualenv("lakeflow_venv")

#print("all packages successfully installed :)")

# Set up the python virtual environment for reticulate
#reticulate::virtualenv_create(
#    envname="lakeflow_venv",
#    requirements="requirements.txt"
#)