#!/bin/bash
# Generating phylogenetic tree
# Kerry Hathway June2025

# PBS directives
#---------------

#PBS -N phylogenetic_tree
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

module load CONDA/qiime2-amplicon-2024.5

# Start message
echo "QIIME2: Generate phylogenetic tree"
date
echo ""

# Folders
base_folder="/mnt/beegfs/home/kerry.hathway/thesis"
results_folder="${base_folder}/results"
output_dir="${results_folder}/phylo_tree"

mkdir -p "${output_dir}"

# Phylogenetic tree using the rep sequences table
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences "${results_folder}/process_16S/s04_rep_seqs.qza" \
  --p-n-threads 12 \
  --o-alignment "${output_dir}/b06_aligned_rep_seqs.qza" \
  --o-masked-alignment "${output_dir}/b06_masked_aligned_rep_seqs.qza" \
  --o-tree "${output_dir}/b06_unrooted_tree.qza" \
  --o-rooted-tree "${output_dir}/b06_rooted_tree.qza"

# --- Export tree data for plotting outside QIIME2 --- #
# Tree files can be used to plot trees in several online tree viewers.
# For example, tree.nwk file can be viewed using NCBI tree viewer
# https://www.ncbi.nlm.nih.gov/tools/treeviewer/

# Export tree as tree.nwk
qiime tools export \
  --input-path "${output_dir}/b06_rooted_tree.qza" \
  --output-path "${output_dir}/b06_phylogenetic_tree"

# Export masked alignment as aligned-dna-sequences.fasta which can be used by other viewers
qiime tools export \
  --input-path "${output_dir}/b06_masked_aligned_rep_seqs.qza" \
  --output-path "${output_dir}/b06_phylogenetic_tree"
  
# Completion message
echo ""
echo "Done"
date

## Tidy up the log directory
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
