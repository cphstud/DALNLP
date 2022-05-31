library(stringr)
library(dplyr)
library(rvest)
library(readr)
library(mongolite)


con <-mongo(
  collection = "test",
  db = "edc",
  url = "mongodb://localhost",
  verbose = TRUE
)
testtext <- c("Her i nr. 34 boede i 1975 Kurt.")
testtext2 <- c("Her i nr. 34 boede i 2010 Kurt.")
testtext3 <- c("Her i nr. 12 boede i 1975 Kurt.")
testtext4 <- c("Her i nr. 34 boede i  Kurt.")
tlist <- list(testtext,testtext2,testtext3,testtext4)

#grps <- str_match_all(testtext,"([0-9]{4})")
#print(grps)
testdf <- data.frame(matrix(nrow=1,ncol=3))
cn <- c("_id","time","date")
names(testdf) <- cn

for (i in 1:length(tlist)) {
  v <- c(i,"b",as.integer(abs(10*rnorm(1))))
  names(v) <- cn
  testdf <- rbind(testdf,v)
print((retval))
}

con$remove(query="{}")
con$insert(testdf)

getyear = function(x){
  res <- tryCatch({
    res <- str_match_all(x,"([0-9]{4})")
    ym <- res[[1]]
    res <- ym[1,2]} ,
    error = function(e){ return(NA)}
  )
  return(res)
}
