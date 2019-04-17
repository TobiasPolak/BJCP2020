# Installing and loading packages
packages <- list('pdftools', 'RCurl', 'stringr', 'readxl')

for (package in packages){
  install.packages(package)
}
library(RCurl)
library(readxl)
library(pdftools)
library(stringr)
# loading dataframe

'%ni%' <- Negate('%in%')

ApplicationsDocsType_Lookup <- read.delim("/Users/tobiaspolak/Downloads/drugsatfda/ApplicationsDocsType_Lookup.txt")
ApplicationDocs <- read.delim("/Users/tobiaspolak/Downloads/drugsatfda/ApplicationDocs.txt")
Applications <- read.delim("/Users/tobiaspolak/Downloads/drugsatfda/Applications.txt")
Products <- read.delim("/Users/tobiaspolak/Downloads/drugsatfda/Products.txt")

View(summary(Products))
file.choose()

#Products have an Application Number. Applications have (multiple) ApplicationDocs.
# ApplicationsDocsType_Lookup contains the interesting applications: 
# 2 - Label, 3 - Review, 21 - Summary Review

summary(Applications$ApplType)
summary(ApplicationDocs$ApplicationDocsTypeID)

length(unique(Products$DrugName))
# 7244 unique drugs

length(ApplicationDocs$ApplicationDocsID)
# 56459 application documents

length(ApplicationDocs$ApplicationDocsID[which(ApplicationDocs$ApplicationDocsTypeID==2 | ApplicationDocs$ApplicationDocsTypeID==3 | ApplicationDocs$ApplicationDocsTypeID==21 )])
# Applicationdoctype = 2 => 19611 documents
# Applicationdoctype = 3 => 6413 documents
# Applicationdoctype = 21 => 744 documents
# Total of 26768 documents

# Select all Applicationdocuments with these 3 documentTypes.
drug_applications <- ApplicationDocs[which(ApplicationDocs$ApplicationDocsTypeID==2 | ApplicationDocs$ApplicationDocsTypeID==3 | ApplicationDocs$ApplicationDocsTypeID==21 ), ]
#drug_applications <- drug_applications[which(drug_applications$ApplNo==208700),]

(Products$ApplNo[4])

items <- list('compassionate', 'expanded access', 'early access', 'named-patient')
for (term in items){
drug_applications[,term] <- NA
}


for (i in 800:length(drug_applications$ApplicationDocsID)){
  drug_url <- as.matrix(drug_applications$ApplicationDocsURL[i])
  
  
  try({download.file(drug_url, 'destfile.txt') 
    text <- pdf_text('destfile.txt')}) 
  for (word in items){ 
    if (sum (grepl(word, text)) > 0){ 
      drug_applications[i,word] <- 'TRUE' 
      print('TRUE')
      {break}
    }else{ 
      drug_applications[i, word] <- 'FALSE' 
      print("FALSE")
    } 
    unlink('destfile.txt') 
  } 
  print(i)
} 

  
drug_url <- 'http://www.accessdata.fda.gov/drugsatfda_docs/label/2018/208700s000lbl.pdf'





length(unique(drug_applications$ApplNo))
# 26768 submissions regarding 4917 application numbers

appli <- Applications[which(Applications$ApplNo %in% applno_docs),]
appli <- Applicatiosn

drugs <- Applications[unique(drug_applications$ApplNo),]
length(unique(drugs$ApplNo))
length(unique(Applications$ApplNo))

product_application <- merge(appli, Products, by = 'ApplNo')
product_application_docs <- merge(product_application, ApplicationDocs, by = 'ApplNo')

dim(merge(appli, Products, all= FALSE))
