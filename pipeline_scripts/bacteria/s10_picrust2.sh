#!/bin/bash
# Minimal set of Crescent2 batch submission instructions 
# Kerry Hathway July2025
# PICRUSt2

# PBS directives
#---------------

#PBS -N picrust
#PBS -l nodes=1:ncpus=12
#PBS -l walltime=12:00:00
#PBS -q half_day
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
echo "QIIME2: picrust2"
date
echo ""

# Set folders

base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
results_folder="${base_folder}/results"
data_folder="${base_folder}/data/16S"
picrust2_folder="${results_folder}/picrust2"

biom convert \
-i "${data_folder}/feature_table_nonagg.tsv" \
-o "${data_folder}/feature_table_nonagg.biom" \
--table-type="OTU table" \
--to-hdf5

qiime tools import \
--input-path "${data_folder}/feature_table_nonagg.biom" \
--output-path "${data_folder}/feature_table_nonagg.qza" \
--input-format BIOMV210Format \
--type "FeatureTable[Frequency]"

qiime picrust2 full-pipeline \
  --i-table "${data_folder}/feature_table_nonagg.qza" \
  --i-seq "${results_folder}/process_16S/s04_rep_seqs.qza" \
  --p-threads 12 \
  --o-ko-metagenome "${picrust2_folder}/ko_metagenome_nonagg.qza" \
  --o-ec-metagenome "${picrust2_folder}/ec_metagenome_nonagg.qza" \
  --o-pathway-abundance "${picrust2_folder}/pathway_abundance_nonagg.qza" \
  --verbose

echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
