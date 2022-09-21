file1 <- read.csv2('resultEMA.csv')
file2 <- read.csv2('2022-09-20resultEMA.csv')

cat(dim(file1), 'and file 2: ', dim(file2)
)
    
length(unique(file1$Medicine))
length(unique(file2$Medicine))

unique(file1$Medicine)[which(unique(file1$Medicine) %notin% unique(file2$Medicine))]
