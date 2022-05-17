library(stringr)
library(readr)
library(Sentida)


# One line
testline <- c('anders-fogh-rasmussens-nytaarstale-2002.html:<p style="text-align: left;">Vi har ingen ideologiske blokeringer. Vi er ikke bundet af snævre interesser eller hensyn til bestemte grupper.</p>"')

#testgroup <- str_match(testline,"^([a-zA-Z\\-]+)()")
testgroup <- str_match(testline,"^(.*)\\.html.*>(.*)<")
#testgroup <- str_match(testline,"^(.*)-([\\d]+)\\.html.*>(.*)<")
print(length(testgroup))
testgroup[[2]]
testgroup[[3]]
# test corpus

#testspeeches <- read_lines("tmp/testsp.txt")
testspeeches <- read_lines("tmp/allpmspeaches.txt")
testspeeches <- read_lines("tmp/xx/newallpmspeeches.txt")
testspeeches <- read_lines("tmp/xx/xnewallpm.txt")
dftestspeeches <- data.frame(matrix(ncol =3, nrow=1))
coln <- c("text","score","title")
names(dftestspeeches) <- coln

for (x in testspeeches) {
  # opdel streng i enheder ud fra pattern
  print(x[1])
  testgroup <- str_match(x,"^(.*)\\.html.*>(.*)<")
  if (length(testgroup > 1)){
    ttitle <- testgroup[[2]]
    ttext <- testgroup[[3]]
    tscore <- sentida(ttext,output = "total")
    # lav en vektor med grupper
    tvec <- c(ttext,tscore,ttitle)
    names(tvec) <- coln
    dftestspeeches <- rbind(dftestspeeches,tvec)
  }
}

testsubset <- split(dftestspeeches,dftestspeeches$title)
for (tmpdf in testsubset) {
  #print(class(tmpdf))
  print(c("DEV: ",sd(as.numeric(tmpdf$score)),"MEAN: ",mean(as.numeric(tmpdf$score))))
}
