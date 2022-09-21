# 1. Installing and loading packages

source("C:\\Users\\31612\\Documents\\R\\BJCP2020\\01LoadInstall.R", encoding = 'UTF-8')
setwd("C:\\Users\\31612\\Documents\\R\\BJCP2020\\EMA\\")

dataEMA <-
  as.data.frame(read_xlsx(
    "C:\\Users\\31612\\Documents\\R\\BJCP2020\\Data\\EMA.xlsx"
  ))
dataEMA$year <- year(dataEMA$`Marketing authorisation date`)
# Filter out on Year, non-veterinary products, and potentially withdrawn
dataEMA <- dataEMA[which(dataEMA$year > 2017), ]
dataEMA <- dataEMA[which(dataEMA$Category == 'Human'),]

docsEMA <- matrix(nrow=1, ncol=2, data = 0)
colnames(docsEMA) <- c('Medicine', 'url')
docsEMA <- as.data.frame(docsEMA)
dataEMA$docs <- 0

for (doc in 1:nrow(dataEMA)){
  cat('Document: ', doc, ' Percentage:', round((doc) / nrow(dataEMA) * 100, 1), '% \n')
  
  url <- dataEMA$URL[doc]
  web_info <- read_html(url)
  web_info <- read_html(url, encoding = "UTF-8") %>% html_nodes('a') %>% html_attr('href')
  web_pdfs <- web_info[grepl('_en.pdf', web_info)] 
  pdf_matrix <- as.data.frame(web_pdfs)
  if (nrow(pdf_matrix) == 0){
    cat('Error')
  }
  pdf_matrix <- cbind(rep(dataEMA$`Medicine name`[doc], nrow(pdf_matrix)), pdf_matrix)
  pdf_matrix <- as.data.frame(pdf_matrix)
  dataEMA$docs[doc] <- nrow(pdf_matrix)
  colnames(pdf_matrix) <- colnames(docsEMA)
  docsEMA <- rbind(docsEMA, pdf_matrix)
  
}
docsEMA$readerror <- 0
docsEMA$downloaderror <- 0
docsEMA$pagenumbers <- 0
docsEMA$EAP <- 0 
docsEMA$terms <- 0 
# sum(grepl('variation', ignore.case=TRUE, docsEMA$url))
# docsEMA <- docsEMA[grepl('variation', ignore.case=TRUE, docsEMA$url),]
write.csv2(docsEMA, 'docsEMA.csv')
write.csv2(dataEMA, 'dataEMA.csv')
