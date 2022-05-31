library(DBI)
library(RMariaDB)
library(ggplot2)
library(data.table)


# Connect to the MySQL database: con
conshop <- dbConnect(MySQL(), 
                 db = "shop", 
                 host = "localhost", 
                 port = 3306,
                 user = "root",
                 password = "root123")


# first query
qStr1 <- c("select * from products")
qStr2 <- c("select * from order_details")
qStr3 <- c("select * from categories")
qStr4 <- c("select * from orders")
qStr5 <- c("select * from customers")
qStr6 <- c("select * from employees")
qStr7 <- c("select * from shippers")
qStr8 <- c("select * from suppliers")

dfProd <- dbGetQuery(conemp,qStr1)
dfOD <- dbGetQuery(conemp,qStr2)
dfCat <- dbGetQuery(conemp,qStr3)
dfOrder <- dbGetQuery(conemp,qStr4)
dfCust <- dbGetQuery(conemp,qStr5)
dfEmpl <- dbGetQuery(conemp,qStr6)


dfAll <- merge(dfOrder,dfOD, by="OrderID")
dfAll2 <- merge(dfAll,dfProd, by="ProductID",all=TRUE)
dfAll3 <- merge(dfAll2,dfEmpl, by="EmployeeID",all=TRUE)

# top 3 sellers
dfAll2 <- merge(dfAll,df, by="CategoryID",all=TRUE)
dfAllAll <- merge(dfAll,dfCat, by="CategoryID",all=TRUE)
dfAllAll <- merge(dfAll,dfCat, by="CategoryID",all=TRUE)

df <- aggregate(dfAllAll$Quantity, list(dfAllAll$ProductName), sum)

topfive <- head(df[order(-df$x),],5)
