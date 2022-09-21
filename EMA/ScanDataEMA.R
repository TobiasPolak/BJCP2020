#1. Installing and loading packages

source("C:\\Users\\31612\\Documents\\R\\BJCP2020\\01LoadInstall.R", encoding = 'UTF-8')
setwd("C:\\Users\\31612\\Documents\\R\\BJCP2020\\EMA\\")

dataEMA <- read.csv2('dataEMA.csv')
dataEMA$terms <- 0 
docsEMA <- read.csv2('docsEMA.csv')

resultEMA <- matrix(nrow=1, ncol = 5, data = 0)
colnames(resultEMA) <-   c('Medicine', 'url', 'page', 'word', 'context')

for (doc in 1:nrow(docsEMA)) {
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
  
  filecheck <- try(tempEMA <- pdf_text(destfileEMA))
  if (class(filecheck) == "try-error") {
    docsEMA$readerror[doc] <- 1
    print('Error Parse')
    next
  } else {
  }
  pagenumbers <- pdf_info(destfileEMA)$pages
  docsEMA$pagenumbers[doc] <- pagenumbers
  for (word in words) {
    a <- grepl(word, tempEMA, ignore.case = TRUE)
    pages <- which(a)
    
    if (sum(a) > 0) {
      
      cat('Found an item! ', word,  doc, docsEMA$Medicine[doc], url)
        docsEMA$EAP[doc] <- docsEMA$EAP[doc] + 1
        dataEMA$terms[which(dataEMA$Medicine.name == Medicine)] <- dataEMA$terms[which(dataEMA$Medicine.name == Medicine)] + 1
      for (page in pages) {
        lines <- read_lines(tempEMA[page])
        indices <-  grep(word, lines, ignore.case = TRUE)
        for (index in 1:length(indices)) {
          context <-
            lines[min(max(indices[index] - 2, 0), indices[index]):min(indices[index] + 2, length(lines))] ## select 2 lines before and after
          resultEMA.ind <- as.data.frame(matrix(data=0, nrow = 1, ncol = ncol(resultEMA)))
          colnames(resultEMA.ind) <- colnames(resultEMA)
          context <-
            toString(apply(t(context) , 1, paste, collapse = " "))
          resultEMA.ind[1,] <- c(docsEMA$Medicine[doc],
                                 url,
                                 page,
                                 word,
                                 context)
          
        }
        resultEMA <- rbind(resultEMA, resultEMA.ind)
      }
    } else{
      
    }
  }
  unlink(destfileEMA)
  unlink(tempEMA)
}
write.csv2(docsEMA, paste0(Sys.Date(), 'docsEMA.csv'))
write.csv2(resultEMA, paste0(Sys.Date(),'resultEMA.csv'))

write.csv2(dataEMA, paste0(Sys.Date(),'dataEMA.csv'))
