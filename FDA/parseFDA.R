# 1. Installing and loading packages

rm(list=ls())
packages <-
  list(
    'gsheet',
    'urltools',
    'RCurl',
    'stringr',
    'rvest',
    'XML',
    'readxl',
    'stringr',
    'dplyr',
    'parsedate',
    'gt',
    'gtsummary',
    'gridExtra',
    'ggpubr',
    'ggforce',
    'glue',
    'lubridate',
    'knitr',
    'hrbrthemes',
    'ggthemes',
    'naniar',
    'flextable',
    'ggsci'
  )


lapply(packages, require, character.only = TRUE)
theme_gtsummary_language("en", big.mark = "")

`%notin%` <- Negate(`%in%`)

dataFDAcfm <- as.data.frame(read_xlsx("C:\\Users\\31612\\Documents\\R\\BJCP2020\\Data\\FDA.xlsx", sheet=2))
dataFDAcfm <- dataFDAcfm[grepl('.cfm', dataFDAcfm$ApplicationDocsURL),]
# dataFDAcfm <- dataFDAcfm[grep('/2017/|/2018/|/2019/|/2020/|/2021/|/2022/', dataFDAcfm$ApplicationDocsURL),]
sel2019 <- dataFDAcfm[grep('/2019/', dataFDAcfm$ApplicationDocsURL),]
dataFDAcfm$error <- 0 
dataFDAcfm$docs <- 0 

dataFDAcfm$yearsparse <- gsub('.*nda/','',  dataFDAcfm$ApplicationDocsURL)

cols <- c('nda', 'medicine', 'pageurl',  'doctitle', 'url', 'info')
pdf_url_matrix <- matrix(data = 0, nrow=1, ncol=length(cols))
colnames(pdf_url_matrix) <- cols

error <- 0 

for (i in 1:nrow(dataFDAcfm)){ 
  print(i)
  nda = dataFDAcfm$ApplNo[i] 

    url <- as.matrix(dataFDAcfm$ApplicationDocsURL[i])
  if (grepl(' ', url)){
    cat('Whitespace in URL')
    url <- gsub(" ", "%", url)
  }
  
  tryURL <-  tryCatch(web_info <- read_html(url, encoding = "UTF-8"), error = function(e){"empty page"}) 
  if (tryURL == 'empty page'){
    print(tryURL)
    error = error + 1
    dataFDAcfm$error[i] <- 1
    next
  }
  
  pagenotfound <- grepl('Page Not Found', web_info)
  if (pagenotfound){
    dataFDAcfm$error[i] <- 99
    next
  }
  
  Medicine <- html_nodes(web_info, xpath= '/html/body/div[2]/div/main/article/header/section/div/h1') %>% html_text()
  if (length(Medicine) == 0 ){
    r <- web_info %>% html_nodes('title') 
    Medicine <- r[1] %>% html_text()
  }
  html_nodes(web_info, xpath= '/html/body/div[2]/div/main/article/header/section/div/h1') %>% html_text()
  
  cat('Iteration: ', i,' Document: ', Medicine, ' Percentage: ', round(i/nrow(dataFDAcfm)*100,1), '%')
  
  html_hrefnodes <- web_info %>% html_nodes('li')
  rawpdfs <- html_hrefnodes[grepl('.pdf', html_hrefnodes)] 
  doctitle <- rawpdfs %>% html_text()
  docurl <- rawpdfs %>% html_nodes('a') %>% html_attr('href')
  temppdf <- cbind(doctitle, docurl)
  dataFDAcfm$docs[i] <- nrow(temppdf) 
  
  
  infoparse <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[1]/div[1]/div/div') %>% html_text()
  if (length(infoparse)  == 0){
    infoparse <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[2]/div[1]/div/div') %>% html_text()
    if (length(infoparse)  == 0){
      infoparse <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/h3') %>% html_text()
      if (length(infoparse)  == 0){
        infoparse <- html_nodes(web_info, xpath= ' //*[@id="user_provided"]/h2') %>% html_text()
        if (length(infoparse)  == 0){
          infoparse <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/strong') %>% html_text()
          if (length(infoparse) == 0){
            infoparse <- html_nodes(web_info, xpath= '//*[@id="user_provided"]/table/tbody/tr/td/h2') %>% html_text()
            if (length(infoparse) == 0){
              infoparse <- html_nodes(web_info, xpath= '//*[@id="user_provided"]/big') %>% html_text()
              if (length(infoparse) == 0){
                infoparse <- html_nodes(web_info, xpath= '//*[@id="user_provided"]/p[1]') %>% html_text()
                
                if (length(infoparse) == 0){
                  infoparse <- html_nodes(web_info, xpath= '//*[@id="user_provided"]/h3') %>% html_text()
                }
                }
              }
          }
        }
      }
    } 
  }
  infostring <- gsub("[\r\n]", "", infoparse)
  info <- gsub("    ", "", infostring)
  
  finalpdf <- cbind(
        nda = rep(nda, nrow(temppdf)),
        medicine = rep(Medicine, nrow(temppdf)), 
        pageurl = rep(url, nrow(temppdf)),
        temppdf,
        info = rep(info, nrow(temppdf)))
  

  pdf_url_matrix <- rbind(pdf_url_matrix, finalpdf)
}  

write.csv2(pdf_url_matrix, 'docsFDA_all.csv')
write.csv2(dataFDAcfm,  'dataFDAcfm_all.csv')
closeAllConnections()


### Parse Approval Dates
## Remove REMS etc. Remove error 99. Inspect other errors.
