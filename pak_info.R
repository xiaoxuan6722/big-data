#---------------------------------
#Script Name
#Purpose:
#Author:  Xiaoxuan Liu
#Email:  liuxiaoxuan@mail.ustc.edu.cn
#Date:  '2024/03/14'
#
#-------------------------------
  cat("\014") #clears the console
rm(list = ls()) #remove all variables

install.packages("tidyverse")#安装R包
library(tidyverse)  #加载包
help(package="tidyverse")#遇到不会用的包可以查找帮助信息
demo(package="tidyverse")#找包应用的实例

#查找帮助
apropos("^tidyverse")
ls("package:tidyverse")
help.search("^tidyverse")
