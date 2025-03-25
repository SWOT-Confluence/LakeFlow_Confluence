#!/bin/bash

###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name viable
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5GB
#SBATCH --time 0:10:00
#SBATCH -p normal_q
#SBATCH -A swot
####### end of job customization
# end of environment & variable setup

module load containers/apptainer
apptainer exec \
    --pwd /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --bind /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --cleanenv \
    /projects/swot/kmcquil/LakeFlow_Confluence_Dev/docker/lakeflow.sif Rscript src/viable_ids.R