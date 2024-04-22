#---------------------------------
#Script Name
#Purpose:去除doubs数据集中的缺失值，环境因子是否共线性，分析环境因子和鱼类之间的关系
#Author:  Xiaoxuan Liu
#Email:    liuxiaoxuan@mail.ustc.edu.cn
#Date:    2024-04-18
#
#-------------------------------
cat("\014") #clears the console
rm(list = ls()) #remove all variables

# 加载数据doubs
library(ade4)
data(doubs)
library(corrplot)
library(car)
library(dplyr)

# 删除缺失值
env <- na.omit(doubs$env) 
fish<-na.omit(doubs$fish)
xy<-na.omit(doubs$xy)
spe<-na.omit(doubs$species)
str(env)
str(spe)
summary(spe)


#环境因子是否共线性
head(env) 
pairs(~dfs+alt+slo+flo+pH+har+pho+nit+amm+oxy+bdo, data=env,
      main="Basic Scatter Plot Matrix")
#计算环境因子相关系数
env_c <- cor(doubs$env) 
print(env_c)

# 相关系数矩阵
cor_matrix <-env_c

# 找出相关系数大于0.7的元素的位置（不包括对角线上的1）
indices <- which(upper.tri(cor_matrix) & cor_matrix > 0.7, arr.ind = TRUE)
  
# 提取变量名，cor_matrix的行名和列名应该是相同的
var_names <- colnames(cor_matrix)

# 打印出这些位置和对应的相关系数
if (length(indices) > 0) {
  for (i in 1:nrow(indices)) {
# 打印变量名和对应的相关系数
    cat(var_names[indices[i, "row"]],
        "and",
        var_names[indices[i, "col"]],
        "have a correlation of",
        cor_matrix[indices[i, "row"], indices[i, "col"]],
        "\n")
  }
} else {
  cat("No correlations above 0.7\n")
}
#输出结果
# alt and slo have a correlation of 0.7637673 
# dfs and flo have a correlation of 0.9490417 
# dfs and nit have a correlation of 0.7467194 
# pho and nit have a correlation of 0.8002507 
# pho and amm have a correlation of 0.9695215 
# nit and amm have a correlation of 0.7976855 
# pho and bdo have a correlation of 0.8855369 
# amm and bdo have a correlation of 0.8857985 
#去掉amm和pho

# 鱼类出现频次
fish_pres <- apply(fish>0,2,sum)
#以鱼类出现频次最高的lece为例进行分析
sort(fish_pres)

#全部环境因子方差膨胀因子分析
lm_model <- lm(fish$Lece ~ ., data = doubs$env)
# 计算VIF

vif_results <- vif(lm_model)
print(vif_results)
# 输出结果
# dfs        alt        slo        flo         pH        har        pho        nit 
# 136.737235  54.161158   5.309589  46.988910   1.746103   4.296977  25.658248  16.842868 
# amm        oxy        bdo 
# 30.742467  17.581085  17.803821 


lm_model2 <- lm(fish$Lece ~ .-pho-amm-dfs, data = doubs$env)
# 计算VIF
vif_results2 <- vif(lm_model2)
print(vif_results2)
#输出结果
#alt       slo       flo        pH       har       nit       oxy       bdo 
#10.171535  3.886541  4.747306  1.389836  2.662946  4.599884  5.241040  4.502896 
#alt>10 具有共线性，踢掉

#分析鱼类lece与环境因子之间的关系

lece_env <- bind_cols(select(fish, 10), select(env, c(3, 4, 5, 6, 8, 10, 11)))
lece_env
corr_lece <- cor(lece_env)
print(corr_lece)
# 可视化环境变量之间的相关性
corrplot(corr_lece, method = "circle")

#鱼类lece与环境因子之间的线性关系
lece_model <- lm(lece_env$Lece ~ ., data = lece_env)
lece_model
lece_model_sum<-summary(lece_model)
lece_model_sum
