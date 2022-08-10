YOURDIR <-"/scratch/kjecha/ants/antcontam/Competitive-Mapping"
setwd(paste(YOURDIR, "/sam/cut", sep=""))
library(dplyr)
library(ggplot2)
library(reshape2)

cbind.fill <- function(...){
  nm <- list(...) 
  nm <- lapply(nm, as.matrix)
  n <- max(sapply(nm, nrow)) 
  do.call(cbind, lapply(nm, function (x) 
    rbind(x, matrix(, n-nrow(x), ncol(x))))) 
}

#####

#create list of sample IDs based on file names
reads <- as.data.frame(list.files(path = (paste(YOURDIR, "/sam/cut", sep=""))))
reads <- as.data.frame(sub(".sam.*", "", reads[,1]))
reads <- gsub(".*_","",reads[,1])

#confirm sample ID in read variable
head(reads)


formica <- data.frame()

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
      startsWith(sam.filter$scaf, "Formica") ~ "Formica" , 
      startsWith(sam.filter$scaf, "Camponotus") ~ "Camponotus" ,
      startsWith(sam.filter$scaf, "Myrmica") ~ "Myrmica" , 
      startsWith(sam.filter$scaf, "Lasius") ~ "Lasius"     
    ))
  
  print("add species names: done")
  print(colnames(sam.filter.sp))
  
  #create file to check that species names were added
  uniques <- (sam.filter.sp[!duplicated(sam.filter.sp$spec), ])
  
  onlyForm<-subset(sam.filter.sp, spec=='Lasius')
  Freads <- as.data.frame(onlyForm$qname)
  colnames(Freads) <- row
  formica <- cbind.fill(formica, Freads)  
  
}
setwd(YOURDIR)

write.table(formica, "targetReads.txt", 
            append = FALSE, sep = " ", dec = ".",
            row.names = F , col.names = TRUE, quote = F)
