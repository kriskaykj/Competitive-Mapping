#!/bin/bash

#Slurm options:

#SBATCH --partition=cpu
#SBATCH --time=0-02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80GB
#SBATCH --job-name=scaf
#SBATCH --export=NONE
#SBATCH --mail-user @unil.ch
#SBATCH --mail-type BEGIN,END,FAIL,TIME_LIMIT_50

YOURDIR=/scratch/kjecha/ants/catgen/
GENDIR=/scratch/kjecha/ants/antcontam/antgenomes

module load gcc/10.4.0
module load bwa/0.7.17
module load samtools/1.15.1

mkdir $YOURDIR/sam
mkdir $YOURDIR/sam/cut

#Add species name before each scaffold name(to distinguish when combined so there aren't multiple "scaffold 1"		!CHANGE PATH TO GENOME DIRECTOY & NAME OF SPECIES!
sed 's/>/& Bacillus_rossius_/' $GENDIR/Bacillus_rossius.fasta >  $YOURDIR/Bacillus_rossius_name.fasta
sed 's/>/& Camponotus_fallax_/' $GENDIR/Camponotus_fallax.fasta >  $YOURDIR/Camponotus_fallax_name.fasta
sed 's/>/& Lasius_alienus_/' $GENDIR/Lasius_alienus.fasta >  $YOURDIR/Lasius_alienus_name.fasta
sed 's/>/& Lasius_cf_spathepus_/' $GENDIR/Lasius_cf_spathepus.fasta > $YOURDIR/Lasius_cf_spathepus_name.fasta
sed 's/>/& Lasius_flavus_s1_/' $GENDIR/Lasius_flavus_s1.fasta >  $YOURDIR/Lasius_flavus_s1_name.fasta
sed 's/>/& Lasius_flavus_s2_/' $GENDIR/Lasius_flavus_s2.fasta >  $YOURDIR/Lasius_flavus_s2_name.fasta
sed 's/>/& Lasius_fuliginosus_s1_/' $GENDIR/Lasius_fuliginosus_s1.fasta >  $YOURDIR/Lasius_fuliginosus_s1_name.fasta
sed 's/>/& Lasius_fuliginosus_s2_/' $GENDIR/Lasius_fuliginosus_s2.fasta >  $YOURDIR/Lasius_fuliginosus_s2_name.fasta
sed 's/>/& Lasius_neglectus_/' $GENDIR/Lasius_neglectus.fasta >  $YOURDIR/Lasius_neglectus_name.fasta
sed 's/>/& Lasius_niger_/' $GENDIR/Lasius_niger.fasta >  $YOURDIR/Lasius_niger_name.fasta
sed 's/>/& Linepithema_humile_/' $GENDIR/Linepithema_humile.fasta >  $YOURDIR/Linepithema_humile_name.fasta
sed 's/>/& Messor_barbarus_/' $GENDIR/Messor_barbarus.fasta >  $YOURDIR/Messor_barbarus_name.fasta
sed 's/>/& Messor_barbarusFlye_/' $GENDIR/Messor_barbarusFlye.fasta >  $YOURDIR/Messor_barbarusFlye_name.fasta
sed 's/>/& Messor_capitatus_/' $GENDIR/Messor_capitatus.fasta >  $YOURDIR/Messor_capitatus_name.fasta
sed 's/>/& Pseudolasius_sp_/' $GENDIR/Pseudolasius_sp.fasta >  $YOURDIR/Pseudolasius_sp_name.fasta
sed 's/>/& Solenopsis_fugax_/' $GENDIR/Solenopsis_fugax.fasta >  $YOURDIR/Solenopsis_fugax_name.fasta
sed 's/>/& Solenopsis_geminata_/' $GENDIR/Solenopsis_geminata.fasta >  $YOURDIR/Solenopsis_geminata_name.fasta
sed 's/>/& Solenopsis_invicta_/' $GENDIR/Solenopsis_invicta.fasta >  $YOURDIR/Solenopsis_invicta_name.fasta
sed 's/>/& Timema_douglasi_/' $GENDIR/Timema_douglasi.fasta >  $YOURDIR/Timema_douglasi_name.fasta
sed 's/>/& Triticum_aestivum_/' $GENDIR/Triticum_aestivum.fasta >  $YOURDIR/Triticum_aestivum_name.fasta


#Create file to list the first scaffold name of each genome, to confirm the species name is at the begining of scaffold name
for FASTAN in $YOURDIR/*_name.fasta; do
	grep ">" $FASTAN | head -1 >> $YOURDIR/scafs.txt
done

#Combine all genomes into one large fasta file
cat $YOURDIR/*_name.fasta > $YOURDIR/catgen.fasta

#Index catgen to prepare for BWA
bwa index $YOURDIR/catgen.fasta

