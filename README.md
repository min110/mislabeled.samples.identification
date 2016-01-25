# Metadata Evaluation with GenderIndictor
## Comparison between Genetic gender and Annotation gender
## 2016
---

## Description of the project
* ### DATA: 
    * **.RData** includes two dataframes: **dat** which is gene expression data and **sampleMetadata** which is the metadata got from Gemma 
    * we have data across three humane platforms 
        * GPL570: humanGender-GPL570.txt.RData
        * GPL96: humanGender-GPL96.txt.RData
        * GPL96combined with GPL97: humanGender-GPL96-GPL97.txt.RData
    
* ### PROCESS:
    1. Based on the gender annotion in GEO,fixed the metadata in Gemma
    2. Based on kmean of two gender related genes, got the biologicle gender
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
