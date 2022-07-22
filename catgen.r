YOURDIR <-"/scratch/kjecha/ants/catgen/"
setwd(paste(YOURDIR, "/sam/cut", sep=""))
library(dplyr)
library(ggplot2)

#create list of sample IDs based on file names
reads <- as.data.frame(list.files(path = (paste(YOURDIR, "/sam/cut", sep=""))))
reads <- as.data.frame(sub(".sam.*", "", reads[,1]))
reads <- gsub(".*_","",reads[,1])

#confirm sample ID in read variable
head(reads)

#for each read...
for (row in  reads){
setwd(paste(YOURDIR, "/sam/cut", sep=""))
  print(row)
  sam <- read.table(paste("catgen_", row,".sam", sep = ""), fill = T, row.names=NULL)
print(head(sam, n=1))
#create column names based on .sam file output
  colnames(sam) <- c("qname","flag","scaf","pos","mapq","cigar",
                     "mrnm","mpos","isize","seq","qual" )
  sam <- sam[!is.na(sam$scaf),]
  sam = subset(sam, select = c("qname","flag","scaf","pos","mapq","cigar",
                               "mrnm","mpos","isize","seq","qual") )
#filter out reads that had a mapping quality less than 30
  sam.filter <- subset(sam, mapq >= 30) 
	print("filter out low qual: done")
#label each alignment with the species it mapped to 			!CHANGE SPECIES NAMES!
  sam.filter.sp <- sam.filter %>%
    mutate(spec = case_when(
      startsWith(sam.filter$scaf, "Bacillus_rossius") ~ "Bacillus_rossius" , 
      startsWith(sam.filter$scaf, "Camponotus_fallax") ~ "Camponotus_fallax" ,
      startsWith(sam.filter$scaf, "Lasius_alienus") ~ "Lasius_alienus" , 
      startsWith(sam.filter$scaf, "Lasius_cf_spathepus") ~ "Lasius_cf_spathepus" ,
      startsWith(sam.filter$scaf, "Lasius_flavus_s1") ~ "Lasius_flavus_s1" , 
      startsWith(sam.filter$scaf, "Lasius_flavus_s2") ~ "Lasius_flavus_s2" ,
      startsWith(sam.filter$scaf, "Lasius_fuliginosus_s1") ~ "Lasius_fuliginosus_s1" , 
      startsWith(sam.filter$scaf, "Lasius_fuliginosus_s2") ~ "Lasius_fuliginosus_s2" ,
      startsWith(sam.filter$scaf, "Lasius_neglectus") ~ "Lasius_neglectus" , 
      startsWith(sam.filter$scaf, "Lasius_niger") ~ "Lasius_niger" ,
      startsWith(sam.filter$scaf, "Linepithema_humile") ~ "Linepithema_humile" , 
      startsWith(sam.filter$scaf, "Messor_barbarusFlye") ~ "Messor_barbarusFlye" ,
      startsWith(sam.filter$scaf, "Messor_barbarus") ~ "Messor_barbarus" , 
      startsWith(sam.filter$scaf, "Messor_capitatus") ~ "Messor_capitatus" ,
      startsWith(sam.filter$scaf, "Pseudolasius_sp") ~ "Pseudolasius_sp" , 
      startsWith(sam.filter$scaf, "Solenopsis_fugax") ~ "Solenopsis_fugax" ,
      startsWith(sam.filter$scaf, "Solenopsis_geminata") ~ "Solenopsis_geminata" , 
      startsWith(sam.filter$scaf, "Solenopsis_invicta") ~ "Solenopsis_invicta" ,
      startsWith(sam.filter$scaf, "Timema_douglasi") ~ "Timema_douglasi" , 
      startsWith(sam.filter$scaf, "Triticum_aestivum") ~ "Triticum_aestivum" ,
    ))
  
  print("add species names: done")
 print(colnames(sam.filter.sp))
  #create file to check that species names were added
uniques <- (sam.filter.sp[!duplicated(sam.filter.sp$spec), ])
write.table(uniques, paste("sam.filter_",row ,".txt", sep=""), 
append = FALSE, sep = " ", dec = ".",
row.names = TRUE, col.names = TRUE)

print("wrote out file: done")

setwd("YOURDIR")
#create mapplot for the sample, output at .jpeg
 p<- ggplot(sam.filter.sp, aes(x=spec, fill=spec)) + 
    geom_bar(aes(y = (..count..)/sum(..count..))) +
   geom_text(aes(y = ((..count..)/sum(..count..)), label = scales::scientific((..count..)/sum(..count..))),
             stat = "count", vjust = 0.5, hjust=0, angle=90, size=3) + 
    labs(title=(paste("Maps per species. read:",row)), x ="species", y = "proportion")+ ylim(0,1.01)+
    theme(axis.text.x = element_text(angle = 45, vjust = 1.0, hjust=1))
 jpeg(paste("mapplot_",row ,".jpeg", sep=""),width = 480, height = 480, quality = 75)
 print(p)
    dev.off() 
print("pic made:done")

rm(sam, sam.filter, sam.filter.sp)
print("cleared sams:done")
}
print("loop:done")
