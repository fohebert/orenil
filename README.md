# Alignment pipeline for RNAseq paired-end reads on _Oreochromis niloticus_
## Genome version used: NCBI PacBio v2, accession number GCA_001858045.2

**NB**: This pipeline was ran in a very specific context. Use at your own risk. There is no guaratee that this is going to work in a different context (diffrent cluster system with different computer power).

## Requirements
- [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic) 
- [Tophat](https://ccb.jhu.edu/software/tophat/index.shtml)
- [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
- [htseq-count](http://www-huber.embl.de/HTSeq/doc/count.html)
- [Python 2.7](https://www.python.org/download/releases/2.7/)

## Before starting
Make sure all of the required programs are installed and running well. Next, download the genome assembly FASTA file AND the gene feature file (GFF) directly from the [NCBI webpage](ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/858/045/GCF_001858045.1_ASM185804v2). Files to download are the following:
- GCF_001858045.1_ASM185804v2_genomic.fna
- GCF_001858045.1_ASM185804v2_genomic.gff

These 2 files should then be transfered into the folder called 01.raw.data

## Usage
This pipeline is quite straightforward, scripts should be launched from the main directory and they should follow their respective number, i.e. script number 01 should be submitted first and then 02, 03, and so on. The output of each script should technically be re-directed to the appropriate folder. For example, the output from trimmomatic will be placed in the trimmomatic folder and the output from the htseq-count script will be re-directed to the htseq-count directory.
