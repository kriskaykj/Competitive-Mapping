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

sed 's/>/& Bacillus_rossius_/' /scratch/kjecha/ants/contam_genomes/Bacillus_rossius.fasta >  $YOURDIR/Bacillus_rossius_name.fasta
sed 's/>/& Camponotus_fallax_/' /scratch/kjecha/ants/contam_genomes/Camponotus_fallax.fasta >  $YOURDIR/Camponotus_fallax_name.fasta
sed 's/>/& Lasius_alienus_/' /scratch/kjecha/ants/contam_genomes/Lasius_alienus.fasta >  $YOURDIR/Lasius_alienus_name.fasta
sed 's/>/& Lasius_cf_spathepus_/' /scratch/kjecha/ants/contam_genomes/Lasius_cf_spathepus.fasta > $YOURDIR/Lasius_cf_spathepus_name.fasta
sed 's/>/& Lasius_flavus_s1_/' /scratch/kjecha/ants/contam_genomes/Lasius_flavus_s1.fasta >  $YOURDIR/Lasius_flavus_s1_name.fasta
sed 's/>/& Lasius_flavus_s2_/' /scratch/kjecha/ants/contam_genomes/Lasius_flavus_s2.fasta >  $YOURDIR/Lasius_flavus_s2_name.fasta
sed 's/>/& Lasius_fuliginosus_s1_/' /scratch/kjecha/ants/contam_genomes/Lasius_fuliginosus_s1.fasta >  $YOURDIR/Lasius_fuliginosus_s1_name.fasta
sed 's/>/& Lasius_fuliginosus_s2_/' /scratch/kjecha/ants/contam_genomes/Lasius_fuliginosus_s2.fasta >  $YOURDIR/Lasius_fuliginosus_s2_name.fasta
sed 's/>/& Lasius_neglectus_/' /scratch/kjecha/ants/contam_genomes/Lasius_neglectus.fasta >  $YOURDIR/Lasius_neglectus_name.fasta
sed 's/>/& Lasius_niger_/' /scratch/kjecha/ants/contam_genomes/Lasius_niger.fasta >  $YOURDIR/Lasius_niger_name.fasta
sed 's/>/& Linepithema_humile_/' /scratch/kjecha/ants/contam_genomes/Linepithema_humile.fasta >  $YOURDIR/Linepithema_humile_name.fasta
sed 's/>/& Messor_barbarus_/' /scratch/kjecha/ants/contam_genomes/Messor_barbarus.fasta >  $YOURDIR/Messor_barbarus_name.fasta
sed 's/>/& Messor_barbarusFlye_/' /scratch/kjecha/ants/contam_genomes/Messor_barbarusFlye.fasta >  $YOURDIR/Messor_barbarusFlye_name.fasta
sed 's/>/& Messor_capitatus_/' /scratch/kjecha/ants/contam_genomes/Messor_capitatus.fasta >  $YOURDIR/Messor_capitatus_name.fasta
sed 's/>/& Pseudolasius_sp_/' /scratch/kjecha/ants/contam_genomes/Pseudolasius_sp.fasta >  $YOURDIR/Pseudolasius_sp_name.fasta
sed 's/>/& Solenopsis_fugax_/' /scratch/kjecha/ants/contam_genomes/Solenopsis_fugax.fasta >  $YOURDIR/Solenopsis_fugax_name.fasta
sed 's/>/& Solenopsis_geminata_/' /scratch/kjecha/ants/contam_genomes/Solenopsis_geminata.fasta >  $YOURDIR/Solenopsis_geminata_name.fasta
sed 's/>/& Solenopsis_invicta_/' /scratch/kjecha/ants/contam_genomes/Solenopsis_invicta.fasta >  $YOURDIR/Solenopsis_invicta_name.fasta
sed 's/>/& Timema_douglasi_/' /scratch/kjecha/ants/contam_genomes/Timema_douglasi.fasta >  $YOURDIR/Timema_douglasi_name.fasta
sed 's/>/& Triticum_aestivum_/' /scratch/kjecha/ants/contam_genomes/Triticum_aestivum.fasta >  $YOURDIR/Triticum_aestivum_name.fasta



for FASTAN in $YOURDIR/*_name.fasta; do
	grep ">" $FASTAN | head -1 >> $YOURDIR/scafs.txt
done

cat *_name.fasta > $YOURDIR/catgen.fasta
