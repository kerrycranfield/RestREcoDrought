# QIIME2 - Apply rarefaction to feature tables
# Kerry Hathway, June2025
# Requires environment with QIIME2 

# Crescent2 script
# Note: this script should be run on a compute node
# qsub script.sh

# PBS directives
#---------------

#PBS -N s08b_apply_rarefaction
#PBS -l nodes=1:ncpus=12
#PBS -l walltime=03:00:00
#PBS -q three_hour
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
echo "QIIME2: apply rarefaction"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
results_folder="${base_folder}/results"

# Apply rarefaction
# Sampling depth based on min sequencing depth required to retain all samples in  feature table
# Download csv from qiime2view to get exact numeric rarefaction thresholds

# 16S rarefaction
#qiime feature-table rarefy \
#  --i-table "${results_folder}/taxonomy_16S/s07_grouped_table.qza" \
#  --p-sampling-depth 15576 \
#  --o-rarefied-table "${results_folder}/rarefaction_16S/b08b_rarefied_table.qza"

# ITS 99 rarefaction
#qiime feature-table rarefy \
#  --i-table "${results_folder}/taxonomy_ITS_99_funonly/s07_grouped_table.qza" \
#  --p-sampling-depth 31631 \
#  --o-rarefied-table "${results_folder}/rarefaction_ITS/f08b_rarefied_table_99.qza"

# ITS dynamic rarefaction
#qiime feature-table rarefy \
#  --i-table "${results_folder}/taxonomy_ITS_dyn_funonly/s07_grouped_table.qza" \
#  --p-sampling-depth 31631 \
#  --o-rarefied-table "${results_folder}/rarefaction_ITS/f08b_rarefied_table_dyn.qza"

# Summarise feature table
qiime feature-table summarize \
  --i-table "${results_folder}/rarefaction_16S/b08b_rarefied_table.qza" \
  --o-visualization "${results_folder}/rarefaction_16S/b08b_rarefied_table.qzv"

qiime feature-table summarize \
  --i-table "${results_folder}/rarefaction_ITS/f08b_rarefied_table_99.qza" \
  --o-visualization "${results_folder}/rarefaction_ITS/f08b_rarefied_table_99.qzv"

qiime feature-table summarize \
  --i-table "${results_folder}/rarefaction_ITS/f08b_rarefied_table_dyn.qza" \
  --o-visualization "${results_folder}/rarefaction_ITS/f08b_rarefied_table_dyn.qzv"


# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
