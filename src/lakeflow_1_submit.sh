#!/bin/bash

###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name dwnld
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5GB
#SBATCH --time 3:00:00
#SBATCH -p normal_q
#SBATCH -A swot
#SBATCH --array=1-50
####### end of job customization
# end of environment & variable setup

module load containers/apptainer
apptainer exec \
    --pwd /projects/swot/hana/LakeFlow_Confluence \
    --bind /projects/swot/hana/LakeFlow_Confluence \
    --cleanenv \
    /projects/swot/hana/LakeFlow_Confluence/lakeflow.sif Rscript src/lakeflow_1.R "in/lakeids/lakeid${SLURM_ARRAY_TASK_ID}.csv" 1