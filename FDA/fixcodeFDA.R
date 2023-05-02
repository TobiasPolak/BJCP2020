resultFDA <- read.csv2('C:\\Users\\31612\\Documents\\R\\BJCP2020\\FDA\\resultFDA20220913.csv')

docsFDA <- read.csv2("C:\\Users\\31612\\Documents\\R\\BJCP2020\\FDA\\docsFDA_all.csv")
docsFDA <- docsFDA[grep('/2017|/2018|/2019|/2020|/2021|/2022', docsFDA$info),]
docsFDA <- docsFDA[grep('Approval', ignore.case = TRUE, docsFDA$info),]

docsFDA$identifier <- paste0(docsFDA$nda, docsFDA$doctitle)
resultFDA$identifier <- paste0(resultFDA$nda, resultFDA$doc)

for (i in 1:nrow(docsFDA)){
  docsFDA$docurl[i] <- paste0(gsub(basename(docsFDA$pageurl[i]),'', docsFDA$pageurl[i]), docsFDA$url[i])
}
docsFDAsel <- docsFDA[, c('identifier', 'docurl')]
enddf <- left_join(resultFDA, docsFDAsel, by = c('identifier' = 'identifier'))
