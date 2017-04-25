#!/bin/bash
#SBATCH -J htseq
#SBATCH -D ./
#SBATCH -o htseq-%j.Log
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH -c 2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francois-olivier.gagnon-hebert.1@ulaval.ca
#SBATCH --time=90:00:00
#SBATCH --mem=20000

# GLOBAL VARIABLES
OUTPUT='04.htseq-count/genome/pacbio.version'
MAPPED='03.tophat.results/genomic.results'
GFF='01.raw.data/'

# Using HTSeq-count to count the number of reads for each feature of the cichlid genome in each mapping file.
for file in `ls -1 ${MAPPED}/*.bam | sed 's/03\.tophat\.results\/genomic\.results\///g'`; do
    python -m HTSeq.scripts.count -f bam -s no -m intersection-nonempty -i Dbxref ${MAPPED}/${file} ${GFF}/GCF_001858045.1_ASM185804v2_genomic.gff >${OUTPUT}/${file%.sorted.bam}.htseq-count.out; 
done
