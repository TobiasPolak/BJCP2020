# Expanded Access as a source of real-world data: An overview of FDA and EMA approvals
This repository contains the source code and data for the paper "Expanded Access as a source of real-world data: An overview of FDA and EMA approvals" that was published in the British Journal of Clinical Pharmacology. The link to the paper can be found [here](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7444779/). 

This repository contains two folders, one for analyzing the EMA an one for analyzing the FDA. The original datasources from the EMA and (in particular the FDA) can be challenging to unravel. Therefore, both subfolders contain additional code checks. Some of the documents contain pictures and stamps and cannot be analyzed directly. To that end, there is code to use OCR. Therefore, you first have to run the OCR and subsequently search for expanded access terms. 

## Citation
Please cite this work as: Polak, T. B., van Rosmalen, J., and Uyl – de Groot, C. A. (2020a). Expanded Access as a source of real‐world data: An overview of FDA and EMA approvals. Br. J. Clin. Pharmacol. 86, 1819–1826. doi:10.1111/bcp.14284.

# European Medicines Agency (EMA) Analysis
EMA data can be obtained via: https://www.ema.europa.eu/en/medicines/download-medicine-data.
Use EMA.R to run the analysis on the EMA dataset.

# Food and Drug Administration (FDA) Analysis.
First run the Scrapy.R code 
Running the FDA.R analysis includes an OCR step for older documents (see code). If you are only using recent drug approvals > 2015, there in principle is no need to run this piece of code. This severly impact computing time.   

## Note
- Make sure you have internet connection while running the script as it installs packages from CRAN.
- This script assumes that you have R and RStudio installed on your system.

## Authors
- Tobias B. Polak
- Joost van Rosmalen
- Carin A. Uyl - De Groot

---
title: my title
author:
- affiliation: group1
  name: 'Author1 Author2'
- affiliation: group2
  name: author2

address:
- address: abc
  code: group1
- address: b
  code: group2
---

## Grapical information
1. First, we downloaded all publicly available information from the FDA and EMA websites above. We then searched for any terms related to expanded access, such as compassionate use, expanded access, early access, pre-approval access, named patient, managed access. single-patient access, single-patient IND, etc. An excellent paper on all the confusing terminology can be found [here](https://journals.sagepub.com/doi/10.1177/2168479017696267?icid=int.sj-abstract.similar-articles.5):.
2. We then searched through all these documents whether any of these terms appeared, only manually going through the documents with an expanded access terms. This graphic depicts our process:

![](https://github.com/TobiasPolak/BJCP2020/blob/master/GIF1_Compressed%20(1).gif)

3. Unfortunately, some of the documents could not be scanned directly, as they contained blurred images rather than readible text. You then run into the following issue:

![](https://github.com/TobiasPolak/BJCP2020/blob/master/GIF4_Short_Compressed%20(1).gif)

6. We have to peform a technique called OCR. OCR (OCR stands for "Optical Character Recognition"). It is a technology used to convert scanned images of text into editable, searchable and machine-readable text, according to CHATGPT). Therefore, you first have to run the OCR and subsequently search for expanded access terms. The code to run this is also available in the folders. This process would look as follows:

![](https://github.com/TobiasPolak/BJCP2020/blob/master/GIF5.1_Compressed%20(1).gif)

7. We could now finally divide our work into expanded access use for (i) not-efficacy data (e.g. safety, trivial) or (ii) efficacy. We further divided efficacy into (i) supportive and (ii) pivotal, based on the sections provided in the assessment reports by the regulatory agencies. 

![](https://github.com/TobiasPolak/BJCP2020/blob/master/BucketGIF_1%20(1)%20(1).gif)

## Results

Now that we have shown you our methodology, please read the paper to find out the results!

