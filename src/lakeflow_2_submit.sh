#!/bin/bash

###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name lkflw
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=5GB
#SBATCH --time 3:00:00
#SBATCH -p normal_q
#SBATCH -A swot
#SBATCH --array=1-2
####### end of job customization
# end of environment & variable setup

module load containers/apptainer
apptainer exec \
    --pwd /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --bind /projects/swot/kmcquil/LakeFlow_Confluence_Dev \
    --cleanenv \
    /projects/swot/kmcquil/LakeFlow_Confluence_Dev/docker/lakeflow.sif Rscript src/lakeflow_2.R "in/viable/lakeflow${SLURM_ARRAY_TASK_ID}.csv" 6