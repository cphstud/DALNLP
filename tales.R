library(readr)
library(rvest)
library(stringr)
library(Sentida)
library(textclean)
library(httr)


# read file into dataframe

mytales <- read_lines("story/allinks1.html")
tst <- mytales[1:10]
allTe = list()
cnames = c("text","title","scorem","scoret")
allTeDf = data.frame(matrix(ncol = 4,nrow = 1))
names(allTeDf) <- cnames

#FOR TESTING
ly <- '"<li><li><span class=\"nr\">008 </span><span style=\"display: table-cell;\"><a href=\"den_lille_havfrue\">Den lille havfrue</a></span></li>"'
lx <-  '<li><li><span class="nr">005 </span><span style="display: table-cell;"><a href="tommelise">Tommelise</a></span></li>'
m <- str_match(ly,'href="([\\D]+)">(.*)</a')
print((m[1,2]))
print((m[1,3]))
testurl <- "https://www.andersenstories.com/da/andersen_fortaellinger/den_lille_pige_med_svovlstikkerne"
testurl <- "https://www.andersenstories.com/da/andersen_fortaellinger/kejserens_nye_klaeder"
testurl <- "https://www.andersenstories.com/da/andersen_fortaellinger/svinedrengen"
testurl <- "https://www.andersenstories.com/da/andersen_fortaellinger/det_er_ganske_vist"
testurl <- "https://www.andersenstories.com/da/andersen_fortaellinger/hjertesorg"
res <- GET(testurl)
status_code(res)
txt <- (content(res))
print(txt)
tt <- txt
#ht <- read_html(testurl)
tt <- ht %>% html_nodes(".text") %>% html_text()
#tcl <- replace_non_ascii(tt)
print(tt)
#sc <- sentida(tt,output = "total")
sc2 <- sentida(tt,output = "total")
# TESTING DONE

startstr <- "https://www.andersenstories.com/da/andersen_fortaellinger/"
for (i in 1:length(tst)) {
  try({
  m <- str_match(tst[i],'href="([\\D]+)">(.*)</a')
  ml <- gsub(" ","_",m[1,2])
  title <- m[1,3]
  nurl <- (paste(startstr,ml,sep=""))
  print(str_to_lower(nurl))
  #ht <- read_html(nurl)
  res <- GET(nurl, config = httr::config(connecttimeout = 60))
  Sys.sleep(as.integer(abs(3*rnorm(1))))
  ht <- content(res)
  tt <- ht %>% html_nodes(".text") %>% html_text()
  scorem <- sentida(tt,output = "mean")
  scoret <- sentida(tt,output = "total")
  tmpv <- c(tcl,title,scorem,scoret)
  names(tmpv) <- cnames
  allTe[[i]] <- tt
  allTeDf <- rbind(allTeDf,tmpv)
  },silent = F)
}

cnames = c("text","title","score")
allTeDf2 = data.frame(matrix(ncol = 3,nrow = 1))
names(allTeDf2) <- cnames

for (i in 1:length(allTe)) {
  #score = sentida(allTe[[i]], output = "by_sentence_mean")
  print(allTe[[i]][1:10])
  print(score)
}

for (i in 1:length(allTe)) {
  #sentida(allTe[[i]], output = "total")
  print(nchar(allTe[[i]]))
  x <- allTe[[i]]
  x %>% 
    tibble(name = .) %>%
    filter(xfun::is_ascii(name)== T)
  allTeFiltered[[i]] <- x
}
for (i in 1:length(allTeFiltered)) {
  #sentida(allTe[[i]], output = "total")
  print(nchar(allTeFiltered[[i]]))
}
  
ttest <- function() {
  aa <- rep("ABC", times=100000)
  aa <- str_c(aa, collapse = "")
  aa
  length(aa)
  nchar(aa)
}
  
