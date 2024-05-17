#---------------------------------
#Script Name
#Purpose:
#1. 沿着Doubs河设置2公里的缓冲区，并从地图上截取，使用qgisprocess包
#2提取每个点的集水区和坡度的栅格值。
#3将提取的数据与Doubs数据集中的其他环境因素合并形成一个数据框，最后将该数据框传递给一个包含几何列的sf对象。

#Author:  Xiaoxuan Liu
#Email:    liuxiaoxuan@mail.ustc.edu.cn
#Date:    2024-04-23
#
#-------------------------------
cat("\014") #clears the console
rm(list = ls()) #remove all variables

install.packages("terra")
install.packages("sf")
install.packages("raster")
install.packages("elevatr")


file.choose()
#加载QGIS下载的doubs_river.shp数据
library(sf)
doubs_river <- st_read("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_river.shp")
head(doubs_river)

#下载doubs_river的高程数据（z : 要返回的缩放级别。变焦范围从1到14）
library(elevatr)
elevation <-get_elev_raster(doubs_river,z=10)
elevation

#输出doubs_river高程数据到本地
library(terra)
terra::writeRaster(elevation, "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_dem.tif",
                   filetype="GTiff",overwrite=TRUE)

#输入doubs河的高程、河流和采样点数据
doubs_dem <- terra::rast("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_dem.tif")
doubs_river <- sf::st_read("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_river.shp")
doubs_pts <- sf::st_read("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_point.shp")
doubs_pts1 <- sf::st_read("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\08\\doubs_point1.shp")

#地理坐标系转换为投影坐标系
doubs_river_utm <- st_transform(doubs_river, 32631)
#32631是从QGIS中获得获得的EPSG代码，代表了一个特定的UTM区域

#创建和可视化buffer
doubs_river_buff <- st_buffer(doubs_river_utm,dis=2000) 
plot(st_geometry(doubs_river_buff),axes=TRUE)  #可视化

library(ggplot2)
ggplot()+geom_sf(data=doubs_river_buff)


#裁切doubs河dem数据

#读取数据
doubs_dem <- terra::rast("F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_dem.tif")
#查看dem坐标系
terra::crs(doubs_dem) 
#输出结果  .....ID[\"EPSG\",4326]]"
#(sf包中查看sf文件坐标系的函数sf::st_crs)

#定义一个投影坐标系
utm_crs <-"EPSG:32631"
doubs_dem_utm <- terra::project(doubs_dem, utm_crs)
terra::crs(doubs_dem_utm) 
#输出结果  .....ID[\"EPSG\",32631]
#(转换坐标系：栅格数据转换用project  67行，矢量数据用st_transform  45行)

#clip and intersect dem by doubs river
library(raster)
doubs_dem_utm_cropped = crop(doubs_dem_utm,doubs_river_buff)
#doubs_dem_utm 地图，用doubs_river_buff裁切

#保留裁切的部分
doubs_dem_utm_masked = mask(doubs_dem_utm_cropped , doubs_river_buff)

#可视化
plot(doubs_dem_utm_masked, axes=TRUE)



#提取点的栅格值
install.packages("qgisprocess")
library(qgisprocess)
library(dplyr)

#查找wetness相关算法
#wetness关键词
qgis_search_algorithms("wetness") |>
  dplyr::select(provider_title, algorithm) |>
  head(2)

######计算集水区坡度及集水区面积
# 指定正式文件的存储路径和文件名
slope_file_path <- "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\slope.sdat"
area_file_path <- "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\area.sdat"

# 运行算法，使用正式文件路径而不是临时文件
topo_total <- qgisprocess::qgis_run_algorithm(
  alg = "sagang:sagawetnessindex",
  DEM = doubs_dem_utm_masked,
  SLOPE_TYPE = 1,
  SLOPE = slope_file_path,  # 使用正式文件路径
  AREA = area_file_path,    # 使用正式文件路径
  .quiet = TRUE
)
# topo_total=qgisprocess::qgis_run_algorithm(
#  alg="sagang:sagawetnessindex",
#  DEM=doubs_dem_utm_masked, 
#  SLOPE_TYPE=1,
#  SLOPE= tempfile(fileext = ".sdat"),
#  AREA= tempfile(fileext = ".sdat"),
#  .quiet=TRUE)

topo_total<- c(
  AREA = "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\area.sdat" ,
  SLOPE = "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\slope.sdat"
)
#提取集水区面接和坡度
library(terra)

topo_select<- topo_total[c("AREA","SLOPE")] |>   #提取元素
  unlist()|>  #将列表或向量转换为一个原子向量
  rast()  #从向量创建一个栅格对象
class(topo_select) 


topo_select<- rast(topo_select)
#设置名称
names(topo_select)=c("carea","cslope")  
#origin()函数用于提取栅格数据集的原点坐标，
origin(topo_select)=origin(doubs_dem_utm_masked)  

#将两个格栅数据进行合并
topo_char = c(doubs_dem_utm_masked,topo_select)


#将点转换为utm坐标系
doubs_pts_utm <- sf::st_transform(doubs_pts,32631)
#查看维度
dim(doubs_pts_utm )
#保存文件
st_write(doubs_pts_utm, "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_pts_utm.shp")


#提取格栅数据值
#extract()函数将为doubs_pts_utm中的每个几何要素提取与之对应的栅格值。
topo_env <-terra::extract(topo_char, #从第一个文件中提取
                          doubs_pts_utm,
                          ID=FALSE)  #不输出ID列



####
#合并数据
library(ade4)
data(doubs)
water_env<-doubs$env
doubs_env <- cbind(doubs_pts_utm, topo_env, water_env)
st_write(doubs_env, "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_env.csv")
st_write(doubs_env, "F:\\研究生学校与考试\\博一\\大数据生态学研究方法\\homework\\Homework-202408\\doubs_env.shp")
