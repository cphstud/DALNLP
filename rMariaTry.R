library(DBI)
library(RMariaDB)
library(ggplot2)


# Connect to the MySQL database: con
con <- dbConnect(MySQL(), 
                 db = "world", 
                 host = "localhost", 
                 port = 3306,
                 user = "root",
                 password = "root123")

con <- dbConnect(MySQL(), 
                 db = "empl", 
                 host = "localhost", 
                 port = 3306,
                 user = "root",
                 password = "root123")

qStr <- c("select * from emp;")
dfEmp <- dbGetQuery(con,qStr)



conshop <- dbConnect(MySQL(), 
                 db = "shop", 
                 host = "localhost", 
                 port = 3306,
                 user = "root",
                 password = "root123")



# first query
num=4
qStr1 <- c("select * from emp inner join dept on emp.deptno=dept.deptno order by empno")
nrs <- dbGetQuery(con,qStr1)

query <- paste0( "SELECT name,countrycode,population FROM city WHERE population > 20000 order by 3 desc limit ", num)
query <- paste0( "SELECT name,countrycode,population FROM city WHERE population > 20000 order by 3 desc limit ", num)
nrs <- dbGetQuery(con,query)
q = dbSendQuery()

# # Get table names
num <- 5
query <- paste0( "SELECT name,countrycode,population FROM city WHERE population > 20000 order by 3 desc limit ", num)
nrs <- dbGetQuery(con,query)
hist(data=df,aes(x=name,y=population), geom_bar(stat="identity"))
ggplot(df, aes(name,frequency(name))) + geom_bar()
dbClearResult(rs)



head(df)

p<-ggplot(data=df, aes(x=name, y=population)) +
  geom_bar(stat="identity")
p