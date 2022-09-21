source("C:\\Users\\31612\\Documents\\R\\BJCP2020\\01LoadInstall.R", encoding = 'UTF-8')
setwd("C:\\Users\\31612\\Documents\\R\\BJCP2020\\FDA\\")

dataFDA <- read.csv2("C:\\Users\\31612\\Documents\\R\\BJCP2020\\FDA\\docsFDA_all.csv")
dataFDA <- dataFDA[grep('/2017|/2018|/2019|/2020|/2021|/2022', dataFDA$info),]
dataFDA <- dataFDA[grep('Approval', ignore.case = TRUE, dataFDA$info),]

resultFDA <- as.data.frame(matrix(0, nrow = 1, ncol = 6))
colnames(resultFDA) <-
  c('nda', 'doc', 'url', 'page', 'term', 'context')

dataFDA$readerror <- 0
dataFDA$downloaderror <- 0
dataFDA$pagenumbers <- 0
dataFDA$EAP <- 0 
dataFDA$docurl <- NULL
for (i in 1:nrow(dataFDA)){
  dataFDA$docurl[i] <- paste0(gsub(basename(dataFDA$pageurl[i]),'', dataFDA$pageurl[i]), dataFDA$url[i])
}
for (doc in 1:nrow(dataFDA)) {
  cat('Document: ', doc, ' Percentage:', round((doc) / nrow(dataFDA) * 100, 1), '% \n')
  url <- dataFDA$docurl[doc]
  ### Download the document
  downloadcheck <- try({
    destfile <- "temp.pdf"
    download.file(
      url = url,
      destfile = destfile,
      mode = 'wb',
      verbose = F,
      quiet = T
    )
    
  })
  if (class(downloadcheck) == "try-error") {
    dataFDA$downloaderror[doc] <- 1
    print('Error Download')
    next
  } else {
  }
  
  filecheck <- try(temp <- pdf_text(destfile))
  if (class(filecheck) == "try-error") {
    dataFDA$readerror[doc] <- 1
    print('Error Parse')
    next
  } else {
  }
  pagenumbers <- pdf_info(destfile)$pages
  dataFDA$pagenumbers[doc] <- pagenumbers
  for (word in words) {
    a <- grepl(word, temp, ignore.case = TRUE)
    pages <- which(a)
    
    if (sum(a) > 0) {
      cat('Found an item! ', word,  doc, url)
      for (page in pages) {
        lines <- read_lines(temp[page])
        indices <-  grep(word, lines, ignore.case = TRUE)
        for (index in 1:length(indices)) {
          context <-
            lines[min(max(indices[index] - 2, 0), indices[index]):min(indices[index] + 2, length(lines))] ## select 2 lines before and after
          resultFDA.ind <- as.data.frame(matrix(0, nrow = 1, ncol = ncol(resultFDA)))
          colnames(resultFDA.ind) <- colnames(resultFDA)
          resultFDA.ind[1,] <- c(dataFDA$nda[doc],
                                 dataFDA$doctitle[doc],
                                 url,
                                 page,
                                 word,
                                 context)
          context <-
            toString(apply(t(context) , 1, paste, collapse = " "))
          dataFDA$EAP[doc] <- dataFDA$EAP[doc] + 1
        }
        resultFDA <- rbind(resultFDA, resultFDA.ind)
      }
    } else{
      
    }
  }
  unlink(destfile)
  rm(temp)
  storedata <- dataFDA
}
closeAllConnections()
date <- Sys.Date()
write.csv2(resultFDA, paste0(date, 'resultFDA.csv'))
