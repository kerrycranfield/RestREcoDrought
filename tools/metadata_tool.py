import csv

# Set headers to sampleid, site name, field no, treatment, group-by (new metadata column)
header_list = ['Sampleid', 'Site', 'Field_no', 'Treatment', 'Group_by']

# List of samples in metadata but not in data folder
missing_sam = ["F2C1", "F2C2", "F20S2", "F20S3", "F54S3"]

# Import metadata file as a dictionary reader
with open("/mnt/beegfs/home/kerry.hathway/thesis/data/WP4-site-names.txt") as meta_file:
    metareader = csv.DictReader(meta_file, delimiter="\t")

    fun_list = []
    bac_list = []

    for row in metareader:
        # Change Castle Fields site name to remove brackets
        if row["Site_name"] == "Castle_Field_West_(W)":
            row["Site_name"] = "Castle_Field_West_W"
        # If Treatment/Shelter is S1, S2 or S3, treatment is drought else treatment is control
        if row["Treatment/Shelter"].find("S") != -1:
            row["Treatment/Shelter"] = "Drought"
        elif row["Treatment/Shelter"].find("C") != -1:
            row["Treatment/Shelter"] = "Control"
        # Create variable to enable grouping of features by treatment within each site
        grouper = f"{row["Site_name"]}-{row["Treatment/Shelter"]}"
        if row["Fungi/Prokaryotes"] == "F":
            if row["Tube Label"] in missing_sam:
                continue
            if row["Site_name"] == "HARLEY_FARMS_new2b":
                continue
            fun_list.append([row["Tube Label"], row["Site_name"], row["Field No."], row["Treatment/Shelter"], grouper])
        elif row["Fungi/Prokaryotes"] == "P":
            bac_list.append([row["Tube Label"], row["Site_name"],
                            row["Field No."], row["Treatment/Shelter"], grouper])
    

with open("/mnt/beegfs/home/kerry.hathway/thesis/data/16S/metadata.txt", "w", newline="") as bac_data:
    bac_writer = csv.writer(bac_data, delimiter="\t")
    bac_writer.writerow(header_list)

    for item in bac_list:
        bac_writer.writerow(item)

with open("/mnt/beegfs/home/kerry.hathway/thesis/data/ITS/metadata.txt", "w", newline="") as fun_data:
    fun_writer = csv.writer(fun_data, delimiter="\t")
    fun_writer.writerow(header_list)

    for item in fun_list:
        fun_writer.writerow(item)


