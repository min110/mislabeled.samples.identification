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

All the Scripts could be found in [this repo](https://github.com/min110/mislabeled.samples.identification/tree/master/Rscripts), in which three seperated scripts (GPL570.R , GPL96.R and GPL96.97.R ) are prepared for the three platforms we included in this project.

Running these three scripts one by one will do the analysis for each of the platforms seperately. The whole process includes:

1. Loading custom functions and input data
2. Data preprocessing and anaylsis (identify genetic gender by clustering gender specific genes and clearify annotation gender)
3. Saving 3 outputs files including 2 pdf files and 1 csv file. Details are offered below in example:

**I.E.:for identifying mislabeled samples in platform GPL570** 

**Direct Input:** 

[script GPL570.R need to be run](https://github.com/min110/mislabeled.samples.identification/blob/master/Rscripts/GPL570.R)

**Indirect Input**(run "GPL570.R" will call the following script or load the data automaticlly):

[cunstom functions](https://github.com/min110/mislabeled.samples.identification/blob/master/Rscripts/customFunction.R)

[input data](https://github.com/min110/mislabeled.samples.identification/blob/master/inputDATA/humanGender-GPL570.txt.RData)

**Output** in [this repo](https://github.com/min110/mislabeled.samples.identification/tree/master/output)

[1. a correlation heatmap of probesets in GPL570 to identify outlier probesets](https://github.com/min110/mislabeled.samples.identification/blob/master/output/GPL570%20probesets%20COR.pdf)

[2. a table after analysis including genetic gender and annotation gender for each sample](https://github.com/min110/mislabeled.samples.identification/blob/master/output/GPL570%20all%20inforamtion.csv)

[3. gene expression plot in which using genetic gender as x-label meanwhile using annotation gender as headers, besides all mislabeld samples are highlighted with grey bar](https://github.com/min110/mislabeled.samples.identification/blob/master/output/GPL570%20gene%20expression%20plot%20for%20each%20dataset.pdf)
