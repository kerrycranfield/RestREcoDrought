# QIIME2 - Classify and collapse
# Kerry Hathway, June2025
# Requires environment with QIIME2

# PBS directives
#---------------

#PBS -N classify_and_collapse
#PBS -l nodes=1:ncpus=12
#PBS -l walltime=06:00:00
#PBS -q six_hour
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

base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
classifier_folder="${base_folder}/tools"
results_folder="${base_folder}/results"

# Classifies representative sequences table then uses output to collapse feature table to desired taxa level
# Parameter 1: location of the classifier (ie. GreenGenes2, UNITE, SILVA etc)
# Assumes classifier has already been downloaded and is available
# Parameter 2: location of sequences to be classified
# Parameter 3: Output directory - is created as part of script
# If running script multiple times, make sure this is different each time to avoid overwriting
# Parameter 4: location of feature table to be collapsed
# Parameter 5: taxa level user wants feature table to be collapsed to (if collapsing)
# Eg. 6=genus, 5=family, 4=order, 3=class etc.

# Greengenes2 v2024.09 classification of bacterial samples
./s05_classify_aglom.sh ${classifier_folder}/2024.09.backbone.full-length.nb.sklearn-1.4.2.qza \
${results_folder}/process_16S/s04_rep_seqs.qza \
${results_folder}/taxonomy_16S \
${results_folder}/process_16S/s04_table.qza 6

# UNITE V10 Just Fungi - 99% - classification of fungal samples
./s05_classify_aglom.sh ${classifier_folder}/unite_ver10_99_19.02.2025-Q2-2024.10.qza \
${results_folder}/process_ITS/s04_rep_seqs.qza \
${results_folder}/taxonomy_ITS_99_funonly \
${results_folder}/process_ITS/s04_table.qza 6

# UNITE V10 Just Fungi - dynamic- classification of fungal samples
./s05_classify_aglom.sh ${classifier_folder}/unite_ver10_dynamic_19.02.2025-Q2-2024.10.qza \
${results_folder}/process_ITS/s04_rep_seqs.qza \
${results_folder}/taxonomy_ITS_dyn_funonly \
${results_folder}/process_ITS/s04_table.qza 6

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
