## 1. Installing and loading packages
## 2. Downloading data

# 1. Installing and loading packages
packages <- list('pdftools', 'RCurl', 'stringr', 'readxl','reshape', 'reshape2', 'pheatmap', 'dplyr', 'progress')
lapply(packages, require, character.only = TRUE)

# 2. Downloading data and 
temp <- tempfile() # initialize temp

download.file("https://www.fda.gov/downloads/Drugs/InformationOnDrugs/UCM527389.zip",temp) #download from drugs@FDA

ApplicationsDocsType_Lookup <- read.delim(unz(temp, 'ApplicationsDocsType_Lookup.txt'))
ApplicationDocs <- read.delim(unz(temp,'ApplicationDocs.txt'))
Applications <- read.delim(unz(temp,"Applications.txt"))
Products <- read.delim(unz(temp,"Products.txt"))
MarketingStatus <- read.delim(unz(temp, "MarketingStatus.txt"))
MarketingStatus_Lookup <- read.delim(unz(temp, "MarketingStatus_Lookup.txt"))

unlink(temp)


#Products have an Application Number. Applications have (multiple) ApplicationDocs.
# ApplicationsDocsType_Lookup contains the interesting applications: 
# 2 - Label, 3 - Review, 21 - Summary Review

cat('number of all unique drug names: ', length(unique(Products$DrugName)), 
    '\nnumber of all unique application documents: ', length(ApplicationDocs$ApplicationDocsID),
    '\nnumber of all labels: ', sum(ApplicationDocs$ApplicationDocsTypeID==2),
    '\nnumber of all reviews: ', sum(ApplicationDocs$ApplicationDocsTypeID==3),
    '\nnumber of all summaries: ', sum(ApplicationDocs$ApplicationDocsTypeID==21))

# Applicationdoctype = 2 => 19611 documents
# Applicationdoctype = 3 => 6413 documents
# Applicationdoctype = 21 => 744 documents
# numer  7244 unique drugse

drug_applications <- ApplicationDocs[which(ApplicationDocs$ApplicationDocsTypeID==2 | ApplicationDocs$ApplicationDocsTypeID==3 | ApplicationDocs$ApplicationDocsTypeID==21 ), ]
#drug_applications <- drug_applications[which(drug_applications$ApplNo==208700),] <- LUTATHERA


# Select all Products that have are Approved
Authorized <- MarketingStatus[MarketingStatus$MarketingStatusID ==1 | MarketingStatus$MarketingStatusID == 2,]
Authorized_Products <- merge(Authorized, Products)

# Select only ApplNo, Drug Name and Ingredient
Authorized_Products <- Authorized_Products[,c(1,7,8)]

# Aggregate by ApplNo
prod <- aggregate(Authorized_Products,by = list(Authorized_Products$ApplNo), FUN = first)
cat('unique Application Numbers for Authorized Products: ', length(prod$ApplNo))

# Select all .pdf documents from ApplicationDocs
ApplicationDocs_pdf <- drug_applications[grepl('.pdf', drug_applications$ApplicationDocsURL),]
cat('Applicationdocs total ', length(ApplicationDocs$ApplicationDocsID),  'drug_applications total: ', length(drug_applications$ApplicationDocsID), 'Total PDFs :', length(ApplicationDocs_pdf$ApplicationDocsID))

data[which(data$ApplNo==208700),]
data <- merge(prod, ApplicationDocs_pdf, by = 'ApplNo')
items <- list('compassionate use', 'expanded access', 'early access', 'named-patient', 'pre-approval access')

for (term in items){
data[,term] <- NA
}

pb <- progress_bar$new(
  format = " downloading [:bar] :percent eta: :eta",
  total = length(data$ApplNo), clear = FALSE, width= 150)

for (i in 19137:length(data$ApplicationDocsID)){
  
  drug_url <- as.matrix(data$ApplicationDocsURL[i])
  try({download.file(drug_url, 'destfile.txt') 
    text <- pdf_text('destfile.txt')}) 
  for (word in items){ 
    if (sum (grepl(word, text)) > 0){ 
      data[i,word] <- TRUE 
    }else{ 
      data[i, word] <- FALSE
    } 
    unlink('destfile.txt') 
  } 
  print(i)
} 

filename <- paste0('FDA_', Sys.time(), '.txt')
write.table(data, filename)

EA_data <- data[which(data$compassionate.use==TRUE | data$expanded.access==TRUE | data$early.access==TRUE | data$named.patient==TRUE | data$pre.approval.access == TRUE),]
EA_drugs <- list(unique(EA_data$DrugName))

filename <- paste0('FDA_drugs_', Sys.time(), '.txt')
write.table(EA_drugs, filename)

