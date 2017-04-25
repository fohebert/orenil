#!/bin/bash
#SBATCH -D ./
#SBATCH -J read-count
#SBATCH -o readC-%j.Log
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH -c 1
#SBATCH -mail-type=ALL
#SBATCH --mail-user=francois-olivier.gagnon-hebert.1@ulaval.ca
#SBATCH --time=10:00:00
#SBATCH --mem=1000

# GLOBAL VARIABLES
COUNTS='04.htseq-count/genome/pacbio.version'

# Producing 1 read-count file per library
# Eeah individual read-count file should contain
# only the column with the counts, from the output
# of HTSEQ-COUNT. All read count files (i.e. columns)
# will later be merged together to produce the final
# read-count matrix.
for file in `ls -1 ${COUNTS}/*.out | sed 's/04\.htseq-count\/genome\/pacbio\.version\///g'`; do
    awk '{print $2}' ${COUNTS}/${file} >${COUNTS}/${file%.htseq-count.out}.countsOnly.txt; 
done

# Producing the header of the final matrix
ls -1 ${COUNTS}/*.countsOnly.txt | sed 's/04\.htseq-count\/genome\/pacbio\.version\///g' | sed 's/\.countsOnly\.txt//g' >${COUNTS}/temp.sp
# This script transposes rows into columns
transpose.py ${COUNTS}/temp.sp ${COUNTS}/head.sp

# Producing the row names of the final matrix
# NB: I take any output file from HTSEQ-COUNT and print only the first
# column, i.e. the names of all the gene features contained in the genome.
awk '{print $1}' ${COUNTS}/HI.3301.003.Index_3.6U7c.htseq-count.out >${COUNTS}/orenil.pacbio.geneFeatures.names.txt
# NB: VERY IMPORTANT!!! You have to discard the last 5 lines of the output file, because it keeps the
# some lines that we don't need in the read count matrix, i.e. summary of HTSEQ-COUNT run. These  lines
# contains info on no_feature, ambiguous, too_low_aQual, not_aligned, alignment_not_unique.

# Pasting together the read-count columns
paste ${COUNTS}/orenil.pacbio.geneFeatures.names.txt ${COUNTS}/*.countsOnly.txt >${COUNTS}/matrix.temp
cat ${COUNTS}/head.sp ${COUNTS}/matrix.temp >${COUNTS}/orenil.pacbio.readCounts.temp

# Discarding the last 5 lines of the final matrix, because the info on the
# number of unannotated features and other technical information was kept at
# the end of the raw count files. We don'T want that info in the final matrix.
head -n 71884 orenil.pacbio.readCounts.temp >orenil.pacbio.readCounts.tsv

# CLEANING
rm orenil.pacbio.readCounts.temp
rm head.sp
rm temp.sp
rm *.countsOnly.txt
