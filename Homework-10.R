#---------------------------------
#Script Name
#Purpose:创建时间序列并可视化，tidymodels包构建预测模型
#Author:  Xiaoxuan Liu
#Email:    liuxiaoxuan@mail.ustc.edu.cn
#Date:    2024-05-17
#
#-------------------------------
cat("\014") #clears the console
rm(list = ls()) #remove all variables
data=read.table('F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202410\\Prunier et al._RawBiomassData.txt',h=TRUE)
head(data)
library(dplyr)
data_clean <- data |>
  dplyr::select(-YEAR) |>   #选择除了YEAR列以外的所有列
  # drop_na() |>
  distinct() # 识别和删除重复数据
head(data_clean)

unique(data_clean$STATION) # 全部站点
unique(data_clean$SP) # 全部鱼类

# 用timetk()创建时间序列
#因为数据是不连续的，中间有空缺所以选择timetk()创建时间序列
library(timetk)
mydate <- data_clean |>
  subset(STATION=="VERCah" & SP == "VAI") #SP是指鱼类的物种
mydate

library(tidyverse)
#install.packages("tsibble")
library(tsibble)

datatk_ts <- mydate |>
  tk_tbl() |>        # 转换为tibble格式
  select(-1) |>
  rename(date = DATE) |>   #重命名DATE
  relocate(date, .before = STATION) |>
  pivot_longer(            # 转换为长数据格式
    cols = c( "DENSITY"))

# 时间序列绘图
datatk_ts |>
  group_by(name) |> #按照name列分别绘制图片
  plot_time_series(date, value, #date value是指的datatk_ts表中的列名称
                   .facet_ncol = 2, 
                   .facet_scale = "free",
                   .interactive = FALSE,
                   .title = "CHE of Le Doubs river"
  )


# 机器学习预测时间序列
# A) load packages and data

library(tidyverse)  
library(timetk) 
library(tidymodels)
library(modeltime)
library(timetk)

densitytk_ts <- mydate |> 
  tk_tbl() |> 
  select(index, DATE, DENSITY) 


library(tidyquant)
ggplot(densitytk_ts, aes(x = DATE, y = DENSITY)) +
  geom_line() +
  ggtitle("Density of Fishes in Doubs")

# 训练/测试分离和创建特性

n_rows <- nrow(densitytk_ts)  #一共多少数据[34]
train_rows <- round(0.8 * n_rows)  #训练集数据量[27]

train_data <- densitytk_ts |>  #训练集
  slice(1:train_rows) 
test_data <- densitytk_ts |>   #测试集
  slice((train_rows):n_rows)

ggplot() +   #前面14年数据预测后面几年
  geom_line(data = train_data, 
            aes(x = DATE, y = DENSITY, color = "Training"), 
            linewidth = 1) +
  geom_line(data = test_data, 
            aes(x = DATE, y = DENSITY, color = "Test"), 
            linewidth = 1) +
  scale_color_manual(values = c("Training" = "blue", 
                                "Test" = "red")) +
  labs(title = "Training and Test Sets", 
       x = "DATE", y = "DENSITY") +
  theme_minimal()


