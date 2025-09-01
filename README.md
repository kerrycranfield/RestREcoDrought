# Analysing microbial communities from the RestREco project

Repository for Cranfield University's MSc Applied Bioinformatics final thesis.

This project investigated the effects of short-term drought on microbial communities in UK grasslands by analysing 16S and ITS amplicon sequences. DNA was obtained from soil samples collected by the <a href="https://restreco.com/">RestREco</a> project.

The main aim of this study was to investigate how diversity, species composition and functional capacity in bacterial and fungal communities in grassland soils respond to changes in soil moisture

Objectives:
- Use bioinformatics tools to analyse amplicon sequencing data to investigate how drought affects diversity, taxonomical composition and functional composition in bacteria and fungi in restored grasslands
- To inform ecological restoration practices for building resilience to environmental change in grasslands
- To place the results in the context of current scientific literature and knowledge around the effects of soil moisture deficits on grassland ecosystem dynamics

This repository contains:
- Scripts from the 16S and ITS pipeline to process amplicon sequencing data as well as carry out functional predictions using PICRUSt2
- R markdown code used to continue the preprocessing started in the pipeline
- R markdown code for diversity, taxonomic composition and functional composition analysis

Diagrams of full workflows (left: 16S, right: ITS):
<br>
<br>
<img width="340" height="500" alt="16Sworkflowdrawio" src="https://github.com/user-attachments/assets/011aa5ba-1a2b-4f40-b283-7c35d3c3d556" />
<img width="340" height="500" alt="ITSworkflow" src="https://github.com/user-attachments/assets/ccfbaca0-7d05-416c-a920-6c6807ee2cac" />
<br>
<br>
Full results are available here: <a href="https://kerrycranfield.github.io/RestREcoDrought/restrecodrought.html">Processing to diversity</a>, <a href="https://kerrycranfield.github.io/RestREcoDrought/restreco_diff_abund.html">differential abundance</a> and <a href="https://kerrycranfield.github.io/RestREcoDrought/restreco_func.html">functional analysis</a>

## Scripts: 16S and ITS
1. <b>s01_sourcefilesgenerate.sh</b> - generate file containing paths to sequenced data
2. <b>s02_qc.sh</b> - Quality control. Performs quality assessment of reads using FastQC and MultiQC tools
3. <b>b03_q2_import_and_trim.sh</b> (16S) - Trimming adapters using CutAdapt (QIIME2) and further quality checks using demux summarize from QIIME2
   
   <b>f03_q2_import_and_display.sh</b> (ITS) - Perform quality checks using demux summarize from QIIME2 (no trimming required)
4. <p><b>b04_q2_denoise.sh</b> (16S) - Denoising. Merges paired reads, removes sequencing errors and chimeras and generates feature tables</p>
   <p><b>f04_q2_denoise.sh</b> (ITS) - As for 16S</p>
5. <b>s05_classify_aglom.sh</b> - Taxonomic assignment of sequences using GreenGenes2 for 16S and UNITE 99/dynamic for ITS. Also collapses feature table to desired taxonomic level, but outputs from collapse were not used for this project
6. <b>b06_phylo_tree.sh</b> (16S only) - Generates phylogenetic tree and aligns sequences using QIIME2's phylogeny align-to-tree-mafft-fasttree
7. <b>f06b_filter_table.sh</b> (ITS only) - Filter out samples from feature table that are not in the metadata eg. Harley Farms
8. <b>s10_picrust2.sh</b> (16S) - Functional predictions for bacteria feature table after converting feature table to biom format

## Wrapper scripts
These were to run multiple pipeline scripts at once (for example run 16S and ITS steps together) or for running custom Python scripts
<p><b>s01_02_wrapper.sh</b> - for use with s01_sourcefilesgenerate.sh and s02_qc.sh</p>
<p><b>s05_taxa_wrapper.sh</b> - for use with s05_classify_aglom.sh</p>
<p><b>s06_split_meta_wrapper.sh</b> - for use with Python scripts metadata_tool.py and metadata_collapse.py.</p>

## Python scripts
<b>metadata_tool.py</b> - edits metadata for use in QIIME2. Removed brackets, classified shelter and control samples and created new variable for grouping samples

<b>metadata_collapse.py</b> - aggregated metadata to site-treatment level

<b>funguild_process.py</b> - process melted phyloseq object so all levels of taxonomy classification are in one field for use with FUNGuildR 

For further preprocessing (aggregation, agglomeration, rarefaction), diversity, taxonomy and analysis of PICRUSt2 outputs/FUNGuildR see R markdown documents restrecodrought.Rmd, restreco_dif_abund.Rmd and restreco_func.Rmd in docs.
