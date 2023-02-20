#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=sprmap
#SBATCH --export=NONE
#SBATCH --mail-user @unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50


module load gcc/9.3.0
module load bwa/0.7.17
module load samtools/1.12

YOURDIR=/work/FAC/FBM/DEE/tschwand/operation_fourmis/kjecha/AllGenusCompetitive-Mapping/Myrm
CATGEN=/work/FAC/FBM/DEE/tschwand/operation_fourmis/kjecha/AllGenusCompetitive-Mapping

SAMPS=/work/FAC/FBM/DEE/tschwand/operation_fourmis/glavanc1/Myrmica/clean/

gzip $YOURDIR/*_name.fasta

	#Pickup where left off, ignore smaples that have already been mapped
for filename in $SAMPS/*.fq.gz; do 
	f=${filename%.fq.gz}
	READ=${f##*/}
	if [ -f "$YOURDIR/sam/catgen_$READ.sam" ]; then
	continue
	else 
	echo $READ
	bwa mem -t 1 $CATGEN/catgen.fasta $SAMPS/$READ.fq.gz| samtools sort --output-fmt=SAM --threads 1 -o $YOURDIR/sam/catgen_$READ.sam -
	fi
done


