# Overview of FDA and EMA Approvals Using Real-World Data from Expanded Access Programs
This repository contains the source code and data for the paper "Expanded Access as a source of real-world data: An overview of FDA and EMA approvals" that was published in the British Journal of Clinical Pharmacology. The link to the paper can be found [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7444779/). 

This repository contains two folders, one for analyzing the EMA an one for analyzing the FDA. The original datasources from the EMA and (in particular the FDA) can be challenging to unravel. Therefore, both subfolders contain additional code checks. Some of the documents contain pictures and stamps and cannot be analyzed directly. To that end, there is code to use OCR (OCR stands for "Optical Character Recognition". It is a technology used to convert scanned images of text into editable, searchable and machine-readable text, according to CHATGPT). Therefore, you first have to run the OCR and subsequently search for expanded access terms. 

# European Medicines Agency (EMA) Analysis
EMA data can be obtained via: https://www.ema.europa.eu/en/medicines/download-medicine-data.
Use EMA.R to run the analysis on the EMA dataset.

# Food and Drug Administration (FDA) Analysis.
First run the Scrapy.R code 
Running the FDA.R analysis includes an OCR step for older documents (see code). If you are only using recent drug approvals > 2015, there in principle is no need to run this piece of code. This severly impact computing time.   

## Citation
Please cite this work as : Polak, T. B., Rosmalen, J., and Uyl – de Groot, C. A. (2020a). Expanded Access as a source of real‐world data: An overview of FDA and EMA approvals. Br. J. Clin. Pharmacol. 86, 1819–1826. doi:10.1111/bcp.14284.

## Note

- Make sure you have internet connection while running the script as it installs packages from CRAN.
- This script assumes that you have R and RStudio installed on your system.

## Authors
- Tobias B. Polak
- Joost van Rosmalen
- Carin A. Uyl - De Groot

## Grapical information
1. First, we downloaded all publicly available information from the FDA and EMA websites above. We then searched for any terms related to expanded access, such as compassionate use, expanded access, early access, pre-approval access, named patient, managed access. single-patient access, single-patient IND, etc. A good paper on all the confusing terminology can be found [here](https://journals.sagepub.com/doi/10.1177/2168479017696267?icid=int.sj-abstract.similar-articles.5):.
2. We then searched through all these documents whether any of these terms appeared, only manually going through the documents with an expanded access terms. This graphic depicts our process:

![](https://github.com/TobiasPolak/BJCP2020/blob/master/GIF1_Compressed%20(1).gif)

3. Unfortunately, some of the documents could not be scanned directly, as they contained blurred images rather than readible text. You then run into the following issue:


![](https://github.com/TobiasPolak/BJCP2020/blob/master/GIF4_Short_Compressed%20(1).gif)

6. We have to peform a technique called OCR. OCR (OCR stands for "Optical Character Recognition"). It is a technology used to convert scanned images of text into editable, searchable and machine-readable text, according to CHATGPT). Therefore, you first have to run the OCR and subsequently search for expanded access terms. The code to run this is also available in the folders. This process would look as follows:

![](https://github.com/TobiasPolak/BJCP2020/blob/master/GIF5.1_Compressed%20(1).gif)

## Please cite the work by Kimberly et al. on the terminology of compassionate use as:
Kimberly LL, Beuttler MM, Shen M, Caplan AL, Bateman-House A. Pre-approval Access Terminology: A Cause for Confusion and a Danger to Patients. Therapeutic Innovation & Regulatory Science. 2017;51(4):494-500. doi:10.1177/2168479017696267

