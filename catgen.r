
YOURDIR <-"/scratch/kjecha/ants/catgen"
setwd(paste(YOURDIR, "/sam/cut", sep=""))
library(dplyr)
library(ggplot2)
library(reshape2)

#function to create summary map dataframe
cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}

#create list of sample IDs based on file names
reads <- as.data.frame(list.files(path = (paste(YOURDIR, "/sam/cut", sep=""))))
reads <- as.data.frame(sub(".sam.*", "", reads[,1]))
reads <- gsub(".*_","",reads[,1])

#confirm sample ID in read variable
head(reads)
#initialize dataframe for summary plot			
summap <- data.frame()
#for each read...
for (row in  reads){
  setwd(paste(YOURDIR, "/sam/cut", sep=""))
  print(row)
  sam <- read.table(paste("catgen_", row,".sam", sep = ""), fill = T, row.names=NULL)
  #print(head(sam, n=1))
  
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


 #create file to check that species names were added
  #write.table(uniques, paste("sam.filter_",row ,".txt", sep=""), 
  #            append = FALSE, sep = " ", dec = ".",
   #           row.names = TRUE, col.names = TRUE) 	
  
  print("wrote out file: done")
  
 setwd(paste(YOURDIR, "/mapplots", sep=""))		
  
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
  

  tempdf<- data.frame()
  for (specs in(uniques$spec)){
    specprop<-as.numeric( (sum(sam.filter.sp$spec == specs ))/ (as.numeric(nrow(sam.filter.sp))))
      tempdf1 <- as.data.frame(cbind((specs), (as.numeric(specprop)))) #make table with specs col and prop
      tempdf1$V2 <- as.numeric(tempdf1$V2)
      tempdf<-rbind(tempdf,tempdf1)
  } 


  colnames(tempdf)<-c("spec", row)
  summap <- cbind.fill(summap, tempdf)  
  print("Made summap dataframe")
  
}
print("loop:done")
setwd(YOURDIR) 
#remove dupilcate cols or every other
summap <- as.data.frame(summap[ , !duplicated(colnames(summap))])

#Create summary plot
summap1 <- melt(summap, id.vars='spec')
summap1$value <- as.numeric(summap1$value)
print("Prepped data for boxplot")

#Creates summary of all sample mapping
summapP <-  ggplot(summap1, aes(spec, value, fill=spec)) + 
  geom_boxplot() + 
  geom_jitter(color="black", size=2) +
  labs(title="Summary of Competitive Mapping", x ="species", y = "proportion")+
  theme(axis.text.x = element_text(angle = 45, vjust = 1.0, hjust=1)) +ylim(0,1)
#output summary to .jpeg
print("creating jpeg")
jpeg(paste("mapplot_summary.jpeg", sep=""),width = 480, height = 480, quality = 100)
print(summapP)
dev.off() 

