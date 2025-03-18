#!/bin/bash

###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name lake1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=2GB
#SBATCH --time 0:30:00
#SBATCH -p normal_q
#SBATCH -A swot
####### end of job customization
# end of environment & variable setup

module load containers/apptainer

apptainer exec \
    --pwd /projects/swot/kmcquil/LakeFlow_Confluence \
    --bind /projects/swot/kmcquil/LakeFlow_Confluence \
    --cleanenv \
    /projects/swot/kmcquil/LakeFlow_Confluence/docker/lakeflow.sif Rscript src/lakeflow_1.R 5