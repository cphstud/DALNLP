library(dplyr)
library(stringr)
library(rvest)
library(readr)
library(mongolite)


con <-mongo(
  collection = "vil6",
  db = "edc",
  url = "mongodb://localhost",
  verbose = TRUE
)

con$find(limit=5)

# https://www.edc.dk/alle-boliger/dannemare/4983/klokkevangen-4/?sagsnr=49205149
alllinks <- read_lines("out2.txt")
allsagsnr1 <- read_lines("l1")
tstlinks <- alllinks[550:2890]
allpages <- list()

edcdf <- data.frame(matrix(nrow=1,ncol=6))
edccolnames <- c("description","price","sqmprice","area","_id","year")
names(edcdf) <- edccolnames

listofsagsnr <- list()
cnt <- 1
for (i in 1:length(tstlinks)) {
  skip_to_next <- FALSE
  if (cnt%%10==0) {
    print(c("DO ...",cnt))
    doMongo(edcdf)
  }
 tryCatch({
  xpage <-  read_html(tstlinks[[i]])
  Sys.sleep(as.integer(abs(10*rnorm(1))))
  allpages[[i]] <- xpage
  cnt = cnt + 1
  #print("GO")
  nfacts = xpage %>% html_nodes("div.case-facts__fact-col:nth-child(1)") %>% html_text()
  nfacts2 = xpage %>% html_nodes("div.case-facts__fact-col:nth-child(2)") %>% html_text()
  nname = xpage %>% html_nodes(".case-facts__fact-col~ .case-facts__fact-col+ .case-facts__fact-col") %>% html_text()
  npris = xpage %>% html_nodes(".col-4.case-facts__header-col") %>% html_text()
  desc = xpage %>% html_nodes(".description p") %>% html_text()
  grpsy <- str_match_all(nfacts2,"([\\d\\/]+)")
  grps <- str_match_all(paste(npris,nname,nfacts),"([\\d\\.]+)")
  resy <- grpsy[[1]]
  res <- grps[[1]]
  #sagsnr <- getsagsnr
  sagsnr <- getsagsnr(nfacts)
  if (sagsnr %in% listofsagsnr) {
    print(c("DUPLICATE ",sagsnr))
    next
  }
  listofsagsnr[[i]] <- sagsnr
  year <- getyear(nfacts2)
  price <- getprice(npris)
  sqmprice <- getsqm(nname)
  desc <- getdesc(desc)
  area <- getarea(nfacts)
  tmpv <- c(desc,price,sqmprice,area,sagsnr,year)
  names(tmpv) <- edccolnames
  if (sagsnr != "NA") {
    edcdf <- rbind(edcdf,tmpv)
  } else {
    print("NO SAGSNR .. skipping line")
  }
  print("DONE OK")}, error = function(e) { skip_to_next <<- TRUE}
)
 if (skip_to_next) { next }
}
 
doMongo <- function(df) {
  con$remove(query="{}")
  con$insert(edcdf)
}

getdesc = function(x){
  res <- tryCatch(res <- x[1], error = function(e) { return(NA)} )
  return(res)
}


getprice = function(x){
  res <- tryCatch({
    res <- str_match_all(x,"([\\d\\.]{5,})")
    ym <- res[[1]]
    res <- ym[1,2]} ,
    error = function(e){ return(NA)}
  )
  return(res)
}

getsagsnr = function(x){
  res <- tryCatch({
    res <- str_match_all(x,"([0-9]{7,})")
    ym <- res[[1]]
    res <- ym[1,2]} ,
    error = function(e){ return(NA)}
  )
  return(res)
}

getsqm = function(x){
  res <- tryCatch({
    res <- str_match_all(x,"([0-9\\.]{4,}) ")
    ym <- res[[1]]
    res <- ym[1,2]} ,
    error = function(e){ return(NA)}
  )
  return(res)
}

getarea = function(x){
  res <- tryCatch({
    res <- str_match_all(x,"([0-9]+) ")
    ym <- res[[1]]
    res <- ym[1,2]} ,
    error = function(e){ return(NA)}
  )
  return(res)
}

getyear = function(x){
  res <- tryCatch({
    res <- str_match_all(x,"([0-9]{4})")
    ym <- res[[1]]
    res <- ym[1,2]} ,
    error = function(e){ return(NA)}
  )
  return(res)
}

