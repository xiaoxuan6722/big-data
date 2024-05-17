#---------------------------------
#Script Name
#Purpose: Homework03
#Author:  Xiaoxuan Liu
#Email:    liuxiaoxuan@mail.ustc.edu.cn
#Date:    2024-03-24
#
#-------------------------------
cat("\014") #clears the console
rm(list = ls()) #remove all variables

#1)import and save data; 
#导入csv文件并保存
file.choose()
csv_data<-read.csv("D:\\software-R\\big-data\\Homework\\homework03.csv")
print(csv_data) 
write.csv(csv_data, #需要导出数据
          "D:\\software-R\\big-data\\Homework\\export_homework03.csv"  #输出的文件名称及路径
                    )
#导入excel文件
library(readxl)
excel_data<-read_excel("D:\\software-R\\big-data\\Homework\\homework03.xls")
print(excel_data) 


#2 inspect data structure；以csv_data为例
print(is.data.frame(csv_data))#是否是数据框
class(csv_data)
str(csv_data)
summary(csv_data)


#3）check whether a column or row has missing data；
library(skimr)
skim(csv_data)  
#输出结果中有n_missing项，可以展示是否有丢失值及个数


#4）extract values from a column or select/add a column；
head(csv_data)
csv_data1<- csv_data$clumpThickness  #输出某一列
csv_data1

library(dplyr)
csv_data2<- select(csv_data,c(1:5)) #输出多列
csv_data2

csv_data3<- mutate(csv_data,  
                   add_colum=c(1:699)) #增加列
csv_data3


#5）transform a wider table to a long format；
library(tidyverse)
head(csv_data2)  #以上节生成的csv_data2为例，宽数据转变为长数据
csvdata_long <- csv_data2 %>%
  pivot_longer(cols=c(3:5),  #也可以写为(cols=-c(1:2))
               names_to="varb",  #将3-5列变量名称输入到varb中
               values_to="value") #将3-5列变量对应数值输入到value中
head(csvdata_long)

#6）visualize the data.
library(tidyverse)  #library(ggplot2)
set.seed(432)  #因为有随机分布，设置种子数，使结果可重复
data1<-data.frame(  #生成一个数据
  ind=1:100,
  rn=rnorm(100),
  rt=rt(100,df=5),
  rs1=sample(letters[1:3],100,replace = T),
  rs2=sample(LETTERS[21:22],100,replace=T))
data1
class(data1)
str(data1)
#点图
ggplot(data=data1,
       aes(x=rn,y=rt)) +
  geom_point()
#线图
ggplot(data1,aes(x=ind,y=rn))+
  geom_line(sixe=1.5)
#条形图
data1 %>%
  ggplot(aes(x=rs1)) +
  geom_bar(fill="white",color="black") #fill填充色，color线条颜色
#条形图分组汇总
data1 %>%
  group_by(rs1)%>% #以rs1进行分组
  summarise(mean_rn=mean(rn)) %>%  #计算每组的均值
  ggplot(aes(x=rs1,y=mean_rn)) +
  geom_col(fill="grey",color="red",width=0.5)
#箱线图
ggplot(data1,aes(x=rs1,y=rn)) +
  geom_boxplot()
