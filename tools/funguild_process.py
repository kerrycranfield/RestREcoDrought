import csv

header_list = ['OTU ID', 'Taxonomy', 'WINDMILL_farm-Control', 'WINDMILL_farm-Drought', 'Castle_Field_West_W-Control', 'Castle_Field_West_W-Drought', 'Jemma_6-Control', 'Jemma_6-Drought', 'Jemma_9-Control', 'Jemma_9-Drought', 'Lardon Chase-Control', 'Lardon Chase-Drought']
fun_list=[]

with open("C:/Users/kerry/Documents/Projects/masters/Bioinformatics/thesis/interactive_report/data/merged_taxa.tsv") as taxa_file:
    taxa_reader=csv.DictReader(taxa_file, delimiter="\t")

    for row in taxa_reader:
        if not row["Kingdom"].startswith('k_'):
            row["Kingdom"] = 'k_' + row["Kingdom"]
        if not row["Phylum"].startswith('p_'):
            row["Phylum"] = 'p_' + row["Phylum"]
        if not row["Class"].startswith('c_'):
            row["Class"] = 'c_' + row["Class"]
        if not row["Order"].startswith('o_'):
            row["Order"] = 'o_' + row["Order"]
        if not row["Family"].startswith('f_'):
            row["Family"] = 'f_' + row["Family"]
        if not row["Genus"].startswith('g_'):
            row["Genus"] = 'g_' + row["Genus"]
        
        taxonomy=""
        taxa_list = [row["Kingdom"], row["Phylum"], row["Class"], row["Order"], row["Family"], row["Genus"]]
        
        for item in taxa_list:
            if "_NA" in item:
                break
            else:
                taxonomy=f"{taxonomy}{item};"
        fun_list.append([row['OTU ID'], taxonomy[:-1], row['WINDMILL_farm-Control'], row['WINDMILL_farm-Drought'], row['Castle_Field_West_W-Control'], row['Castle_Field_West_W-Drought'], row['Jemma_6-Control'], row['Jemma_6-Drought'], row['Jemma_9-Control'], row['Jemma_9-Drought'], row['Lardon Chase-Control'], row['Lardon Chase-Drought']])

with open("C:/Users/kerry/Documents/Projects/masters/Bioinformatics/thesis/interactive_report/data/funguild_input.tsv", 'w', newline='') as fun_data:
    fun_writer=csv.writer(fun_data, delimiter="\t")
    fun_writer.writerow(header_list)

    for item in fun_list:
        fun_writer.writerow(item)