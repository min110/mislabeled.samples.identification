#strip plot 

pdf("./output/gene expression plot for each dataset.pdf")

for(i in datasets){
    tmplot <- GPL570.PRBPLOT %>% 
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
        geom_point(aes(color = probeset, shape = probeset),size = DotSize) +
        theme_classic()+
        theme(panel.background = element_rect(colour = "black"),
              axis.text.x = element_text(size = 4)) +
        labs(title = paste0("GPL570-",i), x = "Samples(Predicted Gender)", y = "Expression (log2)") +
        
        scale_shape_manual(labels = c('KDM5D', 'RPS4Y1','XIST'),
                           values=c(20,1,20)) +
        scale_colour_manual(labels = c('KDM5D', 'RPS4Y1','XIST'),
                            values = c('black','black','red')) +
        
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

for(i in datasets){
        tmplot <- GPL96.97.PRBPLOT %>% 
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
            labs(title = paste0("GPL96.97-",i), x = "Samples(Predicted Gender)", y = "Expression (log2)") +
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

for(i in datasets){
    tmplot <- GPL96.PRBPLOT %>% 
        mutate(KMplot = G.kmean) %>% 
        arrange(G.check) %>% 
        filter(dataset == i)
    
    tmplot$sampleID <- factor(tmplot$sampleID, 
                              levels = unique(as.character(tmplot$sampleID)))
    
    # get the position of annotation rect
    
    FcenterX = sum(tmplot$G.check == "female")/8
    McenterX = sum(tmplot$G.check == "female")/4 + sum(tmplot$G.check == "male")/8 + 0.5
    
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
        labs(title = paste0("GPL96-",i), x = "Samples(Predicted Gender)", y = "Expression (log2)") +
        
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
                                     sum(tmplot$G.check == "female")/4, ")"), size = 4)+
            annotate("text", x = McenterX, y = centerY,
                     label =  paste0("MetaMale (n=", 
                                     sum(tmplot$G.check == "male")/4,")"), size = 4)+
            
            annotate("rect", xmin = 0, xmax = sum(tmplot$G.check == "female")/4+ 0.5, 
                     ymin = -Inf, ymax = Inf, color="black", fill=NA) 
        
    }   
    
    #add other rects
    pMATCH = pMATCH + annotate("rect", xmin=0, xmax=Inf, 
                               ymin=max(tmplot$geneExp) + 0.5, ymax=Inf, 
                               color="black", fill="white") +
        
        annotate("text", x = FcenterX, y = centerY,
                 label =  paste0("MetaFemale (n=", 
                                 sum(tmplot$G.check == "female")/4,")"), size = 4)+
        annotate("text", x = McenterX, y = centerY,
                 label =  paste0("MetaMale (n=", 
                                 sum(tmplot$G.check == "male")/4,")"), size = 4)+
        
        annotate("rect", xmin = 0, xmax = sum(tmplot$G.check == "female")/4+ 0.5, 
                 ymin = -Inf, ymax = Inf, color="black", fill=NA) 
    
    
    plot(pMATCH)
    
}

dev.off()