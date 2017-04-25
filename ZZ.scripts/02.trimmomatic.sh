#!/bin/bash
#SBATCH -J trimmomatic
#SBATCH -D ./
#SBATCH -o trim-%j.Log
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH -c 10
#SBATCH --mail-type=ALL
#SBATCH --mail-user=francois-olivier.gagnon-hebert.1@ulaval.ca
#SBATCH --time=96:00:00
#SBATCH --mem=40000

# GLOBAL VARIABLES
VECTORS="00.archive/univec_trimmomatic.fasta"
RAW="01.raw.data"
OUTPUT="02.trimmomatic"

# Loading the trimmomatic module
module load /prg/Modules/bioinfo/trimmomatic/0.36

# Using trimmomatic to trim and "clean" the reads
ls -1 $RAW/*.fastq.gz | \
    sed 's/01.raw.data\///' | \
    sed 's/_R[12]\.fastq\.gz//g' | \
    sort -u | \
    while read i
    do
        echo $i
        trimmomatic-0.36.jar PE \
            -threads 10 \
            -trimlog trim.Log \
            $RAW/"$i"_R1.fastq.gz \
            $RAW/"$i"_R2.fastq.gz \
            $OUTPUT/"$i"_R1.paired.fastq.gz \
            $OUTPUT/"$i"_R1.single.fastq.gz \
            $OUTPUT/"$i"_R2.paired.fastq.gz \
            $OUTPUT/"$i"_R2.single.fastq.gz \
            ILLUMINACLIP:$VECTORS:2:30:10 \
            SLIDINGWINDOW:20:2 \
            LEADING:2 \
            TRAILING:2 \
            MINLEN:60
    done
