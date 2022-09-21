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

peddocsEMA <- matrix(nrow=1, ncol=2, data = 0)
colnames(peddocsEMA) <- c('Medicine', 'url')
peddocsEMA <- as.data.frame(peddocsEMA)
dataEMA$docs <- 0

pedsurl <- matrix(nrow=1, ncol=2, data = 0)
colnames(pedsurl) <- c('Medicine', 'url')


for (doc in 1:nrow(dataEMA)){
  print(doc/nrow(dataEMA))
  url <- dataEMA$URL[doc]
  web_info <- read_html(url)
  web_info <- read_html(url, encoding = "UTF-8") %>% html_nodes('a') %>% html_attr('href')
  peds <- web_info[grepl('paediatric-investigation', ignore.case=TRUE, web_info)]
  if (length(peds) < 1){
    next 
  }
  peds[!grepl('https', peds)] <- paste0('https://www.ema.europa.eu/en', peds[!grepl('https', peds)] )
  peds <- as.data.frame(peds)
  peds_matrix <- cbind(rep(dataEMA$`Medicine name`[doc], nrow(peds)),  peds )
  colnames(peds_matrix) <- colnames(pedsurl)
  pedsurl <- rbind(pedsurl, peds_matrix)
}

write.csv2(pedsurl, '2017pedsurl.csv')

pedsurl <- read.csv2('2017pedsurl.csv')
pedsurl <- as.data.frame(pedsurl)
pedpeddocsEMA <- matrix(nrow=1, ncol=2, data = 0)
colnames(pedpeddocsEMA) <- c('Medicine', 'url')

if (sum(pedsurl$Medicine == 0) > 0){
pedsurl <- pedsurl[-which(pedsurl$Medicine == 0),]
}
is (sum(grepl('pdf', pedsurl$url))> 0 ) {
  pedsurl <- pedsurl[!grepl('pdf', pedsurl$url),]
}

for (doc in 1:nrow(pedsurl)){
  cat('Document: ', doc, ' Percentage:', round((doc) / nrow(pedsurl) * 100, 1), '% \n')
  
  url <- pedsurl$url[doc]
  web_info <- read_html(url)
  web_info <- read_html(url, encoding = "UTF-8") %>% html_nodes('a') %>% html_attr('href')
  web_pdfs <- web_info[grepl('.pdf', web_info)] 
  pdf_matrix <- as.data.frame(web_pdfs)
  if (nrow(pdf_matrix) == 0){
    cat('Error')
  }
  pdf_matrix <- cbind(rep(pedsurl$Medicine[doc], nrow(pdf_matrix)), pdf_matrix)
  pdf_matrix <- as.data.frame(pdf_matrix)
  dataEMA$docs[doc] <- nrow(pdf_matrix)
  colnames(pdf_matrix) <- colnames(pedpeddocsEMA)
  pedpeddocsEMA <- rbind(pedpeddocsEMA, pdf_matrix)
  
}

write.csv2(peddocsEMA, 'pedpeddocsEMA.csv')


resultpedEMA <- matrix(nrow=1, ncol = 5, data = 0)
colnames(resultpedEMA) <-   c('Medicine', 'url', 'page', 'word', 'context')

for (doc in 1:nrow(peddocsEMA)) {
  cat('Document: ', doc, ' Percentage:', round((doc) / nrow(peddocsEMA) * 100, 1), '% \n')
  Medicine <- peddocsEMA$Medicine[doc]
  url <- peddocsEMA$url[doc]
  ### Download the document
  downloadcheck <- try({
    destfileEMA <- "tempEMA.pdf"
    download.file(
      url = url,
      destfile = destfileEMA,
      mode = 'wb',
      verbose = F,
      quiet = T
    )
    
  })
  if (class(downloadcheck) == "try-error") {
    peddocsEMA$downloaderror[doc] <- 1
    print('Error Download')
    next
  } else {
  }
  
  filecheck <- try(tempEMA <- pdf_text(destfileEMA))
  if (class(filecheck) == "try-error") {
    peddocsEMA$readerror[doc] <- 1
    print('Error Parse')
    next
  } else {
  }
  pagenumbers <- pdf_info(destfileEMA)$pages
  peddocsEMA$pagenumbers[doc] <- pagenumbers
  for (word in words) {
    a <- grepl(word, tempEMA, ignore.case = TRUE)
    pages <- which(a)
    
    if (sum(a) > 0) {
      
      cat('Found an item! ', word,  doc, peddocsEMA$Medicine[doc], url)
      peddocsEMA$EAP[doc] <- peddocsEMA$EAP[doc] + 1
      dataEMA$terms[which(dataEMA$Medicine.name == Medicine)] <- dataEMA$terms[which(dataEMA$Medicine.name == Medicine)] + 1
      for (page in pages) {
        lines <- read_lines(tempEMA[page])
        indices <-  grep(word, lines, ignore.case = TRUE)
        for (index in 1:length(indices)) {
          context <-
            lines[min(max(indices[index] - 2, 0), indices[index]):min(indices[index] + 2, length(lines))] ## select 2 lines before and after
          resultpedEMA.ind <- as.data.frame(matrix(data=0, nrow = 1, ncol = ncol(resultpedEMA)))
          colnames(resultpedEMA.ind) <- colnames(resultpedEMA)
          context <-
            toString(apply(t(context) , 1, paste, collapse = " "))
          resultpedEMA.ind[1,] <- c(peddocsEMA$Medicine[doc],
                                 url,
                                 page,
                                 word,
                                 context)
          
        }
        resultpedEMA <- rbind(resultpedEMA, resultpedEMA.ind)
      }
    } else{
      
    }
  }
  unlink(destfileEMA)
  unlink(tempEMA)
}
write.csv2(peddocsEMA, paste0(Sys.Date(), 'peddocsEMA.csv'))
write.csv2(resultpedEMA, paste0(Sys.Date(),'resultpedEMA.csv'))

write.csv2(dataEMA, paste0(Sys.Date(),'dataEMA.csv'))
