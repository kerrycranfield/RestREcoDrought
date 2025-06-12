import csv
import argparse

parser = argparse.ArgumentParser(description="""This program collapses a metadata file to site/treatment level""")

parser.add_argument("input_file", type=str, help="The name of the metadata file to be collapsed or aggregated")
parser.add_argument("output_file", type=str, help="The name of the new reduced metadata file")

args=parser.parse_args()

in_file = args.input_file
out_file = args.output_file

meta_set = set()
header_list = ['sampleid', 'Site', 'Field_no', 'Treatment']

# Change pathname of file to one appropriate to your own file storage
with open(in_file, "r") as meta_file:
    metareader = csv.DictReader(meta_file, delimiter="\t")
    
    for row in metareader:
        meta_set.add((row['Group_by'], row['Site'], row['Field_no'], row['Treatment']))

with open(out_file, "w", newline='') as new_metafile:
    metadata_writer = csv.writer(new_metafile, delimiter="\t")
    metadata_writer.writerow(header_list)
    for item in meta_set:
        metadata_writer.writerow(item)
