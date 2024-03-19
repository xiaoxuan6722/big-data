install.packages("car")
install.packages("boom")
.libPaths("C:/Users/Administrator/Desktop/test")
install.packages("boom")
getwd()#
#20240308
rm(list=ls())  #清除所有变量  清洗环境中的
cat("\014") #清洗下方代码  console中的

#20240313
#逻辑运算
x <- c(TRUE, TRUE, FALSE, FALSE)
y <- c(TRUE, FALSE, TRUE, FALSE)
!x
x | y
x & y
#and运算


?plot.function  #查看绘图功能的帮助信息
x <-c(1,2,3,4,5)
y <-c(1,4,9,16,25)
plot(x,y, pch =0, cex = 1.5) #pch标注点符号，cex改变大小
plot(x,y, pch =0, cex = 1.5, col="red") #col改变颜色
colors() #显示有什么颜色
plot(x,y, pch =0, cex = 1.5, col="red", type="l")#type设定中间的连线有没有,l是有连线，0有连线有点
#连线类型 type ="l", "o", "p", "b"


#legend 图例

library(packagefinder)
help(package="tidyverse")#遇到不会用的包可以查找帮助信息
demo(package="")#找包应用的实例


#调用函数
source("函数路径scripts/coldlss.R")#coldlss是例子表示以函数名称命名的文件名

#install gptstudio
install.packages("pak")
library(pak)
pak::pak("usethis")
pak::pak("MichelNivard/gptstudio")
library(rtools)
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
Sys.which("make")

writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
Sys.which("make")
install.packages("pak")
library(pak)
pak::pak("usethis")
pak::pak("MichelNivard/gptstudio")


install.packages("reticulate")
library(reticulate)
install.packages("rdataretriever")
install.packages("postgresql",type="source")

#20240315第三周周五
#命名不能开头就用_，特殊字符、数字开头、点开头不可以。
#  2var_name;var_name%; .2var_name;_var_name均不可以。var_name2是可以的
########变量赋值assignment of variables########
variable.1=124
variable.1   #查看变量1 的数值,以下三种都可以
ptint(variable.1)
cat(variable.1)

variable.2 <- "Learn R Programming" #赋值 向左

133L -> variable.3 #赋值 向右

print(variable.1)
cat("variable.1 is", variable.1 ,"\n")
cat("variable.1 is", variable.1 ) #\n的作用是is左右空出空格,去掉变化不大
cat("variable.2 is", variable.2 ,"\n")
cat("variable.3 is", variable.3 ,"\n")

#######data types and data structures#######
#数据类型：逻辑型True False、数据型、整数型integer(3L 66L等)、字符型character
class()#看数据类型的代码，以下三种
mode()
type()

x <- pi
class(pi) #why different  #输出[1] "numeric"
typeof(pi)  #输出[1] "double"

a<--4:10 #create a vector 赋值
a
class(a)
typeof(a)

seq_vec<-seq(1,4,by=0.5)  #1到4之间可以用：和，
seq_vec
class(seq_vec)

num_vec<-c(10.1,10.2,33.2)
num_vec
class(num_vec)


######数据结构data structure#####
#类型：vectors向量,list, arrays, matrices, data frames, factors
seq_vec<-seq(1,4,length.out=6)#向量长度6
seq_vec
seq_vec[2]  #Accessing elements of vectors
#[]extractory element取其中一个值   ()代表一个函数

char_vec<-c("shubham"=22,"arpita"=23,"vaishali"=25) #c产生vector的函数
char_vec
char_vec["arpita"] #[]取其中的某一数值

p<-c(1,2,4,5,7,8)
q<-c("shubham","arpita","vaishali","nishka","sumit","vaishali")
r<-c(p,q)  #combining vectors
r

a<-c(1,3,5,7)  #两个向量的长度是一样的
b<-c(2,4,6,7)
length(a)  #查看向量a的长度
a+b
length(a+b)
a-b
a/b
a%%b # help('%%')

vec <- c(3,4,5,6) #create a list #数字型向量
char_vec<-c("shubham","arpita","vaishali","nishka") #字符型向量
logic_vec<-c(TRUE,FALSE,FALSE,TRUE)

out_list<-list(vec,char_vec,logic_vec)
out_list
##输出结果
##[[1]]##表示列表中第一个数据集
##[1] 3 4 5 6 #表示第一个数据集的数据
##[[2]]
##[1] "shubham"  "arpita"   "vaishali" "nishka"  
##[[3]]
##[1]  TRUE FALSE FALSE  TRUE

list_data <-list(c("shubham","arpita","vaishali"),matrix(c(40,80,60,70,90,80),nrow = 2),list("BCA","MCA","B.tech"))
list_data 
#c里面是向量，list是向量的集合。
#matrix形成的是矩阵，等于把40，80，60，70，90，80分成两行
#成为40，60，90
#    80，70，80
####输出结果###
# [[1]]第一个向量
# [1] "shubham"  "arpita"   "vaishali"

# [[2]]
#       [,1] [,2] [,3]
# [1,]   40   60   90
# [2,]   80   70   80

#[[3]]
#[[3]][[1]]
#[1] "BCA"

#[[3]][[2]]
#[1] "MCA"

#[[3]][[3]]
#[1] "B.tech"

print(list_data[1]) #accesing the element of the list
#输出结果
#   [[1]]
#   [1] "shubham"  "arpita"   "vaishali"
print(list_data[2]) 
# [[1]]
#       [,1] [,2] [,3]
# [1,]   40   60   90
# [2,]   80   70   80
print(list_data[3]) 
#[[1]]
#[[1]][[1]]#第一个列表
#[1] "BCA"

#[[1]][[2]]#第二个列表
#[1] "MCA"

#[[1]][[3]]
#[1] "B.tech"

list1<-list(10:20)
print(list1)
list2<-list(5:14)
print(list2)

v1 <- unlist(list1) #converting the list to vectors
class(v1)
v2 <-unlist(list2)
class(v2)
# unlist(list(c()))=c()
print(v1)
print(v2)

vec1<-c(1,3,5)  #taking these vectors as input to the array
vec2<-c(10,11,12,13,14,15)
res <-array(c(vec1,vec2),dim=c(3,3,2))  #dim维度#(3,3,2)代表两组维度3，3
print(res)
#形成matrix(矩阵)的时候要有n row和byrow
#形成array(数组)的时候要有dim

p <- matrix(c(5:16), nrow =4, byrow=TRUE)  #创造一个矩阵
print(p)
# nrow=4表示4行，

Q <- matrix(c(3:14), nrow = 4,byrow = FALSE)
print(Q)

row_names=c("row1","row2","row3","row4")
col_names=(c("col1","col2","col3"))
R<-matrix(c(3:14),nrow=4,byrow=TRUE,dimnames=list(row_names, colnames))
print(R)
#R=2是赋值，R==2是真正的等于

###创建数据框data frame
emp.data<-data.frame(
  employee_id=c(1:5),
  employee_name=c("AB","BA","CD","DE","FR"),
  sal=c(623.3,42.2,542.2,24.2,254))
print(emp.data)
final<-data.frame(emp.data$employee_id,emp.data$sal)  #$取两列形成新的数据框,$取整列
print(final)
#出现[]是向量，[[]]列表

final1<-emp.data[1,]  #取第一行输出
print(final1)

final2<- emp.data[4:5, ] #取4-5行输出
print(final2)

emp.data<- emp.data[-1,]  #去掉第一行，其他都要
print(emp.data)

emp.data.2<- emp.data[ ,2]  #取第二列
print(emp.data.2)

emp.data.3<- emp.data[3,2]  #取第三行第二列
print(emp.data.3)


#creating a factor
data<-c("AD","ed","ef","dw","AD","ED","UD","TG","ef","UD","YG")
print(data)
print(is.factor(data)) #是不是因子
#输出[1] FALSE  结果是不是的
class(data) #data是字符串
typeof(data)

factor_data<-factor(data)  #把这个数据变成因子
print(factor_data)  #打印出来的区别，每个字符没有双引号了
print(factor_data[4]) #打印出来第四个
print(factor_data[-4]) #除去第四个打印

# 没有写全new_order_factor<-(factor_data,#改变顺序)
# 参考网站http://www.javatpoint.com/r-tutorial#

install.packages("plotly")
library("xlsx")


# import and save data as a file 
excel_data <-read.xlsx("文件目录data/employee.xlsx"，sheetIndex=1) #读第一页
print (excel_data)
write.csv(excel_data,"data/exployee.csv")  #后缀一样
csv_data<-read.csv("data/exployee.csv")
print(csv_data)
print(is.data.frame(csv_data))#是否是数据框
max_sal<-max(csv_data$sal)#取工资一列中的最大值

# http://bbolker.github.io/R-ecology-lesson/03-dplyr.html


