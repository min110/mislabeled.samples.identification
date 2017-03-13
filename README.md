[![DOI](https://zenodo.org/badge/23905/min110/mislabeled.samples.identification.svg)](https://zenodo.org/badge/latestdoi/23905/min110/mislabeled.samples.identification)


# Metadata Evaluation -- Identification of Mislabeled Samples with Gender Indictor

## Comparison between Genetic gender and Annotation gender
## 2016
---

## Description of the project

* ### DATA: 
    * **.RData** includes two dataframes: **dat** which is gene expression data and **sampleMetadata** which is the metadata got from Gemma 
    * we have data across three human platforms 
        * GPL570: humanGender-GPL570.txt.RData
        * GPL96: humanGender-GPL96.txt.RData
        * GPL96combined with GPL97: humanGender-GPL96-GPL97.txt.RData
    
* ### PROCESS:
    1. Get the gender annotion in GEO, via the tool Gemma.
    2. Based on kmean of three gender related genes, got the biologicle gender
    3. Based on genetic gender, got a list of samples with disagreed GEO meta gender
    4. Closely checking the list through publications, record the cases where GEO metadata is inconsistent with paper
   
* ### ABBREVATION: 
    * GPL96.97: GPL96 combined with GPL97
    * G for gender 
    * DF for dataframe 
    * DS for dataset  
    * SP for sample

---

## How to replicate my analysis

All the Scripts needed for replication could be found in [this repo](mislabeled.samples.identification/Rscripts/), in which there are three seperated scripts (GPL570.R , GPL96.R, GPL96.97.R )prepared indivadually for the three platforms we included in this project. Running these three scripts one by one will do the relication including loading the custom functions and input data --> doing anaylsis --> saving the output plot into a pdf file in which the genetic gender and annotaion gender are labled with different colors meanwhile the mislabeld samples are highlighted with grey bar. 

**I.E.:for identifying mislabeled samples in platform GPL570** 

**Direct Input:** in "mislabeled.samples.identification/Rscripts/"
[script GPL570.R need to be run](mislabeled.samples.identification/Rscripts/GPL570.R)

**Indirect Input**(run the previous script will call the following script or load the data automaticlly):
[cunstom functions](mislabeled.samples.identification/Rscripts/customFunction.R)
[input data](mislabeled.samples.identification/inputDATA/humanGender-GPL570.txt.RData)

**Output** in "mislabeled.samples.identification/output/"
[1. gene expression plot in which mislabeld samples are highlighted with grey bar](mislabeled.samples.identification/output/GPL570 gene expression plot for each dataset.pdf)
[2. a correlation heatmap of probesets in this platform to identify outlier probesets ](mislabeled.samples.identification/output/GPL570 probesets COR.pdf)
[3. a table after analysis including genetic gender and annotation gender for each sample](mislabeled.samples.identification/output/GPL570 all inforamtion.csv)
