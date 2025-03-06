# Use the Rocker image with system dependencies preinstalled
FROM rocker/r-ver:latest AS builder

# Set timezone and update system packages
RUN echo "America/New_York" | tee /etc/timezone \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
       software-properties-common dirmngr gpg gpg-agent \
       libudunits2-dev libgdal-dev libgeos-dev libproj-dev \
       libssl-dev libxml2-dev libcurl4-openssl-dev libgit2-dev \
       wget curl \
    && rm -rf /var/lib/apt/lists/*

# Add R2U repository (provides precompiled binary R packages)
RUN wget -q -O- "https://eddelbuettel.github.io/r2u/bootstrap.deb" | tee /etc/apt/sources.list.d/r2u.list \
    && apt-get update

# Install R packages using r2u (binary installs)
RUN apt-get install -y r-cran-rstan r-cran-rstanarm r-cran-lubridate \
    r-cran-data.table r-cran-dplyr r-cran-sf r-cran-raster \
    r-cran-rstudioapi r-cran-jsonlite r-cran-httr r-cran-bbmisc \
    r-cran-reticulate r-cran-future r-cran-future.apply \
    r-cran-foreign r-cran-devtools

# Verify RStan installation (should be binary)
RUN /usr/bin/Rscript -e "rstan::stan_version()"

# Install geoBAMr from GitHub
RUN /usr/bin/Rscript -e "devtools::install_github('craigbrinkerhoff/geoBAMr', upgrade='always', force=TRUE)"

# Copy application files
COPY . /app/

# Set entry point to run the R script
ENTRYPOINT [ "/usr/bin/Rscript", "/app/src/lakeflow_local_flexible.R" ]
