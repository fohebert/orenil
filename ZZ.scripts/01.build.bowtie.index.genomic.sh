#!/bin/bash
#SBATCH -D ./
#SBATSH -J bowtie-ind
#SBATCH -o bowtie-ind-%j.Log
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH -c 2
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francois-olivier.gagnon-hebert.1@ulaval.ca
#SBATCH --time=10:00:00
#SBATCH --mem=2000

# Loading required program(s)
module load bowtie/2.1.0

# Creating the bowtie index that will be used to perform the TOPHAT alignment
cp ./01.raw.data/*.fna ./
bowtie2-build GCF_001858045.1_ASM185804v2_genomic.fna orenil.genome
