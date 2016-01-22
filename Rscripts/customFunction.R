clean.EXP <- function (data, sort.rowName=T, sort.colNames=T,NAcol.rm=F,NArow.rm=T,Max=T)
{
    if(sort.rowName==T) 
        data<- data[sort(rownames(data)),]
    if (sort.colNames==T)
        data <- data[,order(names(data))]
    if (NAcol.rm==T)
        data.NA.rm <- data[colSums(is.na(data))== 0,]
    if (NArow.rm==T)
        data.NA.rm <- data[rowSums(is.na(data))== 0,]
    if(Max==T)
    {
        data.NA.rm$max<- apply(data.NA.rm,1,max)
        data.max<- data.NA.rm
        return(data.max)
    }
    else { return(data.NA.rm)}
    
} 


#function for merge metadata and expression data

merge.ROWname<-function(x,y,by.x="row.names",by.y="row.names",all=T){
    
    match<-identical(rownames(y),rownames(x))
    
    if (match==T){
        Merge<- merge(x,y,
                      by.x="row.names",by.y="row.names",all=T)
        rownames(Merge)<-Merge[[1]] 
        Merge <- Merge[,-1]
        return(Merge)
        
    }
    else{print("please match Rownames first")}
}

