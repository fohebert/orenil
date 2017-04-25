#!/bin/bash
#SBATCH -J tophat
#SBATCH -D ./
#SBATCH -o tophat-%j.Log
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH -c 10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francois-olivier.gagnon-hebert.1@ulaval.ca
#SBATCH --time=96:00:00
#SBATCH --mem=30000

# GLOBAL VARIABLES
TRIMMED='02.trimmomatic'
OUTPUT='03.tophat.results'

# Loading the required modules
module load tophat/2.1.1
module load bowtie/2.1.0

# Add to path previous version of SAMtools (For compatibility reasons)
export PATH=/home/fogah/prg/samtools-0.1.19/:$PATH

# Mapping each individual file on the Pacbio genome using tophat2
# NB: the genome has already been indexed with the first script
# called '01.build.bowtie.index.genomic.sh'
for file in `ls -1 ${TRIMMED}/*.fastq.gz | sed 's/02\.trimmomatic\///g' | sed 's/_R[12]\.paired\.fastq\.gz//g'`; do
    tophat2 -p 10 -o ${OUTPUT}/${file} -g 1 orenil.genome ${TRIMMED}/${file}_R1.paired.fastq.gz ${TRIMMED}/${file}_R2.paired.fastq.gz
done
