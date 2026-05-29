#!/bin/bash

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 
# 00. program variables. 
# 
## 


# system service variables.
mysqlServiceName=mysql.service
mysqldConfigExpireLogsDays=expire_logs_days
mysqldConfigExpireLogsDaysValue=7
redisServiceName=redis-server.service
dockerServiceName=docker.service


# install variables.
userInput=
repackInstaller=y
computerBrandName=
computerModelName=
computerSn=
localTimeSpan=
cpoId=
cpoName=
siteId=
siteName=
iotHubDeviceName=
mqttProxyClientId=
mqttProxyClientIdPrefix=EVCM-STD-
maxAllowedChargers=
maxAllowedChargersDefault=20
maxAllowedChargersSystem=200
ocppPort=
ocppPortDefault=3700
macAddress=
mysqlRootPASS=[REDACTED]
mysqlRootPassDefault=[DEFAULT_CREDENTIAL_REDACTED]
dockerIpRange=
dockerIpRangeDefault=172.17.0.0
dockerIpGateway=
dockerIpGatewayDefault=172.17.0.1
dockerImgLocalFile=true
dockerImgRepoUrl=
dockerImgRepoLogin=
dockerImgRepoPASS=[REDACTED]
dockerImgRepoUrlDefault=https://sgc-dev-registry.deltaww.com
dockerImgRepoLoginDefault=
dockerImgRepoPassDefault=

installDT=
currentYear=


# predefine text replacement constant.
label_CHANGE_LOCAL_TIME_SPAN=CHANGE_LOCAL_TIME_SPAN
label_CHANGE_CPO_ID_NUMBER=CHANGE_CPO_ID_NUMBER
label_CHANGE_CPO_NAME=CHANGE_CPO_NAME
label_CHANGE_SITE_ID_NUMBER=CHANGE_SITE_ID_NUMBER
label_CHANGE_SITE_NAME=CHANGE_SITE_NAME
label_CHANGE_MYSQL_ROOT_PASSWD=[REDACTED]
label_CHANGE_SERVER_IP=CHANGE_SERVER_IP
label_CHANGE_VERSION_MYSQL=CHANGE_VERSION_MYSQL
label_CHANGE_VERSION_REDIS=CHANGE_VERSION_REDIS
label_CHANGE_VERSION_MONGO=CHANGE_VERSION_MONGO
label_CHANGE_VERSION_NGINX=CHANGE_VERSION_NGINX
label_CHANGE_VERSION_EM_API=CHANGE_VERSION_EM_API
label_CHANGE_VERSION_EM_UI=CHANGE_VERSION_EM_UI
label_CHANGE_VERSION_WRAPPER_API=CHANGE_VERSION_WRAPPER_API
label_CHANGE_VERSION_MQTT_PROXY=CHANGE_VERSION_MQTT_PROXY
label_CHANGE_VERSION_WEB_API=CHANGE_VERSION_WEB_API
label_CHANGE_VERSION_WEB_UI=CHANGE_VERSION_WEB_UI
label_CHANGE_YEAR=CHANGE_YEAR


# ---------------------------------------------------------

isRemoteSession=0
crontab_cmd_list=


# upgrade variables.
dockerComposeFileImgVarSearchKeyWrapperAPI="sgc-dev-registry.deltaww.com\/ev-solution-api-deploy:"
dockerComposeFileImgVarReplaceKeyWrapperAPI="sgc-registry.deltaww.com\/deltagrid-ev\/ev-solution-api-deploy:"
dockerComposeFileImgVarSearchKeyMqttProxy="sgc-dev-registry.deltaww.com\/ev-mqtt-proxy:"
dockerComposeFileImgVarSearchKeyWebAPI="sgc-dev-registry.deltaww.com\/chargermgmtstd:"
dockerComposeFileImgVarSearchKeyWebUI="sgc-dev-registry.deltaww.com\/charger_management_frontend_std:"
dockerComposeFileImgVarSearchKey2WebUI="sgc-registry.deltaww.com\/deltagrid-ap\/ev-on-premise\/frontend:"
dockerComposeFileImgVarReplaceKeyWebUI="sgc-registry.deltaww.com\/deltagrid-ap\/ev-on-premise\/frontend:"
dockerComposeFileImgVarSearchKeyEmAPI="sgc-dev-registry.deltaww.com\/sgc2019-ocos-api:"
dockerComposeFileDbVarSearchKeyWebAPI="EM_MYSQL_DB="
dockerComposeFileDbVarReplaceKeyWebAPI="EM_MYSQL_DB=Server=$dockerIpGateway;Port=3306;Database=ChargeMgmt;Uid=chargemgmt;PWD=[REDACTED]
dbVarAppendSettingTimeout="Connection Timeout=120;default command timeout=600;"


