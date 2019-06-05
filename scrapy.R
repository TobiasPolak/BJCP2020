

install.packages('rvest')
install.packages('stringr')
library(dplyr)
library(rvest)
library(stringr)
library(xml2)
library(rvest)

page <- xml2::read_html("http://www.accessdata.fda.gov/drugsatfda_docs/nda/2014/204734Orig1s000TOC.cfm")

page %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset("MedR")        # get all the medical reviews (MedR)


# 1. Installing and loading packages
packages <- list('pdftools', 'RCurl', 'stringr', 'readxl','reshape', 'reshape2', 'dplyr', 'progress','tictoc', 'tesseract')
lapply(packages, require, character.only = TRUE)
lapply(packages, install.packages, character.only=TRUE)
eng <- tesseract("eng")

# 2. Downloading data and 
temp <- tempfile() # initialize temp

download.file("https://www.fda.gov/media/89850/download",temp) #download from drugs@FDA

ApplicationsDocsType_Lookup <- read.delim(unz(temp, 'ApplicationsDocsType_Lookup.txt'))
ApplicationDocs <- read.delim(unz(temp,'ApplicationDocs.txt'))
Applications <- read.delim(unz(temp,"Applications.txt"))
Products <- read.delim(unz(temp,"Products.txt"))
MarketingStatus <- read.delim(unz(temp, "MarketingStatus.txt"))
MarketingStatus_Lookup <- read.delim(unz(temp, "MarketingStatus_Lookup.txt"))

unlink(temp)


cat('number of all unique drug names: ', length(unique(Products$DrugName)), 
    '\nnumber of all unique application documents: ', length(ApplicationDocs$ApplicationDocsID),
    '\nnumber of all labels: ', sum(ApplicationDocs$ApplicationDocsTypeID==2),
    '\nnumber of all reviews: ', sum(ApplicationDocs$ApplicationDocsTypeID==3),
    '\nnumber of all summaries: ', sum(ApplicationDocs$ApplicationDocsTypeID==21))

# Applicationdoctype = 2 => 19611 documents
# Applicationdoctype = 3 => 6413 documents
# Applicationdoctype = 21 => 744 documents
# numer  7244 unique drugse

# Select all Products that have are Approved
Authorized <- MarketingStatus[MarketingStatus$MarketingStatusID ==1 | MarketingStatus$MarketingStatusID == 2,]
Authorized_Products <- merge(Authorized, Products)

# Select only ApplNo, Drug Name and Ingredient
Authorized_Products <- Authorized_Products[,c(1,7,8)]

# Aggregate by ApplNo
prod <- aggregate(Authorized_Products,by = list(Authorized_Products$ApplNo), FUN = last)
cat('unique Application Numbers for Authorized Products: ', length(prod$ApplNo))

# Select all .cfm documents from ApplicationDocs
ApplicationCFM <- drug_applications[grepl('.cfm', drug_applications$ApplicationDocsURL),]

# Select all .cfm documents from ApplicationDocs
ApplicationCFM <- drug_applications[grepl('.cfm', drug_applications$ApplicationDocsURL),]
cat('Applicationdocs total ', length(ApplicationDocs$ApplicationDocsID),  'drug_applications total: ', length(drug_applications$ApplicationDocsID), 'Total PDFs :', length(ApplicationDocs_pdf$ApplicationDocsID))

#data[which(data$ApplNo==208700),]
data <- merge(prod, ApplicationCFM, by = 'ApplNo')
orig <- data[which(data$SubmissionType=="ORIG      "),]

for (j in 1:2){
 url <- orig$ApplicationDocsURL[j] 
 page <- xml2::read_html(as.matrix(url))

 page_links <- html_nodes(page, 'a')
 page_attrs <- html_attr(page_links, "href")
 medical <- page_attrs[grepl('med', page_attrs, ignore.case=TRUE)]
 pdf <- str_subset(medical, '.pdf')
 
 items <- page %>%
   html_nodes("a") %>%       # find all links
   str_subset("Med") %>%        # get all the medical reviews (MedR)
   str_subset("pdf")
}

html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
items <- list('compassionate use', 'expanded access', 'early access', 'named-patient', 'pre-approval access')


page <- xml2::read_html("http://www.accessdata.fda.gov/drugsatfda_docs/nda/2014/204734Orig1s000TOC.cfm")

page %>%
  html_nodes("a") %>%       # find all links
  html_attr("href") %>%     # get the url
  str_subset("MedR")        # get all the medical reviews (MedR)

