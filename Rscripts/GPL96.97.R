#------------   GPL96.97 Frame Script  ^_^   -----------
#------------   2016 JAN    -----------

#setting global path
projet.PATH <- getwd()

#1.Load Packages
library(devtools)
library(dplyr)
library(magrittr)
library(reshape2)
library(ggplot2)
library(gplots)

#2. Load Custom Functions
source( paste0(projet.PATH ,"/Rscripts/customFunction.R"))


#3.Load Data
load( paste0(projet.PATH ,"/inputDATA/humanGender-GPL96-GPL97.txt.RData"))
GPL96.97.MetaData <- sampleMetaData
GPL96.97.Data  <- dat

# -------------  Part 1 CLEANING ^_^    ------------

# -------------  Expression Data    ------------

#0.Transform dat to way Metadata was organised 
GPL96.97.Data %<>% t() %>% as.data.frame()

#1.Rename 
rownames(GPL96.97.Data) <- sapply(rownames(GPL96.97.Data),  
                        function(x) strsplit(x,  "\\.")[[1]][2])

#2.Others: sort by row/colName ; NA.rm; get max of each row
GPL96.97.Data %<>% clean.EXP() #32 samples are removed

# -------------  Metadata      ------------
#1.Rename
#1.1 rownames
rownames(GPL96.97.MetaData) <- sapply(rownames(GPL96.97.MetaData),  
                                   function(x) strsplit(x,  "\\.")[[1]][2])

#1.2 colnames: "G.Gemma"-metagender from Gemma;"G.GEO"-metagender from GEO
GPL96.97.MetaData <- rename(GPL96.97.MetaData, 
                         G.Gemma = sex1,  G.GEO = sex2,  G.check = gender)


#2.Sorting by colnames and rownames
GPL96.97.MetaData <- GPL96.97.MetaData[ sort( rownames( GPL96.97.MetaData ) ), ]


#keep meta data in Dataframe
GPL96.97.MetaData %<>% as.matrix() %>% as.data.frame()

# -------------  Merge and Organise Expression data & Metadata   ------------

MERGE <- merge.ROWname(GPL96.97.MetaData, GPL96.97.Data)


# -------------  log2 for Expression Data in MERGE  ------------
#Values larger than 20 are need to be transformed 
Log.DS <- unique(MERGE$dataset[MERGE$max > 20])

#Get all values positive to avoid NAN
temp <- grep("at_", names(MERGE))

for( i in Log.DS ){
    MIN <- sort( as.matrix( MERGE[ MERGE$dataset == i,  temp]))[1]
    if (MIN  >0) {
        MERGE[MERGE$dataset %in% i,  temp] <- 
            log2( MERGE[ MERGE$dataset %in% i,  temp])
    }
    
    else{
        ADJUST <- abs(MIN) * 1.05
        MERGE[ MERGE$dataset %in% i,  temp] <- 
            log2( MERGE[ MERGE$dataset %in% i, temp] + ADJUST)
    }
}

rm( temp )
rm(MIN)
rm(i)

# -------------  Part 2 PLOTTING :initial visualization^_^  -------------
#simplify the probe names

names(MERGE) <- gsub(" ","",names(MERGE)) 

MERGE.PLOT <- MERGE
names(MERGE.PLOT) <- sapply(names(MERGE.PLOT), function(x) strsplit(x,"_*")[[1]][1])

#get corrlation of probsets
COR <- cor(MERGE.PLOT[,c(grep("XIST",names(MERGE)),
                         grep("KDM5D|RPS4Y1",names(MERGE)))],
           method ="spearman")

pdf("./output/GPL96.97 probesets COR.pdf")

heatmap.2(COR, margins = c(8, 8),
          dendrogram="none", trace="none", na.color="grey",
          col=heat.colors(99), cexRow = 0.71, cexCol = 0.71, key = T,
          keysize = 1.2,  key.title ="", srtCol = 90,
          main = "correlation among sex related probsets",
          colRow = c(rep("red",7),rep("black",2)),
          colCol = c(rep("red",7),rep("black",2)))  



legend("topright", cex=0.5, legend = c("male", "female"), 
       col = c("black", "red"), lty= 1, lwd = 10  )

dev.off()

#-------------- Part 3 COMPARISION of META with GENETIC GENDER  ----------------

#-------------- Get Genetic Gender by Kmean Cluster with 2 Genes  -----------

#1.build a DF--KMEAN holding Meta|EXP(two genes)|Kmean|analysis
# 1.Subsetting All XIST Probes With ""XIST_243712_at_1128218"" Excluded
datasets <- as.character ( unique (MERGE$dataset) )

XIST.probes <- names(MERGE)[ grep("XIST",  names(MERGE))]
Female.probes <- XIST.probes[ -grep("XIST_243712_at_1128218", XIST.probes )]
Male.probes <- names(MERGE)[ grep("KDM5D_|RPS4Y1", names(MERGE))]

temp <- c(Female.probes, Male.probes)
KMEAN <- MERGE[ , c("dataset", "sampleID", "G.check",  temp)]
rm(temp)


#2. Each Dataset: get the kmean Gender 

for (i in datasets){
    sub <- KMEAN[ KMEAN$dataset == i, c(Female.probes, Male.probes)] 
    km <- kmeans(sub, centers=2)
    
    #3. Add Kmean gender to KMEAN
    temp <- km$cluster
    Ptemp <- km$centers
    if ( Ptemp[1, 1] > Ptemp[2, 1]){
        temp <- ifelse(temp == 1, "female", "male")
    }
    else {
        temp <- ifelse(temp == 2, "female", "male")
    }
    KMEAN[KMEAN$dataset == i, "G.kmean"] <- temp
    
    rm(temp)
    rm(Ptemp)
    
}
    
   
#-------------- Make Comparision Between Meta and Genetic Gender  --------------

#1. Kmean gender VS GEO Gender 
KMEAN$KMvsGEO <- ifelse( KMEAN$G.check == KMEAN$G.kmean,
                         KMEAN$G.kmean,  "disagree")
with (KMEAN, table (G.check,  G.kmean))

#2.SUM
GPL96.97.disDS.KMvsGEO <- KMEAN$dataset [KMEAN$KMvsGEO == "disagree"]
GPL96.97.disSP.KMvsGEO <- rownames(KMEAN) [KMEAN$KMvsGEO == "disagree"]

length (unique (GPL96.97.disDS.KMvsGEO)) #1
length(GPL96.97.disSP.KMvsGEO) #1

GPL96.97.DIS.KMvsGEO <- KMEAN[KMEAN$KMvsGEO =="disagree",]
#write.csv(GPL96.97.DIS.KMvsGEO, "./output/GPL96.97 disagreed KMvsMEDIAN before remove.csv")



#3. method two : median of XIST Vs median of KDM5D and RPS4Y1 
KMEAN$medianFemale <- apply(KMEAN[, Female.probes], 1, median)
KMEAN$medianMale <- apply(KMEAN[, Male.probes], 1, median)
KMEAN$medianF_M <- KMEAN$medianFemale - KMEAN$medianMale
KMEAN$G.medianF_M <- ifelse(KMEAN$medianF_M >= 0,"female","male")
KMEAN$Kmean.Median <- ifelse(KMEAN$G.medianF_M == KMEAN$G.kmean, KMEAN$G.kmean,"disagree")

write.csv(KMEAN,"./output/GPL96.97 all information.csv")
#GPL96.97.DIS.Kmean.Median<- KMEAN[KMEAN$Kmean.Median =="disagree",] #24
#write.csv(GPL96.97.DIS.Kmean.Median,"./output/GPL96.97 disagreed samples KMvsMEDIAN.csv")

#GPL96.97.KMEAN.RM <- KMEAN %>% filter(Kmean.Median !="disagree")
#write.csv(GPL96.97.KMEAN.RM,"./output/GPL96.97.KMEAN.RM all samples after remove KMvsMEDIAN.csv")
#GPL96.97.KMEAN.RM$dataset %>% droplevels%>% unique()%>%length

# 3. sum again

#GPL96.97.disDS.KMvsGEO.Sure<- GPL96.97.KMEAN.RM$dataset [GPL96.97.KMEAN.RM$KMvsGEO == "disagree"]
#GPL96.97.disSP.KMvsGEO.Sure<- GPL96.97.KMEAN.RM$sampleID [GPL96.97.KMEAN.RM$KMvsGEO == "disagree"]
#GPL96.97.DIS.KMvsGEO.Sure <- GPL96.97.KMEAN.RM[GPL96.97.KMEAN.RM$KMvsGEO == "disagree",]
#write.csv(GPL96.97.DIS.KMvsGEO.Sure,"./output/GPL96.97.DIS.KMvsGEO.Sure disagrees samlpes after the rm .csv")

#length (unique (GPL96.97.disDS.KMvsGEO.Sure)) #0
#length(GPL96.97.disSP.KMvsGEO.Sure) #0

#-------------- OUTPUT   ---------------

#striplot for samples------

PRBPLOT <- with(GPL96.97.KMEAN.RM,
                data.frame(sampleID, dataset, G.check , G.kmean, KMvsGEO, Kmean.Median,
                           probeset = factor(c( rep("XIST",   nrow(GPL96.97.KMEAN.RM)*6),
                                                rep("KDM5D",  nrow(GPL96.97.KMEAN.RM)  ),
                                                rep("RPS4Y1",  nrow(GPL96.97.KMEAN.RM)  ))),
                           
                           geneExp = c(XIST_214218_s_at_8687,  XIST_221728_x_at_1196,
                                       XIST_224588_at_1147332, XIST_224589_at_1147331, 
                                       XIST_224590_at_1147330, XIST_227671_at_1144254,
                                       KDM5D_206700_s_at_16058,RPS4Y1_201909_at_20847)))





pdf("./output/GPL96.97 highlight mislable samples in  EXP striplot for each dataset.pdf")

for(i in datasets){
    tmplot <- PRBPLOT %>% 
        mutate(KMplot = G.kmean) %>% 
        arrange(G.check) %>% 
        filter(dataset == i)
    
    tmplot$sampleID <- factor(tmplot$sampleID, 
                              levels = unique(as.character(tmplot$sampleID)))
    
    # get the position of annotation rect
    
    FcenterX = sum(tmplot$G.check == "female")/16
    McenterX = sum(tmplot$G.check == "female")/8 + sum(tmplot$G.check == "male")/16 + 0.5
    
    centerY = max(tmplot$geneExp) + 1
    
    
    #getKMplot ready for plot 
    
    levels(tmplot$KMplot) <- c("F", "M")
    KmeanLable <- tmplot$KMplot[!duplicated(tmplot$sampleID)]
    
    levels(KmeanLable) <- c("F", "M")
    
    
    #
    MM <- which(tmplot$KMvsGEO[!duplicated(tmplot$sampleID)] == "disagree")
    MMfront <- MM - 0.5 # without the first mismatchd samples
    MMafter <- MM + 0.5 # without the last mismatched samples
    
    #dot size 
    
    if( length(unique(tmplot$sampleID))< 100){DotSize = 1.5}
    if( length(unique(tmplot$sampleID)) > 100 & length(unique(tmplot$sampleID))< 200 ){DotSize = 0.3}
    if( length(unique(tmplot$sampleID)) >= 200){DotSize = 0.05}
    
    
    pMATCH = tmplot %>% ggplot(aes(y = geneExp, x = sampleID)) + 
        geom_point(aes(color = probeset,shape = probeset),size = DotSize) +
        theme_classic()+
        theme(panel.background = element_rect(colour = "black"),
              axis.text.x = element_text(size = 4)) +
        labs(title = i, x = "Samples(Predicted Gender)", y = "Expression (log2)") +
        scale_colour_manual(labels = c('KDM5D', 'RPS4Y1','XIST'),
                            values = c('black','black','red')) +
        scale_shape_manual(labels = c('KDM5D', 'RPS4Y1','XIST'),
                           values=c(20,1,20)) +
        scale_x_discrete(breaks = unique(tmplot$sampleID), labels= KmeanLable)+
        theme(panel.margin = unit(0, "lines"))
    
    if(length(MM)!=0){
        pMATCH = pMATCH +
            annotate("rect", xmin = c(0, MMafter),
                     xmax = c(MMfront, length(unique(tmplot$sampleID))+ 0.3), 
                     ymin = rep(-Inf, length(MM) + 1), 
                     ymax = rep(max(tmplot$geneExp) + 0.5, length(MM) + 1),
                     alpha = 0.6, color = NA, fill = "white") + 
            
            annotate("rect", xmin = MMfront, xmax = MMafter, 
                     ymin = rep(-Inf, length(MM)), 
                     ymax = rep(max(tmplot$geneExp) + 0.5,
                                length(MM)), alpha = 0.2) +
            
            annotate("rect", xmin=0, xmax=Inf, 
                     ymin=max(tmplot$geneExp) + 0.5, ymax=Inf, 
                     color = "black", fill = "white") +
            
            annotate("text", x = FcenterX, y = centerY,
                     label =  paste0("MetaFemale (n=", 
                                     sum(tmplot$G.check == "female")/8,")"), size = 4)+
            annotate("text", x = McenterX, y = centerY,
                     label =  paste0("MetaMale (n=", 
                                     sum(tmplot$G.check == "male")/8,")"), size = 4)+
            
            annotate("rect", xmin = 0, xmax = sum(tmplot$G.check == "female")/8+ 0.5, 
                     ymin = -Inf, ymax = Inf, color="black", fill=NA) 
        
    }   
    
    #add other rects
    pMATCH = pMATCH + annotate("rect", xmin=0, xmax=Inf, 
                               ymin=max(tmplot$geneExp) + 0.5, ymax=Inf, 
                               color="black", fill="white") +
        
        annotate("text", x = FcenterX, y = centerY,
                 label =  paste0("MetaFemale (n=", 
                                 sum(tmplot$G.check == "female")/8,")"), size = 4)+
        annotate("text", x = McenterX, y = centerY,
                 label =  paste0("MetaMale (n=", 
                                 sum(tmplot$G.check == "male")/8,")"), size = 4)+
        
        annotate("rect", xmin = 0, xmax = sum(tmplot$G.check == "female")/8+ 0.5, 
                 ymin = -Inf, ymax = Inf, color="black", fill=NA) 
    
    
    plot(pMATCH)
}
dev.off()

#---- 

#Heatmap for sample expression
# rearrange based the gender.

# pdf("./output/heatmap of disagree GPL96.97 7+1probes.pdf") 
# for (i in datasets) {
#     plotemp <- MERGE[,c(Female.probes, Male.probes)]%>% as.matrix
#     heatmap.2 (plotemp, margins = c(4, 4), 
#                las=1, main = i, 
#                dendrogram="none", trace="none", 
#                col=heat.colors(44), 
#                #labRow = XLAB, 
#                cexCol = 1, labRow = NULL, srtRow  = NULL,
#                keysize = 1.2,  key.title ="", srtCol = 90,
#                colCol = c(rep("red",6), rep("black",2)))
#     
#     legend("topright", cex=0.5,legend = c("male", "female"), 
#            col = c("black", "red"),lty= 1, lwd = 10  )
# }
# 
# dev.off()
# 








