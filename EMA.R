install.packages('pdftools', 'readxl', 'Rcurl')
install.packages('RCurl')
install.packages('stringr')
library(readxl)
library(pdftools)
library(RCurl)
library(stringr)

# LOADING THE DATA
drugs <- read_excel("/Users/tobiaspolak/Downloads/Medicines_output_european_public_assessment_reports.xlsx")

#removing all veterinary drugs and unauthorized drugs
drugs <- data[data$Category == 'Human',]
drugs <- drugs[drugs$`Authorisation status` == 'Authorised',]

#define the search terms
items <- list('compassionate', 'expanded access', 'early access', 'named-patient')

reportMatrix <- matrix(, nrow = nrow(drugs), ncol = length(items))
assessmentMatrix <- matrix(, nrow = nrow(drugs), ncol = length(items))
scienceMatrix <- matrix(, nrow = nrow(drugs), ncol = length(items))

colnames(reportMatrix) <- items
colnames(assessmentMatrix) <- items
colnames(scienceMatrix) <- items

assessment <- cbind(drugs$`Medicine name`, assessmentMatrix)
colnames(assessment)[1] <- 'Medicine Name'

report <- cbind(drugs$`Medicine name`, reportMatrix)
colnames(report)[1] <- 'Medicine Name'

science <- cbind(drugs$`Medicine name`, scienceMatrix)
colnames(report)[1] <- 'Medicine Name'


for (term in items){
  report[,term] <- 'blank'
  assessment[,term] <- 'blank'
}


cleanString <- function(x) {
  split <- strsplit(x, " \\(")
  x <- split[[1]][[1]]
  x <- str_replace_all(x," ","-")
  x <- tolower(x)
  return(x)
}

for (i in 1:length(drugs$`Medicine name`)){

  medicine <- drugs$`Medicine name`[i]
  medicine <- cleanString(medicine)
  number <- paste(i, medicine, sep = "\t")
  cat(number)
    
  drug_url1 = paste("https://www.ema.europa.eu/en/documents/product-information/",(medicine), sep = '') # + "-epar-public-assessment-report_en.pdf"
  drug_url = paste(drug_url1,"-epar-product-information_en.pdf", sep = '')
  
  if (url.exists(drug_url)){
    try({download.file(drug_url, 'destfile.txt')
      text <- pdf_text('destfile.txt')})
    for (word in items){
      if (sum (grepl(word, text)) > 0){
        report[i, word] <- 'Yes'
      }else{
        report[i, word] <- 'No'
      }
      unlink('destfile.txt')
    }
  } else{
    report[i,] <- 'ERROR'
    print(paste0("Report Error: ", drugs$`Medicine name`[i]))
  }
  
  drug_url1 = paste("https://www.ema.europa.eu/en/documents/assessment-report/",(medicine), sep = '') 
  drug_url = paste(drug_url1,"-epar-public-assessment-report_en.pdf", sep = '')
  
  if (url.exists(drug_url)){
    try({download.file(drug_url, 'destfile.txt')
      text <- pdf_text('destfile.txt')})
    for (word in items){
      if (sum (grepl(word, text)) > 0){
        print('yes')
        assessment[i, word] <- 'Yes'
      }else{
        print('no')
        assessment[i, word] <- 'No'
      }
      unlink('destfile.txt')
    }
  } else{
    assessment[i,] <- 'ERROR'
    print(paste0("Assessment Error: ", drugs$`Medicine name`[i]))
  }
  
  drug_url1 = paste('https://www.ema.europa.eu/en/documents/scientific-discussion/',(medicine), sep = '') 
  drug_url = paste(drug_url1,"-epar-scientific-discussion_en.pdf", sep = '')
  
  if (url.exists(drug_url)){
    try({download.file(drug_url, 'destfile.txt')
      text <- pdf_text('destfile.txt')})
    for (word in items){
      if (sum (grepl(word, text)) > 0){
        science[i, word] <- 'Yes'
      }else{
        science[i, word] <- 'No'
      }
      unlink('destfile.txt')
    }
  } else{
    science[i,] <- 'ERROR'
    print(paste0("Science Error: ", drugs$`Medicine name`[i]))
  }
}

write.table(science, 'scientific report.csv')
write.table(report, 'report report.csv')
write.table(assessment, 'assessment report.csv')
science[,1] <- drugs$`Medicine name`
report[,1] <- drugs$`Medicine name`
assessment[,1] <- drugs$`Medicine name`

write.table(results, 'results 16apr2019.csv')
logicalcheck <- matrix(NA,nrow=dim(results)[1], ncol = 1)
for (i in 1:dim(results)[1]){
  for (j in 1:dim(results)[2]){
    if (results[i,j] == 'Yes'){
      print(i)
      logicalcheck[i] <- "TRUE"
    }
  }
}
View(logicalcheck)

write.table(drugs$`Medicine name`[which(logicalcheck=='TRUE')],'drugslijst')

logical(a)

