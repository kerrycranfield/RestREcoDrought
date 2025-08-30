# QIIME2 - filter_ITS_table
# Kerry Hathway, June2025
# Requires environment with QIIME2 

# PBS directives
#---------------

#PBS -N filter_ITS_table
#PBS -l nodes=1:ncpus=12
#PBS -l walltime=00:30:00
#PBS -q half_hour
#PBS -m abe
#PBS -M kerry.hathway@cranfield.ac.uk

#===============
#PBS -j oe
#PBS -v "CUDA_VISIBLE_DEVICES="
#PBS -W sandbox=PRIVATE
#PBS -k n
ln -s $PWD $PBS_O_WORKDIR/$PBS_JOBID
## Change to working directory
cd $PBS_O_WORKDIR
## Calculate number of CPUs and GPUs
export cpus=`cat $PBS_NODEFILE | wc -l`
## Load production modules
module use /apps2/modules/all
## =============

# Stop at runtime errors
set -e

module load CONDA/qiime2-amplicon-2024.5

# Start message
echo "QIIME2: remove samples from ITS feature table that do not appear in metadata"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
data_folder="${base_folder}/data/ITS/"
results_folder_1="${base_folder}/results/process_ITS"
results_folder_2="${base_folder}/results/taxonomy_ITS_dyn_funonly"

# Remove Harley Farm and other missing samples (F2C1, F2C2, F20S2, F20S3, F54S3)
# Samples do not have metadata attached or with missing data
# Number of threads set to 12 to speed up process.
qiime feature-table filter-samples \
  --i-table "${results_folder_1}/s04_table.qza" \
  --m-metadata-file "${data_folder}/metadata.txt" \
  --o-filtered-table "${results_folder_1}/f06_table.qza"


# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
