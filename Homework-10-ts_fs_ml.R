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

# 使用recipes 创建特征
library(recipes)
library(tidymodels)

recipe_spec_final <- recipe(DENSITY ~ ., train_data) |>  #创建一个新的配方，目标变量是BIOMASS，而.代表所有其他变量作为预测变量。
  step_mutate_at(index, fn = ~if_else(is.na(.), -12345, . )) |>
  step_timeseries_signature(DATE) |>
  step_rm(DATE) |>
  step_zv(all_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE)

summary(prep(recipe_spec_final))

# 训练评估模型
# 1)提升回归树模型
# Workflow
bt <- workflow() |>
  add_model(boost_tree("regression") |>   #提升回归树模型
              set_engine("xgboost")  ) |>
  add_recipe(recipe_spec_final) |>
  fit(train_data)

bt

#评估模型
bt_test <- bt |> 
  predict(test_data) |>
  bind_cols(test_data) 

bt_test  #.pred预测值 biomass实际值

pbt <- ggplot() +
  geom_line(data = train_data, 
            aes(x = DATE, y = DENSITY, color = "Train"), 
            linewidth = 1) +
  geom_line(data = bt_test, 
            aes(x = DATE, y = DENSITY, color = "Test"), 
            linewidth = 1) +
  geom_line(data = bt_test, 
            aes(x = DATE, y = .pred, color = "Test_pred"), 
            linewidth = 1) +
  scale_color_manual(values = c("Train" = "blue", 
                                "Test" = "red",
                                "Test_pred" ="black")) +
  labs(title = "bt-Train/Test and validation", 
       x = "DATE", y = "DENSITY") +
  theme_minimal()
pbt

# 计算预测误差
bt_test |>
  metrics(BIOMASS, .pred)

#2)随机森林算法
rf <- workflow() |>
  add_model(
    spec = rand_forest("regression") |> set_engine("ranger")
  ) |>
  add_recipe(recipe_spec_final) |>
  fit(train_data)

rf

# 评估模型性能
rf_test <- rf |> 
  predict(test_data) |>
  bind_cols(test_data) 

rf_test

prf <- ggplot() +
  geom_line(data = train_data, 
            aes(x = DATE, y = DENSITY, color = "Train"), 
            linewidth = 1) +
  geom_line(data = rf_test, 
            aes(x = DATE, y = DENSITY, color = "Test"), 
            linewidth = 1) +
  geom_line(data = rf_test, 
            aes(x = DATE, y = .pred, color = "Test_pred"), 
            linewidth = 1) +
  scale_color_manual(values = c("Train" = "blue", 
                                "Test" = "red",
                                "Test_pred" ="black")) +
  labs(title = "rf-Train/Test and validation", 
       x = "DATE", y = "DENSITY") +
  theme_minimal()
prf

# 计算误差
rf_test |>
  metrics(DENSITY, .pred)

library(patchwork)
pbt + prf

# 不同算法的比较

# 创建一个Modeltime Table
model_tbl <- modeltime_table(
  bt,  rf) #把模型放在里面

model_tbl

# 
calibrated_tbl <- model_tbl |>
  modeltime_calibrate(new_data = test_data)  #新的测试集

calibrated_tbl 

# 模型评价
calibrated_tbl |>
  modeltime_accuracy(test_data) |>
  arrange(rmse)

# 绘图
calibrated_tbl |>
  modeltime_forecast(
    new_data    = test_data,
    actual_data = densitytk_ts,
    keep_data   = TRUE 
  ) |>
  plot_modeltime_forecast(
    .facet_ncol         = 2, 
    .conf_interval_show = FALSE,
    .interactive        = TRUE
  )

# 保存workflows

workflow_Doubs <- list(
    workflows = list(
    wflw_random_forest = rf,
    wflw_xgboost = bt
      ),
    calibration = list(calibration_tbl = calibrated_tbl)
  )

workflow_Doubs |>
  write_rds("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202410\\workflows_Doubs_list.rds")  #保存下来




