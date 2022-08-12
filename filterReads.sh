#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=0-4:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=Freads
#SBATCH --export=NONE
#SBATCH --mail-user @unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

module load gcc/9.3.0
module load r/4.0.5
module load samtools/1.12

YOURDIR=/scratch/kjecha/ants/antcontam/Competitive-Mapping
#gunzip $YOURDIR/bam/*.bam.gz
gunzip $YOURDIR/sam/cut/*.sam.gz
mkdir IDS
mkdir Filtered

#Run the r script file
Rscript filterReads.r

#gzip $YOURDIR/sam/cut/*.sam
