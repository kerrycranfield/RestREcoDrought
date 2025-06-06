# QIIME2 - Classify and collapse
# Kerry Hathway, June2025
# Requires environment with QIIME2
# To be used with s05_taxa_wrapper.sh

#Load modules
module load CONDA/qiime2-amplicon-2024.5

# Start message
echo "QIIME2: Run pre-trained classifier and agglomerate feature table to desired level"
date
echo ""

# Folders
classifier=$1
rep_seqs=$2
output_dir=$3
feature_table=$4
taxa_level=$5

mkdir -p "${output_dir}"

# Assign taxonomy to sequences
qiime feature-classifier classify-sklearn \
  --i-classifier "${classifier}" \
  --i-reads "${rep_seqs}" \
  --o-classification "${output_dir}/s05_taxonomy.qza"
  
# Generate visualisation of taxonomy
qiime metadata tabulate \
  --m-input-file "${output_dir}/s05_taxonomy.qza" \
  --o-visualization "${output_dir}/s05_taxonomy.qzv"

# Agglomerate feature table to desired level
qiime taxa collapse \
  --i-table "${feature_table}" \
  --i-taxonomy "${output_dir}/s05_taxonomy.qza" \
  --p-level ${taxa_level} \
  --o-collapsed-table "${output_dir}/s05_table_collapsed_${taxa_level}.qza"

# Summarise agglomerated feature table  
qiime feature-table summarize \
  --i-table "${output_dir}/s05_table_collapsed_${taxa_level}.qza" \
  --o-visualization "${output_dir}/s05_table_collapsed_${taxa_level}.qzv"

# Completion message
echo ""
echo "Done"
date

