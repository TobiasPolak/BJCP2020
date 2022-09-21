source("C:\\Users\\31612\\Documents\\R\\BJCP2020\\01LoadInstall.R", encoding = 'UTF-8')
setwd("C:\\Users\\31612\\Documents\\R\\BJCP2020\\FDA\\")
dataFDA <-
  as.data.frame(read_xlsx(
    "C:\\Users\\31612\\Documents\\R\\BJCP2020\\Data\\FDA.xlsx",
    sheet = 2
  ))

resultFDAzip <- read.csv2('resultFDAzip.csv')
dataFDAsel <- dataFDA[, c('ApplNo', 'ApplicationDocsURL')]
test <- left_join(resultFDAzip, dataFDAsel, by = c('ApplNo' = 'ApplicationDocsURL'))
write.csv2(test, paste0(Sys.Date(), 'resultFDAzip.csv'))

resultszip <-  read.csv2('2022-09-15resultFDAzip.csv')
resultszipsel <- resultszip[grep('/2018/|/2019/|/2020/|/2021/|/2022/', resultszip$url),]

resultscfm <- read.csv2('resultFDA20220913.csv')

ndazip <- unique(resultszipsel$nda)
ndacfm <- unique(resultscfm$nda)

discrepancy <- ndazip[(which(ndazip %notin% ndacfm))]
cat('lengt discrepancy: ', length(discrepancy))

cfmcheck <- read.csv2('dataFDAcfm.csv')
ndascfm <- unique(cfmcheck$ApplNo)
ndazip[(which(ndazip %notin% ndascfm))]

### So there must be roughly 50 NDAs without cfm.