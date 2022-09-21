

#1. Installing and loading packages

source("C:\\Users\\31612\\Documents\\R\\BJCP2020\\01LoadInstall.R", encoding = 'UTF-8')
setwd("C:\\Users\\31612\\Documents\\R\\BJCP2020\\EMA\\")

dataEMA <- read.csv2('dataEMA.csv')
dataEMA$terms <- 0 
docsEMA <- read.csv2('docsEMA.csv')

resultEMAOCR <- matrix(nrow=1, ncol = 5, data = 0)
colnames(resultEMAOCR) <-   c('Medicine', 'url', 'page', 'word', 'context')

for (doc in 52:nrow(docsEMA)) {
  cat('Document: ', doc, ' Percentage:', round((doc) / nrow(docsEMA) * 100, 1), '% \n')
  Medicine <- docsEMA$Medicine[doc]
  url <- docsEMA$url[doc]
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
    docsEMA$downloaderror[doc] <- 1
    print('Error Download')
    next
  } else {
  }
  
  filecheck <- try(text <- ocr(pdf_convert('tempEMA.pdf', dpi = 200, format='png')))
  if (class(filecheck) == "try-error") {
    docsEMA$readerror[doc] <- 1
    print('Error Parse')
    next
  } else {
  }
  pagenumbers <- pdf_info(destfileEMA)$pages
  docsEMA$pagenumbers[doc] <- pagenumbers
  for (word in words) {
    a <- grepl(word, text, ignore.case = TRUE)
    pages <- which(a)
    
    if (sum(a) > 0) {
      
      cat('Found an item! ', word,  doc, docsEMA$Medicine[doc], url)
      docsEMA$EAP[doc] <- docsEMA$EAP[doc] + 1
      dataEMA$terms[which(dataEMA$Medicine.name == Medicine)] <- dataEMA$terms[which(dataEMA$Medicine.name == Medicine)] + 1
      for (page in pages) {
        lines <- read_lines(text[page])
        indices <-  grep(word, lines, ignore.case = TRUE)
        for (index in 1:length(indices)) {
          context <-
            lines[min(max(indices[index] - 2, 0), indices[index]):min(indices[index] + 2, length(lines))] ## select 2 lines before and after
          resultEMAOCR.ind <- as.data.frame(matrix(data=0, nrow = 1, ncol = ncol(resultEMAOCR)))
          colnames(resultEMAOCR.ind) <- colnames(resultEMAOCR)
          context <-
            toString(apply(t(context) , 1, paste, collapse = " "))
          resultEMAOCR.ind[1,] <- c(docsEMA$Medicine[doc],
                                 url,
                                 page,
                                 word,
                                 context)
          
        }
        resultEMAOCR <- rbind(resultEMAOCR, resultEMAOCR.ind)
      }
    } else{
      
    }
  }
  unlink(destfileEMA)
  unlink("*.png")
}
write.csv2(docsEMA, paste0(Sys.Date(), 'docsEMA.csv'))
write.csv2(resultEMAOCR, paste0(Sys.Date(),'resultEMA.csv'))

write.csv2(dataEMA, paste0(Sys.Date(),'dataEMA.csv'))
