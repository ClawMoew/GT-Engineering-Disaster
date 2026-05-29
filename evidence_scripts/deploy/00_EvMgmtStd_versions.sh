#!/bin/bash

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 
# 00. Versions Variables. 
# 
## 


# version number variables.
verNumb_1_1_1=v.1.1.1
verNumb_1_2_1=v.1.2.1
verNumb_1_3_0=v.1.3.0
verNumb_1_3_1=v.1.3.1
verNumb_1_3_2=v.1.3.2
verNumb_1_4_0=v.1.4.0
verNumb_1_4_1=v.1.4.1
verNumb_1_4_2=v.1.4.2
verNumb_1_4_3=v.1.4.3
verNumb_1_4_4=v.1.4.4
verNumb_1_4_4_hf1=v.1.4.4.hf1
verNumb_1_4_4_hf2=v.1.4.4.hf2
verNumb_1_4_4_hf3=v.1.4.4.hf3
verNumb_1_4_4_hf4=v.1.4.4.hf4
verNumb_1_4_4_hf5=v.1.4.4.hf5
verNumb_1_4_4_hf6=v.1.4.4.hf6
verNumb_1_4_4_hf7=v.1.4.4.hf7

oldVerNumb=$verNumb_1_1_1
newVerNumb=$verNumb_1_4_4_hf7

verNumber=$verNumb_1_4_4_hf7


# mysql version.
#mysqlConfigVersionUrl=https://dev.mysql.com/get/mysql-apt-config_0.8.24-1_all.deb
#mysqlConfigVersionFile=mysql-apt-config_0.8.24-1_all.deb
mysqlConfigVersionUrl=https://dev.mysql.com/get/mysql-apt-config_0.8.29-1_all.deb
mysqlConfigVersionFile=mysql-apt-config_0.8.29-1_all.deb

mysqlWrokBenchVersionUrl=https://downloads.mysql.com/archives/get/p/8/file/mysql-workbench-community_8.0.29-1ubuntu20.04_amd64.deb
mysqlWorkBenchVersionFile=mysql-workbench-community_8.0.29-1ubuntu20.04_amd64.deb


# docker image version.
#dockerImgVerMySQL=8.0.21
#dockerImgFileVerMySQL=8_0_21

#dockerImgVerRedis=
#dockerImgFileVerRedis=

dockerImgVerMongo=4.0.18
dockerImgFileVerMongo=4_0_18

dockerImgVerNginx=1.21.0-alpine
dockerImgFileVerNginx=1_21_0

dockerImgVerEmAPI=1.4.47.3
dockerImgFileVerEmAPI=1_4_47_3

dockerImgVerEmUI=4.0.39
dockerImgFileVerEmUI=4_0_39

# Web UI version. 
dockerImgVerWebUI=1.4.5.1
dockerImgFileVerWebUI=1_4_5_1

# Wrapper API version. 
dockerImgVerWrapperAPI=0.1.67
dockerImgFileVerWrapperAPI=0_1_67

# MQTT Proxy Version. 
dockerImgVerMqttProxy=0.0.12
dockerImgFileVerMqttProxy=0_0_12

# Web API Version. 
dockerImgVerWebAPI=0.2.33
dockerImgFileVerWebAPI=0_2_33

