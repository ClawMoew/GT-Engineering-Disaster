#!/bin/bash

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 
# 00. installer file and path variables. 
# 
## 


# working directory. 
defaultUserHomeDir=/home/[USER_REDACTED]
# set working directory. 
deployWorkingDir=$(pwd)
tmpInstallConfigFileDir=


# installer script files. 
installScript01=EvMgmtStd_install_01_system.sh
installScript02=EvMgmtStd_install_02_nvm.sh
installScript03=EvMgmtStd_install_03_evmgmt.sh
installScript04=EvMgmtStd_install_04_license.sh
installScript04Bin=EvMgmtStd_install_04_license.bin

#script00Version=00_EvMgmtStd_versions.sh
#script00FileList=00_EvMgmtStd_file_list.sh
#script00ProgressFlag=00_EvMgmtStd_progress_flag.sh
#script00Variables=00_EvMgmtStd_variables.sh


# system service file path.
mysqldConfigFile=/etc/mysql/mysql.conf.d/mysqld.cnf
mysqldConfigFileBak=/etc/mysql/mysql.conf.d/mysqld.cnf.bak
redisConfigFile=/etc/redis/redis.conf
redisConfigFileBak=/etc/redis/redis.conf.old
redisServiceFile=/lib/systemd/system/redis-server.service
redisServiceFileBak=/lib/systemd/system/redis-server.service.old
dockerServiceFile=/lib/systemd/system/docker.service
dockerServiceFileBak=/lib/systemd/system/docker.service.old
dockerDaemonJsonFile=/etc/docker/daemon.json


# deploy file. 
#compressedInstallerFile=EV_Mgmt_Std_Deploy_v.1.4.0_YYYYMMDD.zip
compressedInstallerFilePrefix=EV_Mgmt_Std_Deploy_
compressedInstallerFileBakPostfix=_installed.zip
install_config_file=evmstd_install_config.txt
mac_address_list_file=mac.list


# docker image file prefix. 
dockerImgFilePrefixMySQL=mysql_
dockerImgFilePrefixRedis=
dockerImgFilePrefixMongo=mongodb_
dockerImgFilePrefixNginx=nginx_
dockerImgFilePrefixEmAPI=em-ocos-api_
dockerImgFilePrefixEmUI=em-ocos_
#dockerImgFilePrefixWrapperAPI=ev-solution-api-pro_
dockerImgFilePrefixWrapperAPI=ev-solution-api-deploy_
dockerImgFilePrefixMqttProxy=ev-mqtt-proxy_
dockerImgFilePrefixWebAPI=chargermgmtstd_
dockerImgFilePrefixWebUI=charger_management_frontend_std_


# file path.
path_db_backup=mysql_backup_scripts_std
path_db_backup_mongo=mongodb_backup_scripts_std
path_log_retrieve=log_retrieve_scripts_std
path_gen_mac=gen_mac_scripts_std
path_dbScript=db_script_files
path_docker_compose_files=docker_compose_files
path_docker_image_files=docker_img_files
file_docker_compose_file=docker-compose.yml
file_docker_compose_file_upd_bak=docker-compose.yml.upd.bak
file_docker_compose_file_patch_bak=docker-compose.yml.patch.bak
file_nginx_config_file=default.conf
file_appsetting_config_file=appsettings.json

# db backup script.
file_script_db_backup_webapi=mysql_backup_db_webapi.sh
file_script_db_restore_webapi=mysql_restore_db_webapi.sh
file_script_db_backup_evcore=mysql_backup_db_evcore.sh
file_script_db_restore_evcore=mysql_restore_db_evcore.sh
file_script_db_backup_auth=mysql_backup_db_auth.sh
file_script_db_restore_auth=mysql_restore_db_auth.sh
file_script_db_backup_cron=set_crontab_mysql_backup.sh
file_script_db_mongo_backup_auth=mongodb_backup_db_auth.sh
file_script_db_mongo_restore_auth=mongodb_restore_db_auth.sh
file_script_db_mongo_backup_cron=set_crontab_mongodb_backup.sh

# log retrieve script.
file_script_log_retrieve_std=log_retrieve_std.sh
file_script_gen_mac_std=gen_mac_file_std.sh
file_script_gen_mac_std_cron=set_crontab_gen_mac.sh


# install path. 
path_opt=/opt
path_delta=delta
install_root_path=$path_opt/$path_delta
install_path_docker_img=$install_root_path/docker_img


# ev-core file path. 
install_tar_file_ev_core=ev-solution-services-2021-10-24-223303.tar.gz
#install_tar_file_ev_core=ev-solution-services-2021-10-24-223303.tgz
file_script_ev_core_add_site=add_site.sh
file_script_ev_core_add_site_bak=add_site.sh.old
file_script_ev_core_add_site_tmp=add_site.sh.tmp
file_script_ev_core_init_db_premise=init_db_premise.sh
file_script_ev_core_init_db_premise_bak=init_db_premise.sh.old
file_script_ev_core_init_db_premise_tmp=init_db_premise.sh.tmp
file_script_ev_core_install_premise=install_premise.sh
file_config_ev_core_ocpp_srv_default_js=default.js
file_config_ev_core_ocpp_srv_default_js_old=default.js.old
systemLogRotateFileEvCore=/etc/logrotate.d/ev-management-core
pm2_systemd_service_name=pm2-administrator
pm2_systemd_service_file=/etc/systemd/system/pm2-administrator.service
pm2_systemd_service_file_bak=/etc/systemd/system/pm2-administrator.service.bak

# install file path ev-core.
install_path_ev_core=$install_root_path/apps
install_path_ev_core_api_gw=$install_path_ev_core/ev-solution-api-gateway
install_path_ev_core_device_mgmt=$install_path_ev_core/ev-solution-device-management
install_path_ev_core_data_collect=$install_path_ev_core/ev-solution-data-collector
install_path_ev_core_ocpp_srv=$install_path_ev_core/ev-solution-ocpp16-server
install_path_ev_core_ocpp_srv_config=$install_path_ev_core/ev-solution-ocpp16-server/config
install_path_ev_core_power_mgmt=$install_path_ev_core/ev-solution-power-management
install_path_ev_core_realtime_svc=$install_path_ev_core/ev-solution-realtime-service
install_path_ev_core_remote_ctrl=$install_path_ev_core/ev-solution-remote-control


# auth server file path. 
path_auth_deploy=auth_deploy_20210819
file_dbScript_auth_create_acccount=$path_auth_deploy/DeltaGridEM_Initial.sql
file_dbScript_auth_create_table=$path_auth_deploy/DeltaGridEM_CreateTables.sql
file_dbScript_auth_create_table_form=$path_auth_deploy/Form_CreateTables.sql
file_config_auth_nginx=$path_auth_deploy/nginx/conf.d/default.conf
file_config_auth_nginx_bak=$path_auth_deploy/nginx/conf.d/default.conf_old
#file_docker_compose_file_auth=$path_auth_deploy/docker-compose.yml
#file_docker_compose_file_auth_bak=$path_auth_deploy/docker-compose.yml_old
file_docker_compose_file_auth=$path_docker_compose_files/em/docker-compose.yml
file_docker_compose_file_auth_bak=$path_docker_compose_files/em/docker-compose.yml_old
file_js_mongo_init_auth=mongodb-initial.js
path_auth_deploy_update_1_4_41=$path_auth_deploy/v1.4.41
file_js_mongo_upd_1_4_41_auth=v1.4.41_mongo_update.js
file_dbScript_auth_update_1_4_41_1=$path_auth_deploy_update_1_4_41/v1.4.41_mysql_update_01.sql
file_dbScript_auth_update_1_4_41_2=$path_auth_deploy_update_1_4_41/v1.4.41_mysql_update_02.sql
path_auth_deploy_update_1_4_43=$path_auth_deploy/v1.4.43
file_dbScript_auth_update_1_4_43=$path_auth_deploy_update_1_4_43/v1.4.43_mysql_update.sql
path_auth_deploy_update_1_4_47=$path_auth_deploy/v1.4.47
file_dbScript_auth_update_1_4_47=$path_auth_deploy_update_1_4_47/v1.4.47_mysql_update.sql

# install file path auth server.
install_path_auth_srv=$install_root_path/em
install_path_auth_srv_mysql=$install_path_auth_srv/data/mysql
install_path_auth_srv_mongo=$install_path_auth_srv/data/mongodb
install_path_auth_srv_redis=$install_path_auth_srv/data/redis
install_path_auth_srv_nginx=$install_path_auth_srv/data/nginx/conf.d
install_path_auth_srv_log=$install_path_auth_srv/data/em-api-logs


# wrapper api file path.
file_docker_compose_file_wrapper_api=$path_docker_compose_files/ev-solution-api/docker-compose.yml
file_docker_compose_file_wrapper_api_bak=$path_docker_compose_files/ev-solution-api/docker-compose.yml_old

# install file path wrapper api.
install_path_wrap_api=$install_root_path/ev-solution-api


# mqtt proxy file path.
file_docker_compose_file_mqtt_proxy=$path_docker_compose_files/ev-mqtt-proxy/docker-compose.yml
file_docker_compose_file_mqtt_proxy_bak=$path_docker_compose_files/ev-mqtt-proxy/docker-compose.yml_old

# install file path mqtt proxy.
install_path_mqtt_proxy=$install_root_path/ev-mqtt-proxy
install_path_mqtt_proxy_log=$install_path_mqtt_proxy/logs
install_path_mqtt_proxy_cert=$install_path_mqtt_proxy/cert


# web api file path. 
file_dbScript_chargeMgmtStd_create_account=$path_dbScript/1_ChargerMgmtStd_Create_DB_and_User.sql
file_dbScript_chargeMgmtStd_create_table=$path_dbScript/2_ChargerMgmtStd_Create_Tables.sql
file_dbScript_chargeMgmtStd_create_table_bak=$path_dbScript/2_ChargerMgmtStd_Create_Tables.sql.old
file_docker_compose_file_web_api=$path_docker_compose_files/chargermgmtstd/docker-compose.yml
file_docker_compose_file_web_api_bak=$path_docker_compose_files/chargermgmtstd/docker-compose.yml_old
file_appsetting_config_file_web_api=$path_docker_compose_files/chargermgmtstd/appsettings.json

# install file path web api.
install_path_cm_std=$install_root_path/chargermgmtstd
#install_path_cm_ui_std=$install_root_path/cm-frontend-std


# install file path backup script.
install_path_db_backup=$install_root_path/$path_db_backup
install_path_db_backup_mongo=$install_root_path/$path_db_backup_mongo
install_path_log_retrieve=$install_root_path/$path_log_retrieve
install_path_gen_mac=$install_root_path/$path_gen_mac


# external storage db backup directory. 
external_mnt_pt=/mnt/DataBackupDrive
external_backup_path_mongo_auth=$external_mnt_pt/mongodb_backup_auth
external_backup_path_mysql_webapi=$external_mnt_pt/mysql_backup_webapi
external_backup_path_mysql_auth=$external_mnt_pt/mysql_backup_auth
external_backup_path_mysql_auth_ancillary=$external_backup_path_mysql_auth/ancillary
external_backup_path_mysql_auth_form=$external_backup_path_mysql_auth/form
external_backup_path_mysql_auth_model=$external_backup_path_mysql_auth/model
external_backup_path_mysql_auth_sspl=$external_backup_path_mysql_auth/sspl
external_backup_path_mysql_auth_web=$external_backup_path_mysql_auth/web
external_backup_path_mysql_auth_widget=$external_backup_path_mysql_auth/widget
external_backup_path_mysql_evcore=$external_mnt_pt/mysql_backup_evcore
external_backup_path_mysql_evcore_data=$external_backup_path_mysql_evcore/data
external_backup_path_mysql_evcore_device=$external_backup_path_mysql_evcore/device
external_backup_path_mysql_evcore_gateway=$external_backup_path_mysql_evcore/gateway
external_backup_path_mysql_evcore_ocpp16=$external_backup_path_mysql_evcore/ocpp16
external_backup_path_mysql_evcore_power=$external_backup_path_mysql_evcore/power
external_backup_path_mysql_evcore_realtime=$external_backup_path_mysql_evcore/realtime
external_backup_path_mysql_evcore_remote=$external_backup_path_mysql_evcore/remote


# ---------------------------------------------------------

compressedUpdaterFilePrefix=EV_Mgmt_Std_Update_
compressedUpdaterFileBakPostfix=_installed.zip
compressedPatcherFilePrefix=EV_Mgmt_Std_Patch_

preInstallSrcDir=

preInstallConfigFile=
newInstallConfigFile=


# upgrader script files.
upgScript_111_144=upgrade_from_v.1.1.1_to_v.1.4.4.sh
upgScript_121_144=upgrade_from_v.1.2.1_to_v.1.4.4.sh
upgScript_130_144=upgrade_from_v.1.3.0_to_v.1.4.4.sh
upgScript_131_144=upgrade_from_v.1.3.1_to_v.1.4.4.sh
upgScript_132_144=upgrade_from_v.1.3.2_to_v.1.4.4.sh
upgScript_140_144=upgrade_from_v.1.4.0_to_v.1.4.4.sh
upgScript_141_144=upgrade_from_v.1.4.1_to_v.1.4.4.sh
upgScript_142_144=upgrade_from_v.1.4.2_to_v.1.4.4.sh
upgScript_143_144=upgrade_from_v.1.4.3_to_v.1.4.4.sh


# patch script files.
patchScript_144_144hf1=patch_from_v.1.4.4_to_v.1.4.4.hf1.sh
patchScript_144_144hf2=patch_from_v.1.4.4_to_v.1.4.4.hf2.sh
patchScript_144_144hf3=patch_from_v.1.4.4_to_v.1.4.4.hf3.sh
patchScript_144_144hf4=patch_from_v.1.4.4_to_v.1.4.4.hf4.sh
patchScript_144_144hf5=patch_from_v.1.4.4_to_v.1.4.4.hf5.sh
patchScript_144_144hf6=patch_from_v.1.4.4_to_v.1.4.4.hf6.sh
patchScript_144_144hf7=patch_from_v.1.4.4_to_v.1.4.4.hf7.sh
patchScript_144_144hf8=patch_from_v.1.4.4_to_v.1.4.4.hf8.sh
patchScript_144hf1_144hf2=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf2.sh
patchScript_144hf1_144hf3=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf3.sh
patchScript_144hf1_144hf4=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf4.sh
patchScript_144hf1_144hf5=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf5.sh
patchScript_144hf1_144hf6=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf6.sh
patchScript_144hf1_144hf7=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf7.sh
patchScript_144hf1_144hf8=patch_from_v.1.4.4.hf1_to_v.1.4.4.hf8.sh
patchScript_144hf2_144hf3=patch_from_v.1.4.4.hf2_to_v.1.4.4.hf3.sh
patchScript_144hf2_144hf4=patch_from_v.1.4.4.hf2_to_v.1.4.4.hf4.sh
patchScript_144hf2_144hf5=patch_from_v.1.4.4.hf2_to_v.1.4.4.hf5.sh
patchScript_144hf2_144hf6=patch_from_v.1.4.4.hf2_to_v.1.4.4.hf6.sh
patchScript_144hf2_144hf7=patch_from_v.1.4.4.hf2_to_v.1.4.4.hf7.sh
patchScript_144hf2_144hf8=patch_from_v.1.4.4.hf2_to_v.1.4.4.hf8.sh
patchScript_144hf3_144hf4=patch_from_v.1.4.4.hf3_to_v.1.4.4.hf4.sh
patchScript_144hf3_144hf5=patch_from_v.1.4.4.hf3_to_v.1.4.4.hf5.sh
patchScript_144hf3_144hf6=patch_from_v.1.4.4.hf3_to_v.1.4.4.hf6.sh
patchScript_144hf3_144hf7=patch_from_v.1.4.4.hf3_to_v.1.4.4.hf7.sh
patchScript_144hf3_144hf8=patch_from_v.1.4.4.hf3_to_v.1.4.4.hf8.sh
patchScript_144hf4_144hf5=patch_from_v.1.4.4.hf4_to_v.1.4.4.hf5.sh
patchScript_144hf4_144hf6=patch_from_v.1.4.4.hf4_to_v.1.4.4.hf6.sh
patchScript_144hf4_144hf7=patch_from_v.1.4.4.hf4_to_v.1.4.4.hf7.sh
patchScript_144hf4_144hf8=patch_from_v.1.4.4.hf4_to_v.1.4.4.hf8.sh
patchScript_144hf5_144hf6=patch_from_v.1.4.4.hf5_to_v.1.4.4.hf6.sh
patchScript_144hf5_144hf7=patch_from_v.1.4.4.hf5_to_v.1.4.4.hf7.sh
patchScript_144hf5_144hf8=patch_from_v.1.4.4.hf5_to_v.1.4.4.hf8.sh
patchScript_144hf6_144hf7=patch_from_v.1.4.4.hf6_to_v.1.4.4.hf7.sh
patchScript_144hf6_144hf8=patch_from_v.1.4.4.hf6_to_v.1.4.4.hf8.sh
patchScript_144hf7_144hf8=patch_from_v.1.4.4.hf7_to_v.1.4.4.hf8.sh


# update db schema script files. 
file_update_db_script_1_3_1=update_schema_v.1.3.1.sql
file_update_db_script_1_4_0=update_schema_v.1.4.0.sql
file_update_db_script_1_4_1=update_schema_v.1.4.1.sql
file_update_db_script_1_4_3=update_schema_v.1.4.3.sql
file_update_db_script_1_4_4=update_schema_v.1.4.4.sql


# for crontab. 
script_file_webapi=$install_path_db_backup/$file_script_db_backup_webapi
script_file_evcore=$install_path_db_backup/$file_script_db_backup_evcore
script_file_auth=$install_path_db_backup/$file_script_db_backup_auth
script_file_auth_mongo=$install_path_db_backup_mongo/$file_script_db_mongo_backup_auth

