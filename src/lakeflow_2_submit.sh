#!/bin/bash

###########################################################################
## environment & variable setup
####### job customization
#SBATCH --job-name lkflw
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=10GB
#SBATCH --time 12:00:00
#SBATCH -p normal_q
#SBATCH -A swot
#SBATCH --array=1-30
####### end of job customization
# end of environment & variable setup

module load containers/apptainer
apptainer exec \
    --pwd /projects/swot/hana/LakeFlow_Confluence \
    --bind /projects/swot/hana/LakeFlow_Confluence \
    --cleanenv \
    /projects/swot/hana/LakeFlow_Confluence/lakeflow.sif Rscript src/lakeflow_2.R "in/viable/lakeflow${SLURM_ARRAY_TASK_ID}.csv" 6