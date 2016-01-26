#chech with the changes
GPL570.twoMales <- read.csv("/home/mfeng/mislabeled.samples.identification/mislabeled.samples.identification/output/GPL570.DIS.KMvsGEO.Sure disagrees samlpes after the rm .csv")
GPL570.OneMales <- read.csv("/home/mfeng/include.one.more.gene.DEC3/DEC3/GPL570.DIS.KMvsGEO.Sure disagrees samlpes after the rm .csv")
names(GPL570.OneMales)
 samples.OneMale <- GPL570.OneMales$sampleID
 samples.TwoMale <- GPL570.twoMales$sampleID
 increased.Mis.samples<- samples.TwoMale[-which( samples.OneMale %in% samples.TwoMale)]

GPL96.twoMales <- read.csv("/home/mfeng/mislabeled.samples.identification/mislabeled.samples.identification/output/GPL96.DIS.KMvsGEO.Sure disagrees samlpes after the rm .csv")
GPL96.twoMales.ALL <- read.csv("/home/mfeng/mislabeled.samples.identification/mislabeled.samples.identification/output/GPL96.KMEAN.RM all samples after remove KMvsMEDIAN.csv")
GPL96.OneMales <- read.csv("/home/mfeng/include.one.more.gene.DEC3/DEC3/GPL96.DIS.KMvsGEO.Sure disagrees samlpes after the rm .csv")
names(GPL96.OneMales)
samples.OneMale <- GPL96.OneMales$sampleID
samples.TwoMale <- GPL96.twoMales$sampleID
decreased.Mis.samples<- samples.OneMale[-which( samples.TwoMale %in% samples.OneMale)]
GPL96.twoMales.ALL[GPL96.twoMales.ALL$sampleID %in% decreased.Mis.samples,]
