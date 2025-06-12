#!/bin/bash
# QIIME2 - Group and visualise feature table
# Kerry Hathway June2025
# Requires environment with QIIME2 - module loaded in s07_group_table.sh
# Groups feature table to site/treatment level and generates visualisations
# Assumes metadata has been collapsed to site/treatment level for visualisation step
# Use with s07_group_table.sh

# PBS directives
#---------------

#PBS -N group_features
#PBS -l nodes=1:ncpus=12
#PBS -l walltime=01:00:00
#PBS -q one_hour
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

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
results_folder="${base_folder}/results"
data_folder="${base_folder}/data"

./s07_group_table.sh "${results_folder}/taxonomy_16S/s05_table_collapsed_6.qza" \
"${data_folder}/16S/metadata.txt" \
Group_by \
"${results_folder}/taxonomy_16S" \
"${data_folder}/16S/collapsed_metadata.txt"

./s07_group_table.sh "${results_folder}/taxonomy_ITS_99_funonly/f06_table_6.qza" \
"${data_folder}/ITS/metadata.txt" \
Group_by \
"${results_folder}/taxonomy_ITS_99_funonly" \
"${data_folder}/ITS/collapsed_metadata.txt"

./s07_group_table.sh "${results_folder}/taxonomy_ITS_dyn_funonly/f06_table_6.qza" \
"${data_folder}/ITS/metadata.txt" \
Group_by \
"${results_folder}/taxonomy_ITS_dyn_funonly" \
"${data_folder}/ITS/collapsed_metadata.txt"


# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
