[![DOI](https://zenodo.org/badge/23905/min110/mislabeled.samples.identification.svg)](https://zenodo.org/badge/latestdoi/23905/min110/mislabeled.samples.identification)


# Metadata Evaluation -- Identification of Mislabeled Samples with Gender Indicator

## Comparison between Genetic gender and Annotation gender
## 2016
---

## Description of the project

* ### DATA: 
    * **.RData** includes two dataframes: **dat** which is gene expression data and **sampleMetadata** which is the metadata obtained from Gemma
    * we have data from three human platforms 
        * GPL570: humanGender-GPL570.txt.RData
        * GPL96: humanGender-GPL96.txt.RData
        * GPL96combined with GPL97: humanGender-GPL96-GPL97.txt.RData
    
* ### PROCESS:
    1. Get gender annotions. 
    2. Based on kmean of three gender related genes, get the biologicle gender of each sample
    3. Identify samples with missmatch between the biological gender and the annotated gender
    4. Closely checking the list through publications, record the cases where GEO metadata is inconsistent with paper
   
* ### ABBREVATION: 
    * GPL96.97: GPL96 combined with GPL97
    * G for gender 
    * DF for dataframe 
    * DS for dataset  
    * SP for sample

---

## How to replicate my analysis

All the scripts can be found in [this repo](https://github.com/min110/mislabeled.samples.identification/tree/master/Rscripts), in which three seperated scripts (GPL570.R , GPL96.R and GPL96.97.R ) are prepared for the three platforms we included in this project.

Running these three scripts one by one will perform the analysis for each of the platforms seperately. The whole process includes:

1. Loading custom functions and input data
2. Data preprocessing and anaylsis (identify genetic gender by clustering gender specific genes and clearify annotation gender)
3. Saving 3 outputs files including 2 pdf files and 1 csv file. Details are offered below in example:

**I.E.:for identifying mislabeled samples in platform GPL570** 

**Scripts needed:** 

A script [GPL570.R ](https://github.com/min110/mislabeled.samples.identification/blob/master/Rscripts/GPL570.R): this is the frame script that performs the analysis for all the data from GPL570 platform. The script loads the required input data and calls another script - [custom functions](https://github.com/min110/mislabeled.samples.identification/blob/master/Rscripts/customFunction.R) which contains the functions required for the analysis

**Input Data**

[GPL570 expression data and metadata](https://github.com/min110/mislabeled.samples.identification/blob/master/inputDATA/humanGender-GPL570.txt.RData): These Data will be loaded automaticly when you run 'GPL570.R'

**Output files** 

[1. a pdf file](https://github.com/min110/mislabeled.samples.identification/blob/master/output/GPL570%20probesets%20COR.pdf) : a correlation heatmap of probesets in GPL570 to identify outlier probesets 

[2. a csv file](https://github.com/min110/mislabeled.samples.identification/blob/master/output/GPL570%20all%20inforamtion.csv): a table after analysis offering genetic gender and annotation gender for each sample

[3. another pdf file](https://github.com/min110/mislabeled.samples.identification/blob/master/output/GPL570%20gene%20expression%20plot%20for%20each%20dataset.pdf): visualization of the expression level of the probesets representing the gender genes used to calculate the biological gender ofthe sample. In these plots, the biological gender is shown on the x-axis, while the annotated gender (meta-gender) is indicated in the plot headers. Samples identified as "mismatched" are indicated by grey boxes
