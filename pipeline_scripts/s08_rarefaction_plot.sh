# QIIME2 - Rarefaction plot
# Kerry Hathway June2025
# Requires environment with QIIME2
# Produces rarefaction plot for downstream analysis 

# Crescent2 script
# Note: this script should be run on a compute node
# qsub script.sh

# PBS directives
#---------------

#PBS -N s08_rarefaction_plot
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
echo "QIIME2: Rarefaction plots for 16S and ITS"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
results_folder="${base_folder}/results"
data_folder="${base_folder}/data"
rare_bac="${results_folder}/rarefaction_16S"
rare_fun="${results_folder}/rarefaction_ITS"

mkdir -p "${rare_bac}"
mkdir -p "${rare_fun}"

# Alpha rarefaction
# Max-depth based on max non-chimeric reads in dada2 denoising stats table or maximum reads value in feature table
# As feature table has been agglomerated and aggregated, max-depth will be based in max genera frequency

# Rarefaction for 16S - tree available
qiime diversity alpha-rarefaction \
  --i-table "${results_folder}/taxonomy_16S/s07_grouped_table.qza" \
  --p-max-depth 28036 \
  --m-metadata-file "${data_folder}/16S/collapsed_metadata.txt" \
  --o-visualization "${rare_bac}/b07_rarefaction.qzv"

# Rarefaction for ITS from UNITE 99 database - no tree
qiime diversity alpha-rarefaction \
  --i-table "${results_folder}/taxonomy_ITS_99_funonly/s07_grouped_table.qza" \
  --p-max-depth 56936 \
  --m-metadata-file "${data_folder}/ITS/collapsed_metadata.txt" \
  --o-visualization "${rare_fun}/f07_rarefaction_99.qzv"

# Rarefaction for ITS from UNITE dynamic database - no tree
qiime diversity alpha-rarefaction \
  --i-table "${results_folder}/taxonomy_ITS_dyn_funonly/s07_grouped_table.qza" \
  --p-max-depth 56936 \
  --m-metadata-file "${data_folder}/ITS/collapsed_metadata.txt" \
  --o-visualization "${rare_fun}/f07_rarefaction_dyn.qzv"

# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
