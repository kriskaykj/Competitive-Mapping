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
#SBATCH --mail-user kristine.jecha@unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

#cat /work/FAC/FBM/DEE/tschwand/default/kjecha/Ants/Decontaminate/contam_genomes/*.fasta > all_contams.fasta
#bwa index /work/FAC/FBM/DEE/tschwand/default/kjecha/Ants/Decontaminate/all_contams.fasta
#bwa mem -t 1 /work/FAC/FBM/DEE/tschwand/default/kjecha/Ants/Decontaminate/all_contams.fasta /work/FAC/FBM/DEE/tschwand/operation_fourmis/glavanc1/Lasius/clean//1007.fq.gz | samtools sort --output-fmt=BAM --threads 1 -o /work/FAC/FBM/DEE/tschwand/default/kjecha/Ants/Decontaminate/map/1007.bam -

module load gcc/9.3.0
module load bwa/0.7.17
module load samtools/1.12

gzip *_name.fasta

samps=("1007" "6540" "2875" "15693" "20161" "16977" "15310" "810" "2328" "19869" "15997" "20500" "7513" "20277" "9849" "6385" "10964" "9991741" "9991161" "9990682" "11140" "13753" "9991683" "9991369" "12898" "12780" "18447" "6013" "7400" "14322" "12141" "12654B" "11127" "17796" "8879" "8398" "5762" "13209" "18205" "2359" "12144" "1959" "10312" "14594" "10127" "10548" "9137" "5772" "564" "7774" "16323" "18924" "2059" "12224" "3994" "2901" "10895" "2654" "7248" "1847" "6549" "5103" "2064" "18247" "8315" "17649" "1096" "19593" "5831" "10038" "9541" "9271" "17978" "5791" "16329" "8727" "13175" "16764" "2596B" "5790" "664" "11374" "8559" "1989" "12844" "16085" "2048" "11419" "16685" "16097" "15176" "14813" "16134")

bwa index catgen.fasta


for READ in ${samps[@]}; do

	bwa mem -t 1 ./catgen.fasta /work/FAC/FBM/DEE/tschwand/operation_fourmis/glavanc1/Lasius/clean//$READ.fq.gz| samtools sort --output-fmt=BAM --threads 1 -o ./catgen_$READ.bam -
	
done

for filename in ./*.bam; do 

	echo $filename >> catgen_flagstat.txt
	samtools flagstat $filename >> catgen_flagstat.txt

done


#CHROM NAME DUPLICATIONS, NEED TO LABEL WITH SPEC NAME BEFORE CAT
