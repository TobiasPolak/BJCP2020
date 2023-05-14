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
- Tobias B. Polak <sup>1,2,3,4,*</sup>
- Joost van Rosmalen <sup>1,2</sup>
- Carin A. Uyl - De Groot <sup>3</sup>

<sup>1</sup> Department of Biostatistics, Erasmus Medical Center, Rotterdam, The Netherlands

<sup>2</sup> Department of Epidemiology, Erasmus Medical Center, Rotterdam, The Netherlands

<sup>3</sup> Erasmus School of Health Policy & Management, Erasmus University Rotterdam, Rotterdam, The Netherlands

<sup>4</sup> Real-World Data Department, myTomorrows, Amsterdam, The Netherlands

<sup>*</sup> {Corresponding author: t.polak@erasmusmc.nl}

## Video
We created a YouTube video to explain our research.  

[![IMAGE ALT TEXT](http://img.youtube.com/vi/T9Qn5QZVe4o/0.jpg)](http://www.youtube.com/watch?v=T9Qn5QZVe4o "BJCP 2020")

## Grapical information
1. First, we downloaded all publicly available information from the FDA and EMA websites above. We then searched for any terms related to expanded access, such as compassionate use, expanded access, early access, pre-approval access, named patient, managed access. single-patient access, single-patient IND, etc. An excellent paper on all the confusing terminology can be found [here](https://journals.sagepub.com/doi/10.1177/2168479017696267?icid=int.sj-abstract.similar-articles.5).
2. We then searched through all these documents whether any of these terms appeared, only manually going through the documents with an expanded access terms. This graphic depicts our process:
![](https://github.com/TobiasPolak/BJCP2020/blob/master/Animations/GIF_1_Download.gif)
3. Now, we only had to look through the documents that contain an expanded access term:
![](https://github.com/TobiasPolak/BJCP2020/blob/master/Animations/GIF_2_Loop.gif)
4. Unfortunately, some of the documents could not be scanned directly, as they contained blurred images rather than readible text. You then run into the following issue:
![](https://github.com/TobiasPolak/BJCP2020/blob/master/Animations/GIF_4_OCR.gif)
5. We have to peform a technique called OCR. OCR (OCR stands for "Optical Character Recognition"). It is a technology used to convert scanned images of text into editable, searchable and machine-readable text, according to CHATGPT). Therefore, you first have to run the OCR and subsequently search for expanded access terms. The code to run this is also available in the folders. This process would look as follows:

5. We could now finally divide our work into expanded access use for (i) not-efficacy data (e.g. safety, trivial) or (ii) efficacy. We further divided efficacy into (i) supportive and (ii) pivotal, based on the sections provided in the assessment reports by the regulatory agencies. 

![](https://github.com/TobiasPolak/BJCP2020/blob/master/Animations/BucketGIF_1%20(1)%20(1).gif)

## Results
Now that we have shown you our methodology, please read the paper to find out the results! We recently updated the results (not peer-reviewed) and these are depicted in the animation below:
![](https://github.com/TobiasPolak/BJCP2020/blob/master/Animations/BarChart2.gif)

## Acknowledgements
We thank David Cucchi, Noor Gieles, and Simon de Wijs for extensive proofreading. 

## Competing Interests
Tobias Polak is a member of the NYU Grossmann School of Medicine Ethics and Real-World Evidence (ERWE) Working Group. Tobias Polak works part-time for expanded access service provider myTomorrows, in which he holds stock and stock options (< 0.01%). He is contractually free to publish and the service provider is not involved in any of his past or ongoing research, nor in this work. Tobias Polak receives research support from the Dutch Ministry of Economic Affairs and Climate Policy (HealthHolland). Tobias Polak has received a Prins Bernhard Cultuurfonds Prijs for travel expenses to New York City. Joost van Rosmalen declares no conflict
of interest. Carin Uyl-de Groot has received unrestricted grants from Boehringer Ingelheim, Astellas, Celgene, Sanofi, Janssen-Cilag, Bayer, mgen, Genzyme, Merck, Glycostem Therapeutics, Astra Zeneca, oche and Merck.


