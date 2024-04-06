#---------------------------------
#Script Name
#Purpose:homework-202404
#Author:  Xiaoxuan Liu
#Email:    liuxiaoxuan@mail.ustc.edu.cn
#Date:    2024-04-06
#
#-------------------------------
cat("\014") #clears the console
rm(list = ls()) #remove all variables

library(skimr)
library(caret)
library(randomForest)
library(tidyverse)

#数据预处理
mtcars
# 看数据结构
skim(mtcars) 
# 去除缺失值，该数据没有缺失值
mtcars <- na.omit(mtcars) 
# 数据结构；vs am 应该是分类变量
str(mtcars)  
# 变量类型修正
mtcars$vs <- as.factor(mtcars$vs)
mtcars$am <- as.factor(mtcars$am)  
str(mtcars)

# 因变量分布情况
hist(mtcars$mpg,breaks=50)

#拆分数据
set.seed(66)
trainingRowIndex <- sample(1:nrow(mtcars), 0.75*nrow(mtcars))
# 模型训练数据
dtrain <- mtcars[trainingRowIndex, ]  
#模型验证数据
dtest  <- mtcars[-trainingRowIndex, ]   

# 随机森林回归
#公式
form_reg<- as.formula(paste0("mpg ~",
                             paste(colnames(dtrain)[2:10],collapse="+")))
#训练模型
rf_tree <- randomForest(form_reg,data=dtrain, 
                        proximity=TRUE,
                        ntree=1000)
#模型概要
rf_tree
#ntree参数和error之间的关系图
plot(rf_tree, main="ERROR & TREES")

#提取重要变量
(varimp.rf_tree <- caret::varImp(rf_tree))

#模型预测
#预测结果
testpred <-predict(rf_tree,newdata=dtest)
#误差指示，输出RMSE R2 MAE三个数值
defaultSummary(data.frame(obs=dtest$mpg,pred=testpred))
#图示预测结果
plot(x=dtest$mpg,
     y=testpred,
     xlab="实际值",ylab="预测值"
)
testlinmod <-lm(testpred~ dtest$mpg)
abline(testlinmod,col="blue",lwd=2.5,lty="solid")
abline(a=0,b=1,col="red",lwd=2.5,lty="dashed")
legend("topleft",
       legend=c("Model","Base"),
       col=c("blue","red"),
       lwd=2.5,
       lty=c("solid","dashed"))

