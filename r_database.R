#---------------------------------
#Script Name
#Purpose:熟悉reticulate和rdataretriever包;数据库连接写入
#Author:  Xiaoxuan Liu
#Email:    liuxiaoxuan@mail.ustc.edu.cn
#Date:    2024-04-18
#
#-------------------------------
cat("\014") #clears the console
rm(list = ls()) #remove all variables


####### 上传数据至PostgreSQL
#安装并加载包
install.packages("DBI")
install.packages("dbplyr")
install.packages("RPostgres")
install.packages("RPostgreSQL")
install.packages("retriever")
library(retriever)
library(DBI)
library(dbplyr)
library(RPostgreSQL)
library(RPostgres)
library(rdataretriever)
library(reticulate)

#连接PostgresSQL
pg <-dbConnect(RPostgres::Postgres(),
                dbname="try",
                host="100.65.48.96",
                user="postgres",
                password="postgres",
                port=5432)
#检查是否连接成功
dbIsValid(pg)

#下载并加载ade4包
install.packages("ade4")
library(ade4)

#上传数据
install_postgres(dataset = "doubs",
                 host="100.65.48.96",
                 user="postgres",
                 password="postgres",
                 port=5432,
                 database = "doubs")
dataset<-data(doubs,package="ade4")

#关闭连接
dbDisconnect(pg)


####### 上传数据至SQLite

#加载包和dataset
library(DBI)
library(dbplyr)
library(RSQLite)
library(reticulate)
data(doubs, package = 'ade4') 

#连接已经建立的Doubs.sqlite数据库
mydb<-dbConnect(SQLite(),"Doubs.sqlite")

#写入数据
dbWriteTable(mydb, 'env', doubs$env)
dbWriteTable(mydb, 'fish', doubs$fish)
dbWriteTable(mydb, 'xy', doubs$xy)
dbWriteTable(mydb, 'species', doubs$species)

#关闭连接
dbDisconnect(mydb)
