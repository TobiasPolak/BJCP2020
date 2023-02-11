# Overview of FDA and EMA Approvals Using Real-World Data from Expanded Access Programs
This repository contains the source code and data for the paper "Expanded Access as a source of real-world data: An overview of FDA and EMA approvals" that was published in the British Journal of Clinical Pharmacology.

This repository contains the following scripts for the calculation of the Power Prior Propensity and the Simulation study conducted as part of said manuscript. 

1. [01LoadInstall.R](https://github.com/TobiasPolak/powerprioreap/01LoadInstall.R) - Script to load and install necessary packages
2. [02DataSimulation.R](https://github.com/TobiasPolak/powerprioreap/02DataSimulation.R) - Script to simulate data
3. [03Estimation.R](https://github.com/TobiasPolak/powerprioreap/03Estimation.R) - Script to estimate parameters
4. [04Simulation.R](https://github.com/TobiasPolak/powerprioreap/04Simulation.R) - Script to perform simulations
5. [05RunAnalysis.R](https://github.com/TobiasPolak/powerprioreap/05RunAnalysis.R) - Script to run final analysis to compare methods for the manuscript.


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
