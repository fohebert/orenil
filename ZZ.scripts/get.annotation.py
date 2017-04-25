#!/usr/bin/env python
"""
\033[1mDESCRIPTION\033[0m
    Takes the gene feature table and associates each
    accession number in the final read count matrix
    to its respective gene product. This info will
    be added into the final read-count matrix file.

\033[1mUSAGE\033[0m
    %program <in.features> <in.readCount> <in.geneFeatureTable> <output>

    NB: <in.features> = names (one per line) of gene features
    that we want to include in the final read count table

\033[1mCREDITS\033[0m
    Doc Pants 2017 \m/
"""

import sys

try:
    in_features = sys.argv[1]
    in_read_counts = sys.argv[2]
    in_featureTable = sys.argv[3]
    out_file = sys.argv[4]
except:
    print __doc__
    sys.exit(1)

# Dictionary containing the gene feature info
meta_info = {}

# Filling in the dictionary with gene feature info
with open(in_features, "rU") as i_f:
    for line in i_f:
        line = line.strip()
        
        # Keeping only the gene ID
        if line.find("Genbank:") != -1:
            gene_id = line.split("Genbank:")[-1]
            
            # If that gene ID is not already in the dictionary,
            # it is added and will be filled in later with the
            # corresponding gene product.
            if gene_id not in meta_info:
                meta_info[gene_id] = ""

# Filling in the dictionary with the annotation information
with open(in_featureTable, "rU") as in_gf:
    for line in in_gf:
        line = line.strip()
        
        # Product accession number
        prod_accession = line.split("\t")[10] 

        # If the accession column contains an actual id number
        if prod_accession != "":
            
            # The accession number is compared to the ones in the
            # dictionary and if it's in the dictionary, its corresponding
            # gene product is added.
            if prod_accession in meta_info:
                if meta_info[prod_accession] == "":
                    meta_info[prod_accession] = line.split("\t")[13]

# Producing the output file
with open(in_read_counts, "rU") as i_rc:
    with open(out_file, "w") as o_f:
        for line in i_rc:
            line = line.strip()
            
            # When dealing with the header, the programs simply prints it
            # in the output file.
            if line.startswith("HI."):
                o_f.write("\t" + "Annotation" + "\t" + line)
            
            # Dealing with each gene feature
            elif line.startswith("\tHI.") == False:
                feature = line.split("\t")[0] # Keeping the feature name
                
                # If the feature we are dealing with currently contains
                # a Genbank accession, it is added in the final output file
                if feature.find("Genbank:") != -1:
                    gene_id = feature.split("Genbank:")[-1]
                    o_f.write("\n" + feature + "\t" + meta_info[gene_id] + "\t" + "\t".join(line.split("\t")[1:]))
                
                else:
                    o_f.write("\n" + feature + "\t" + "NA" + "\t" + "\t".join(line.split("\t")[1:]))

print "\nTask completed\n"
