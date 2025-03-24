# Notes to containerize and run lakeflow

### General notes
- 574-576: The sword_geoglows DT 'reach_id' column is integers but the sword_ids are strings. Convert the column to strings. 
- split lakeflow into two scripts. One script is to download the data and the other is to run lakeflow


### Docker commands
- docker build -t lakeflow .
- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/docker_test.R
- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/lakeflow_local_flexible.R
- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/lakeflow_1.R "in/lakeids/lakeid1.csv" 1
- docker run --mount type=bind,source=C:/Users/kmcquil/Documents/LakeFlow_Confluence_Dev,target=/app lakeflow Rscript src/lakeflow_2.R "in/viable/viable_locations1.csv" 6


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


### Steps to run from start to finish 
1. Run lake_ids.R to create N csv files with lists of lake ids to attempt to download data 
2. Run lakeflow_1.R to download the data. This is parallelized with job array so that each of the N lists of lake ids is downloaded simultaneously. This script saves the data and also csvs of lake ids that are viable to run lakeflow. 
3. Run a script to combine all csvs with lists of viable lakes into one and then break into N new csvs of equal size. 
4. Run lakeflow_2.R to run lakeflow at each lake. This is parallelized with job array so that each of the N lists of lake ids is processed simultaneously. This script saves lakeflow outputs. 