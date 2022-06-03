library(RSelenium)
library(httr)
library(dplyr)
library(robotstxt)
library(stringr)
library(rvest)
library(readr)



alllinks <- read_lines("out2.txt")
tstlinks <- alllinks[1:10]
#ua <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
# Query webpage
#link = "https://www.edc.dk/sog/?ejd-typer=1&antal=10&side=1#lstsort"
# https://www.edc.dk/alle-boliger/dannemare/4983/klokkevangen-4/?sagsnr=49205149
edcdf <- data.frame(matrix(nrow=1,ncol=6))
edccolnames <- c("description","price","sqmprice","area","casenr","year")
names(edcdf) <- edccolnames
for (link in tstlinks) {
  tpage = read_html(link)
  nfacts = tpage %>% html_nodes("div.case-facts__fact-col:nth-child(1)") %>% html_text()
  nfacts2 = tpage %>% html_nodes("div.case-facts__fact-col:nth-child(2)") %>% html_text()
  nname = tpage %>% html_nodes(".case-facts__fact-col~ .case-facts__fact-col+ .case-facts__fact-col") %>% html_text()
  npris = tpage %>% html_nodes(".col-4.case-facts__header-col") %>% html_text()
  desc = tpage %>% html_nodes(".description p") %>% html_text()
  grpsy <- str_match_all(nfacts2,"([\\d\\/]+)")
  grps <- str_match_all(paste(npris,nname,nfacts),"([\\d\\.]+)")
  resy <- grpsy[[1]]
  res <- grps[[1]]
  sagsnr <- res[19,2]
  year <- resy[2,2]
  price <- res[1,2] 
  sqmprice <- res[7,2]
  desc <- desc[1]
  area <- res[22,2]
  tmpv <- c(desc,price,sqmprice,area,sagsnr,year)
  names(tmpv) <- edccolnames
  edcdf <- rbind(edcdf,tmpv)
}
print(link)

nlink = "https://www.edc.dk/alle-boliger/dannemare/4983/klokkevangen-4/?sagsnr=49205149"
#bbc <- GET(link, user_agent(ua))

#paths_allowed(link)
#link = "https://www.imdb.com/search/title/?title=war"
npage = read_html(nlink)


#name = bbc %>% html_element("body")
#name = page %>% html_element("body")
#name = page %>% html_nodes("tbody") %>% html_text()
name = page %>% html_nodes(".case-facts__fact-col") %>% html_text()
nfacts = npage %>% html_nodes("div.case-facts__fact-col:nth-child(1)") %>% html_text()
nfacts2 = npage %>% html_nodes("div.case-facts__fact-col:nth-child(2)") %>% html_text()
nname = npage %>% html_nodes(".case-facts__fact-col~ .case-facts__fact-col+ .case-facts__fact-col") %>% html_text()
npris = npage %>% html_nodes(".col-4.case-facts__header-col") %>% html_text()
desc = page %>% html_nodes(".description p") %>% html_text()
facts = page %>% html_nodes(".case-facts__header+ .row") %>% html_text()
print((desc[1]))
print((nname))
print((npris))
print((nfacts))
print((nfacts2))
#grps <- str_match_all(name,"([\\d\\.] kr", )
grps <- str_match_all(name,"([\\d\\.]) kr")
grpsy <- str_match_all(nfacts2,"([\\d\\/]+)")
grps <- str_match_all(paste(npris,nname,nfacts),"([\\d\\.]+)")
class(grps)

resy =grpsy[[1]]
# collect info
sagsnr <- res[19,2]
year <- resy[4,2]
price <- res[1,2] 
sqmprice <- res[7,2]
desc <- desc[1]
area <- res[22,2]


res=grps[[1]]
for (i in 1:(nrow(res))) {
  print(res[i])
}
for (i in 1:(nrow(resy))) {
  print(resy[i])
}
print(class(grps[1]))
print(desc)
print(facts)
