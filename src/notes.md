# Notes to containerize and run lakeflow

### General notes
- 574-576: The sword_geoglows DT 'reach_id' column is integers but the sword_ids are strings. Convert the column to strings. 
- split lakeflow into two scripts. One script is to download the data and the other is to run lakeflow


### Docker commands
- docker build -t lakeflow .
- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/docker_test.R
- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/lakeflow_local_flexible.R

- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/lakeflow_1.R 5

- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/lakeflow_2.R "in/viable_locations.csv" 6


### Steps to Convert the docker image to a singularity .sif
1. Push the image to docker hub through VS Code
2. On HPC, use these commands to convert to a .sif
module load containers/apptainer
apptainer build lakeflow.sif docker://kmcquil/lakeflow:latest

### Singularity commands 
- Here is the example command to run a .sif file 
apptainer exec \
    --pwd /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --bind /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --cleanenv \
    /projects/swot/kmcquil/LakeFlow_Confluence_Dev/docker/lakeflow.sif Rscript src/lakeflow_1.R "in/lake_ids.csv" 5

apptainer exec \
    --pwd /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --bind /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --cleanenv \
    /projects/swot/kmcquil/LakeFlow_Confluence_Dev/docker/lakeflow.sif Rscript src/lakeflow_2.R "in/viable_locations.csv" 6

--pwd sets the working directory if it is different from the directory where you launch the script 
--bind binds the outside directory with the inside directory. The format is [/source:/dest] but to bind to to the root then you can leave it blank 
--cleanenv is just good practice bc there can be so many wacky variables that we don't want to import into our container