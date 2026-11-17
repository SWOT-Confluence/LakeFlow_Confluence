# Install packages
install.packages("ncdf4")
install.packages("RNetCDF")
install.packages("remotes")
library(remotes)

# geoBAMr (last updated 2022) bundles a .stan file using old array syntax
# (e.g. `vector[] x`) in a function signature. Current CRAN rstan/StanHeaders
# use a stanc3 parser that treats this as a hard error instead of a
# deprecation warning, so geoBAMr's install-time model compilation fails
# against them. Pin to the last rstan/StanHeaders pair that still accepts
# the old syntax, and install before geoBAMr so its Stan model compiles.
# Current RcppParallel bundles oneTBB, which dropped the legacy
# tbb/task_scheduler_init.h header that StanHeaders 2.21.x's threadpool
# code includes. Pin RcppParallel to a pre-oneTBB release too.
remotes::install_version("RcppParallel", version = "5.1.4", repos = "https://cloud.r-project.org", upgrade = "never")
remotes::install_version("StanHeaders", version = "2.21.0-7", repos = "https://cloud.r-project.org", upgrade = "never")
remotes::install_version("rstan", version = "2.21.8", repos = "https://cloud.r-project.org", upgrade = "never")
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