### Notes to run LakeFlow locally 

Updates I made to lakeflow_local_flexible.R
- 574-576: The sword_geoglows DT 'reach_id' column is integers but the sword_ids are strings. Convert the column to strings. 


### Notes to set up the dockerfile 
- we need python and r 

- python: 
- install the packages in the scripts with the version that i know is working locally
- to find which version of python the r reticulate package is running use the following commands 
library(reticulate)
py_config()
- Find the path for the reticulate virtual env in the output from above and activate the venv and then start python. Get the version of each package.
cd   C:/Users/kmcquil/Documents/.virtualenvs/r-reticulate/Scripts/
activate 
python 
import pandas as pd
pd.__version__
- Use these versions to create the requirements.txt file

- r: 
- install the packages in the script with their version number
- to check their version number, load all packages into r and then run sessionInfo()


- That's a starting off point, change versions as needed while compiling the container for compatibility 

- Create a docker_test.R script to open those libraries, open a csv, write a csv, and run python through R and download some data


/usr/lib/python3.10/config-3.10-x86_64-linux-gnu/libpython3.10.so


docker run lakeflow ls /usr/lib


remotes:: install_github("craigbrinkerhoff/geoBAMr", force=TRUE) 
library(geoBAMr)
remotes::install_version("foreign", version="0.8-82")
library(foreign)
remotes::install_version("lubridate", version="1.9.3")
library(lubridate)
remotes::install_version("rstan", version="2.32.6")
library(rstan)
remotes::install_version("data.table", version="1.14.8")
library(data.table)
remotes::install_version("dplyr", version="1.1.4")
library(dplyr)
remotes::install_version("sf", version="1.0-14")
library(sf)
remotes::install_version("raster", version="3.6-26")
library(raster)
remotes::install_version("rstudioapi", version="0.15.0")
library(rstudioapi)
remotes::install_version("jsonlite", version="1.8.9")
library(jsonlite)
remotes::install_version("httr", version="1.4.7")
library(httr)
remotes::install_version("BBmisc", version="1.13")
library(BBmisc)
remotes::install_version("future", version="1.34.0")
library(future)
remotes::install_version("future.apply", version="1.11.0")
library(future.apply)




# Load libraries
library(remotes)
library(reticulate)
use_virtualenv(virtualenv = "lakeflow_venv")
library(geoBAMr)
library(foreign)
library(lubridate)
library(rstan)
library(data.table)
library(dplyr)
library(sf)
library(raster)
library(rstudioapi)
library(jsonlite)
library(httr)
library(BBmisc)
library(future)
library(future.apply)

# Print the working directory
print(getwd())

print(py_config())

# Test reading a file from a folder that was bound to the container
df <- fread("in/test_in.csv")
print("successfully read in csv")

# Test writing out a file that was bound to the container
fwrite(df, "out/test_out.csv")
print("successfuly wrote to csv")

# Test using python through R with reticulate 
start_date = '01-01-2023'
reaches = list(110151544)
source_python('src/geoglows_aws_pull.py')
tributary_flow = pull_tributary(reach_id = reaches, start_date=start_date)
print(tributary_flow)

print("Success :)")



























# Start from an ubuntu R image version 4.4.1
FROM rocker/r-ver:4.4.1

# Update/install all necessary ubuntu stuff
RUN apt-get update && apt-get install -y --no-install-recommends build-essential libbz2-dev libffi-dev libgdal-dev gdal-bin libgeos-dev libproj-dev libmysqlclient-dev libudunits2-dev

# Install python 
RUN apt-get install -y --no-install-recommends python3.9 python3-pip python3-setuptools python3-dev python3-virtualenv 
RUN pip install --upgrade setuptools
RUN apt-get install -y git wget

# Set the working directory
WORKDIR /app

# Set up python 
#COPY requirements.txt .
#RUN pip install -r requirements.txt

# Copy R script with requirements to the container 
COPY requirements.R .
# Copy python script with requirements for the virtual env
COPY requirements.txt .
# Install R libraries and set up the python venv through reticulate so that it can find it easily
RUN Rscript requirements.R

# Activate the python virtual environment
RUN . /root/.virtualenvs/lakeflow_venv/bin/activate
RUN pip install upgrade zarr

RUN 

# Command to build the image
# docker build -t lakeflow . > build.log

# Command to run a container from the image, give an rscript as a command, and bind the folders 
# docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence,target=/app lakeflow Rscript src/docker_test.R

docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence,target=/app lakeflow Rscript src/lakeflow_local_flexible.R