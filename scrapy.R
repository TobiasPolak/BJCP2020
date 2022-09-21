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
dataFDAcfm$year <- year(dataFDAcfm$ApplicationDocsDate)
dataFDAcfm  <- dataFDAcfm[which(dataFDAcfm$year > 2018), ]
dataFDAcfm <- dataFDAcfm[grepl('.cfm', dataFDAcfm$ApplicationDocsURL),]

pdf_url_matrix <- matrix(nrow = 1, ncol = 3, data = 0)

for (i in 1:nrow(dataFDAcfm)){ 
  print(i)
  
  url <- as.matrix(dataFDAcfm$ApplicationDocsURL[i])
  f <- read_html(url)
  web_info <- read_html(url, encoding = "UTF-8")
  html_hrefnodes <- web_info %>% html_nodes('a') %>% html_attr('href')
  web_info %>% html_attrs('style')
  web_pdfs <- html_hrefnodes[grepl('.pdf', html_hrefnodes)] 

  Medicine <- html_nodes(web_info, xpath= '/html/body/div[2]/div/main/article/header/section/div/h1') %>% html_text()
  #Two sections
  
  #First Section "FDA  Approval Letter and Labeling"
  temptitle <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[3]/div[1]/div')  %>% html_nodes('strong') %>% html_text()
  temppdfs <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[3]/div[1]/div') %>% html_nodes('li')  %>% html_nodes('a') %>% html_attr('href')
  temppdftitle <-   html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[3]/div[1]/div') %>% html_nodes('li')  %>% html_text()
  temppdf <- cbind(url = temppdfs, doctitle = temppdftitle) 
  storage1 <- cbind(medicine = rep(Medicine, nrow(temppdf)), 
                       section = rep(temptitle, nrow(temppdf)), 
                       temppdf)
  
  #Second Section "FDA Application Review Files"
  temptitle <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[3]/div[2]/div') %>% html_nodes('strong') %>% html_text()
  temppdfs <- html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[3]/div[2]/div') %>% html_nodes('li')  %>% html_nodes('a') %>% html_attr('href')
  temppdftitle <-   html_nodes(web_info, xpath= '//*[@id="main-content"]/div/div[3]/div[2]/div') %>% html_nodes('li')  %>% html_text()
  temppdf <- cbind(url = temppdfs, doctitle = temppdftitle) 
  storage2 <- cbind(medicine = rep(Medicine, nrow(temppdf)), 
                    section = rep(temptitle, nrow(temppdf)), 
                    temppdf)
  finalpdf <- as.data.frame(rbind(storage1, storage2))
  if (length(finalpdf$url) != length(web_pdfs)){
    cat("Erorr, in iteration: ", i, ' with url: ', url)
  }
  

  

  
  web_info %>% html_nodes('body') %>% html_attr('main-content')
  document.querySelector("#main-content > div > div:nth-child(4) > div:nth-child(2) > div")
  
  /html/body/div[2]/div/main/article/div/div[3]/div[2]/div
  
  try <- tryCatch(page <- xml2::read_html(url, encoding = 'utf-8'), error = function(e){"empty page"})
  if (try == 'empty page'){
    print(try)
    next
  }
  possible_pdfs <- html_nodes(page, xpath = './/a[text()="Medical Review(s)"]')
  if (length(possible_pdfs) == 0 ) {
    possible_pdfs = html_nodes(page, xpath = '..//li[contains(.,"Medical Review(s)")]/ul/li/a[contains(.,"Part")]') 
    if (length(possible_pdfs) == 0 ) {
      possible_pdfs = html_nodes(page, xpath = './/a[text()="Multi-Discipline Review/Summary, Clinical, Non-Clinical"]')
      if (length(possible_pdfs) == 0) {
        possible_pdfs = html_nodes(page, xpath = '..//li[contains(.,"Multi-Discipline Review/Summary, Clinical, Non-Clinical")]/ul/li/a[contains(.,"Part")]') 
        if (length(possible_pdfs) == 0 ) {
          possible_pdfs = html_nodes(page, xpath = './/a[text()="Summary Review"]')
          if (length(possible_pdfs) == 0) {
            possible_pdfs = html_nodes(page, xpath = '..//li[contains(.,"Summary Review")]/ul/li/a[contains(.,"Part")]') 
          }
        }
      }
    }
  }
  
  pdfs_url_link <- c()
  if (length(possible_pdfs) == 0) {
    pdf_url_matrix <- rbind(pdf_url_matrix, c(dataFDAcfm$ApplNo[i], as.matrix(dataFDAcfm$DrugName[i]), "No Medical/Summary/Multi-disciplinary documents found"))
  } else {
    pdf_matrix <- matrix(, nrow <- length(possible_pdfs), ncol = 2)
    
    pdf_link_expr <- regexpr("\\/[^\\/]*$", url )
    
    # LOOP through the links we found
    for (doc_element in possible_pdfs) {
      # Generate the url for medical/bla/bla
      pdfs_url_link <- c( paste(substring(url, 0, pdf_link_expr),html_attr(doc_element, "href"), sep = "/"))
      pdf_url_matrix <- rbind(pdf_url_matrix, c(dataFDAcfm$ApplNo[i], as.matrix(dataFDAcfm$DrugName[i]),pdfs_url_link))
    }
  }
  print(i/nrow(dataFDAcfm) * 100) 
}


#########################################################################################################
#########################################################################################################
#########################################################################################################
#########################################################################################################
#########################################################################################################

