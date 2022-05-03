library(DBI)
library(RMariaDB)
library(ggplot2)
library(data.table)

conemp <- dbConnect(MariaDB(), 
                    db = "empl", 
                    host = "localhost", 
                    port = 3306,
                    user = "root",
                    password = "root123")

qStr1 <- c("select * from emp")
qStr2 <- c("select * from dept")
qStr3 <- c("select * from adr")

dfEmp <- dbGetQuery(conemp,qStr1)
dfDep <- dbGetQuery(conemp,qStr2)
dfAdr <- dbGetQuery(conemp,qStr3)

dfAll <- merge(dfEmp,dfDep, by="DEPTNO")
dfAllAll <- merge(dfAll,dfAdr, by="EMPNO",all=TRUE)
