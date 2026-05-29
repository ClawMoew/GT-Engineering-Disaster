#!/bin/bash
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 03. Install EV Managment Software. 
# Execute this script in console from GUI mode. 
# 
# 
# Site Note:
# set gps of site in auth server 
# [LAT_REDACTED], [LONG_REDACTED]
# 
## 

# After Install Ubuntu Desktop 20.04 LTS with minimal installation. 


# version number variables.
source 00_EvMgmtStd_versions.sh

# installer program variables.
source 00_EvMgmtStd_variables.sh

# installer file and path variables.
source 00_EvMgmtStd_file_list.sh

# installer progress flag variables.
source 00_EvMgmtStd_progress_flag.sh

# installer functions.
source 00_EvMgmtStd_functions.sh


echo "";

##
# check if use sudo. 
funcChkIsNotSudo $installScript03


## 
# initial or check progress file.
funcChkNotStartInstallation

funcChkDoneInstall

# check install config for missing values. 
funcChkInstallConfigFileValues n


## 
# get user entered value back from config file. 
funcReadInstallConfigValueFromFile


##
# Install Charger Management Software. 
##

# install ev solution core
if cat $progress_file | grep -q "$progress_install_evcore"; then
    echo "Install EV Solution Core...";
    if [ ! -f $install_tar_file_ev_core ]; then
        echo "Install EV Solution Core... Failed!  ";
        echo "Unable to find file: $install_tar_file_ev_core";
        echo "";
        exit 1
    fi
    tar -xzf $install_tar_file_ev_core -C $install_path_ev_core

    if ! [ $ocppPortDefault == $ocppPort ]; then
        echo "Set OCPP Server Port...";
        if [ ! -f $install_path_ev_core_ocpp_srv_config/$file_config_ev_core_ocpp_srv_default_js ]; then
            echo "Install EV Solution Core... Failed!  ";
            echo "Unable to find file: $install_path_ev_core_ocpp_srv_config/$file_config_ev_core_ocpp_srv_default_js";
            echo "";
            exit 1
        fi
        cp $install_path_ev_core_ocpp_srv_config/$file_config_ev_core_ocpp_srv_default_js $install_path_ev_core_ocpp_srv_config/$file_config_ev_core_ocpp_srv_default_js_old
        sed -i "s/$ocppPortDefault/$ocppPort/g" $install_path_ev_core_ocpp_srv_config/$file_config_ev_core_ocpp_srv_default_js
        echo "Set OCPP Server Port... done";
    fi

    # modify init_db_premise.sh 
    if [ ! -f $install_path_ev_core/$file_script_ev_core_init_db_premise ]; then
        echo "Install EV Solution Core... Failed!  ";
        echo "Unable to find file: $install_path_ev_core/$file_script_ev_core_init_db_premise";
        echo "";
        exit 1
    fi
    # replace line: MYSQL_CMD="mysql -h $DB_HOST -P 3306 -u $DB_ADMIN -p" 
    #      to line: MYSQL_CMD="mysql -h $DB_HOST -P 3306 -u $DB_ADMIN -pCHANGE_MYSQL_ROOT_PASSWD"
    cp $install_path_ev_core/$file_script_ev_core_init_db_premise $install_path_ev_core/$file_script_ev_core_init_db_premise_bak
    lineNumb=`awk '/MYSQL_CMD=/{ print NR; exit }' $install_path_ev_core/$file_script_ev_core_init_db_premise_bak`
    sed "$lineNumb s/.$//" $install_path_ev_core/$file_script_ev_core_init_db_premise_bak > $install_path_ev_core/$file_script_ev_core_init_db_premise_tmp
    sed "s/^MYSQL_CMD=.*/&CHANGE_MYSQL_ROOT_PASSWD\"/" $install_path_ev_core/$file_script_ev_core_init_db_premise_tmp > $install_path_ev_core/$file_script_ev_core_init_db_premise
    rm $install_path_ev_core/$file_script_ev_core_init_db_premise_tmp
    cp $install_path_ev_core/$file_script_ev_core_init_db_premise $install_path_ev_core/$file_script_ev_core_init_db_premise_bak
    sed -i "s/$label_CHANGE_MYSQL_ROOT_PASSWD/$mysqlRootPass/g" $install_path_ev_core/$file_script_ev_core_init_db_premise

    # modify add_site.sh 
    if [ ! -f $install_path_ev_core/$file_script_ev_core_add_site ]; then
        echo "Install EV Solution Core... Failed!  ";
        echo "Unable to find file: $install_path_ev_core/$file_script_ev_core_add_site";
        echo "";
        exit 1
    fi
    # replace line: SITE_NAME=$1
    #      to line: SITE_NAME=CHANGE_SITE_NAME
    # replace line: INSERT INTO sites (id, name, created_at, updated_at, deleted_at) VALUES (1, '"${SITE_NAME}"', '2021-03-01 00:00:00', '2021-03-01 00:00:006', NULL);
    #      to line: INSERT INTO sites (id, name, created_at, updated_at, deleted_at) VALUES (CHANGE_SITE_ID_NUMBER, 'CHANGE_SITE_NAME', '2021-03-01 00:00:00', '2021-03-01 00:00:006', NULL);
    cp $install_path_ev_core/$file_script_ev_core_add_site $install_path_ev_core/$file_script_ev_core_add_site_bak
    sed "s/^SITE_NAME=.*/SITE_NAME=CHANGE_SITE_NAME/" $install_path_ev_core/$file_script_ev_core_add_site_bak > $install_path_ev_core/$file_script_ev_core_add_site_tmp
    sed "s/^INSERT INTO sites.*/INSERT INTO sites (id, name, created_at, updated_at, deleted_at) VALUES (CHANGE_SITE_ID_NUMBER, \'CHANGE_SITE_NAME\', \'2021-03-01 00:00:00\', \'2021-03-01 00:00:006\', NULL);/" $install_path_ev_core/$file_script_ev_core_add_site_tmp > $install_path_ev_core/$file_script_ev_core_add_site
    rm $install_path_ev_core/$file_script_ev_core_add_site_tmp
    cp $install_path_ev_core/$file_script_ev_core_add_site $install_path_ev_core/$file_script_ev_core_add_site_bak
    sed -i "s/$label_CHANGE_SITE_ID_NUMBER/$siteId/g" $install_path_ev_core/$file_script_ev_core_add_site
    sed -i "s/$label_CHANGE_SITE_NAME/$siteName/g" $install_path_ev_core/$file_script_ev_core_add_site

    if [ ! -f $install_path_ev_core/$file_script_ev_core_install_premise ]; then
        echo "Install EV Solution Core... Failed!  ";
        echo "Unable to find file: $install_path_ev_core/$file_script_ev_core_install_premise";
        echo "";
        exit 1
    fi

    cd $install_path_ev_core
    pwd

    # setup db schema for ev-core.
    ("./$file_script_ev_core_init_db_premise" all)
    sleep 5
    # install ev-core.
    ("./$file_script_ev_core_install_premise" all)
    sleep 10

    pm2 list

    # create site info in ev-core.
    ("./$file_script_ev_core_add_site")
    sleep 5

    pm2 reload all
    sleep 10

    pm2 save

    # register realtime service callbackUrl. 
    echo "";
    echo "Register to EV Core Realtime Service Command: ";
    echo "http POST :6700/realtime-service/v1/clients siteId=$siteId callbackUrl=\"http://127.0.0.1:8000/rt-service\" siteName=$siteName";
    http POST :6700/realtime-service/v1/clients siteId=$siteId callbackUrl="http://127.0.0.1:8000/rt-service" siteName=$siteName
    # check if add to realtime service. 
    http GET :6700/realtime-service/v1/clients
    # prompt for check if registered to realtime service. 
    read -p "Check if registered to realtime service, hit on [Enter] to Continue: " userInput

    cd $deployWorkingDir
    echo "Install EV Solution Core... done";
    echo "";
    echo $progress_set_ev_core_auto_start > $progress_file
fi

# auto start ev solution core
if cat $progress_file | grep -q "$progress_set_ev_core_auto_start"; then
    echo "Set Auto Start EV Solution Core...";

    cd $install_path_ev_core
    pwd

    pm2 list

    #pm2 startup
    #sudo env PATH=$PATH:/home/[USER_REDACTED]/.nvm/versions/node/v12.21.0/bin /home/[USER_REDACTED]/.nvm/versions/node/v12.21.0/lib/node_modules/pm2/bin/pm2 startup systemd -u administrator --hp /home/[USER_REDACTED]
    CmdPm2StartUp=$(pm2 startup | tail -1)
    echo "CMD: $CmdPm2StartUp";
    ($CmdPm2StartUp)

    sleep 10
    pm2 save

    sleep 2
    SudoCmd="sudo systemctl enable $pm2_systemd_service_name"
    echo "CMD: $SudoCmd";
    ($SudoCmd)

    cd $deployWorkingDir
    echo "Set Auto Start EV Solution Core... done";
    echo "";
    echo $progress_set_pm2_service > $progress_file
fi

# set delay start on ev solution core 
if cat $progress_file | grep -q "$progress_set_pm2_service"; then
    if [ -f $pm2_systemd_service_file ]; then
        echo "Set EV Solution Core delay start...";
        #sudo cp $pm2_systemd_service_file $pm2_systemd_service_file_bak
        #sudo sed "s/^After=.*/& $redisServiceName/" $pm2_systemd_service_file_bak > $pm2_systemd_service_file
        #sudo sed -i 's/^After=.*/& '"$redisServiceName"'/' $pm2_systemd_service_file
        #sudo rm $pm2_systemd_service_file_bak
        SudoCmd="sudo cp $pm2_systemd_service_file $pm2_systemd_service_file_bak"
        echo "CMD: $SudoCmd";
        ($SudoCmd)
        SudoCmd="sudo sed -i 's/^After=.*/& '\"$redisServiceName\"'/' $pm2_systemd_service_file"
        echo "CMD: $SudoCmd";
        `sudo sed -i 's/^After=.*/& '"$redisServiceName"'/' $pm2_systemd_service_file`

        SudoCmd="sudo sed -i 's/Restart=.*/Restart=always/' $pm2_systemd_service_file"
        echo "CMD: $SudoCmd";
        `sudo sed -i 's/Restart=.*/Restart=always/' $pm2_systemd_service_file`

        SudoCmd="sudo rm $pm2_systemd_service_file_bak"
        echo "CMD: $SudoCmd";
        ($SudoCmd)
        echo "Set EV Solution Core delay start... done";
        echo "";
    else
        echo "Set EV Solution Core delay start... Failed!  ";
        echo "Unable to find file: $pm2_systemd_service_file";
        echo "";
        exit 1
    fi
    echo $progress_setup_db_web_api > $progress_file
fi

# load db schema for web api. 
if cat $progress_file | grep -q "$progress_setup_db_web_api"; then
    if [ -f $file_dbScript_chargeMgmtStd_create_account ]; then
        echo "Create DB User for Charger Management Web API...";
        mysql -uroot -p$mysqlRootPass < $file_dbScript_chargeMgmtStd_create_account
        echo "Create DB User for Charger Management Web API... done";
        echo "";
    else
        echo "Create DB User for Charger Management Web API... Failed!  ";
        echo "Unable to find file: $file_dbScript_chargeMgmtStd_create_account";
        echo "";
        exit 1
    fi
    if [ -f $file_dbScript_chargeMgmtStd_create_table ]; then
        echo "Create DB Schema for Charger Management Web API...";
        cp $file_dbScript_chargeMgmtStd_create_table $file_dbScript_chargeMgmtStd_create_table_bak
        sed -i "s/$label_CHANGE_CPO_ID_NUMBER/$cpoId/g" $file_dbScript_chargeMgmtStd_create_table
        sed -i "s/$label_CHANGE_CPO_NAME/$cpoName/g" $file_dbScript_chargeMgmtStd_create_table
        sed -i "s/$label_CHANGE_SITE_ID_NUMBER/$siteId/g" $file_dbScript_chargeMgmtStd_create_table
        sed -i "s/$label_CHANGE_SITE_NAME/$siteName/g" $file_dbScript_chargeMgmtStd_create_table
        currentYear=$(date +'%Y')
        sed -i "s/$label_CHANGE_YEAR/$currentYear/g" $file_dbScript_chargeMgmtStd_create_table
        mysql -uchargemgmt -p[DEFAULT_CREDENTIAL_REDACTED] < $file_dbScript_chargeMgmtStd_create_table
        echo "Create DB Schema for Charger Management Web API... done";
        echo "";
    else
        echo "Create DB Schema for Charger Management Web API... Failed!  ";
        echo "Unable to find file: $file_dbScript_chargeMgmtStd_create_table";
        echo "";
        exit 1
    fi
    echo $progress_setup_docker_compose_web_api > $progress_file
fi

# modify and copy docker-compose file for web api. 
if cat $progress_file | grep -q "$progress_setup_docker_compose_web_api"; then
    if [ -f $file_docker_compose_file_web_api ]; then
        echo "Config Docker Compose File for Charger Management Web API...";
        cp $file_docker_compose_file_web_api $file_docker_compose_file_web_api_bak
        sed -i "s/$label_CHANGE_VERSION_WEB_API/$dockerImgVerWebAPI/g" $file_docker_compose_file_web_api
        sed -i "s/$label_CHANGE_SERVER_IP/$dockerIpGateway/g" $file_docker_compose_file_web_api
        sed -i "s/$label_CHANGE_CPO_ID_NUMBER/$cpoId/g" $file_docker_compose_file_web_api
        sed -i "s/$label_CHANGE_SITE_ID_NUMBER/$siteId/g" $file_docker_compose_file_web_api
        sed -i "s/$label_CHANGE_LOCAL_TIME_SPAN/$localTimeSpan/g" $file_docker_compose_file_web_api
        cp $file_docker_compose_file_web_api $install_path_cm_std/$file_docker_compose_file
        echo "Config Docker Compose File for Charger Management Web API... done";
        echo "";
    else
        echo "Config Docker Compose File for Charger Management Web API... Failed!  ";
        echo "Unable to find file: $file_docker_compose_file_web_api";
        echo "";
        exit 1
    fi
    if [ -f $file_appsetting_config_file_web_api ]; then
        echo "Copy AppSetting Config File for Charger Management Web API...";
        cp $file_appsetting_config_file_web_api $install_path_cm_std/$file_appsetting_config_file
        sed -i "s/$label_CHANGE_SERVER_IP/$dockerIpGateway/g" $install_path_cm_std/$file_appsetting_config_file
        echo "Copy AppSetting Config File for Charger Management Web API... done";
        echo "";
    else
        echo "Copy AppSetting Config File for Charger Management Web API... Failed!  ";
        echo "Unable to find file: $file_appsetting_config_file_web_api";
        echo "";
        exit 1
    fi
    echo $progress_setup_docker_compose_wrapper_api > $progress_file
fi

# modify and copy docker-compose file for wrapper api.
if cat $progress_file | grep -q "$progress_setup_docker_compose_wrapper_api"; then
    if [ -f $file_docker_compose_file_wrapper_api ]; then
        echo "Config Docker Compose File for Wrapper API...";
        cp $file_docker_compose_file_wrapper_api $file_docker_compose_file_wrapper_api_bak
        sed -i "s/$label_CHANGE_VERSION_WRAPPER_API/$dockerImgVerWrapperAPI/g" $file_docker_compose_file_wrapper_api
        sed -i "s/$label_CHANGE_SERVER_IP/$dockerIpGateway/g" $file_docker_compose_file_wrapper_api
        sed -i "s/$label_CHANGE_SITE_ID_NUMBER/$siteId/g" $file_docker_compose_file_wrapper_api
        sed -i "s/$label_CHANGE_SITE_NAME/$siteName/g" $file_docker_compose_file_wrapper_api
        cp $file_docker_compose_file_wrapper_api $install_path_wrap_api/$file_docker_compose_file
        echo "Config Docker Compose File for Wrapper API... done";
        echo "";
    else
        echo "Config Docker Compose File for Wrapper API... Failed!  ";
        echo "Unable to find file: $file_docker_compose_file_wrapper_api";
        echo "";
        exit 1
    fi
    echo $progress_setup_docker_compose_mqtt_proxy > $progress_file
fi

# modify and copy docker-compose file for mqtt proxy. 
if cat $progress_file | grep -q "$progress_setup_docker_compose_mqtt_proxy"; then
    if [ -f $file_docker_compose_file_mqtt_proxy ]; then
        echo "Config Docker Compose File for MQTT Proxy...";
        cp $file_docker_compose_file_mqtt_proxy $file_docker_compose_file_mqtt_proxy_bak
        sed -i "s/$label_CHANGE_VERSION_MQTT_PROXY/$dockerImgVerMqttProxy/g" $file_docker_compose_file_mqtt_proxy
        sed -i "s/$label_CHANGE_CPO_ID_NUMBER/$cpoId/g" $file_docker_compose_file_mqtt_proxy
        sed -i "s/$label_CHANGE_SITE_ID_NUMBER/$siteId/g" $file_docker_compose_file_mqtt_proxy
        cp $file_docker_compose_file_mqtt_proxy $install_path_mqtt_proxy/$file_docker_compose_file
        echo "Config Docker Compose File for MQTT Proxy... done";
        echo "";
    else
        echo "Config Docker Compose File for MQTT Proxy... Failed!  ";
        echo "Unable to find file: $file_docker_compose_file_mqtt_proxy";
        echo "";
        exit 1
    fi
    #echo $progress_retrieve_docker_img > $progress_file
    echo $progress_load_docker_img > $progress_file
fi

#if [ "true" == $dockerImgLocalFile ]; then
#    echo $progress_load_docker_img > $progress_file
#else
#    echo $progress_retrieve_docker_img > $progress_file
#fi

# load docker images from remote 
if cat $progress_file | grep -q "$progress_retrieve_docker_img"; then
    echo "Retrieve Docker Images from Delta Docker Image Hub...";
    docker login $dockerImgRepoUrl -u $dockerImgRepoLogin -p $dockerImgRepoPass

    #docker pull mysql:$dockerImgVerMySQL
    docker pull mongo:$dockerImgVerMongo
    docker pull nginx:$dockerImgVerNginx
    docker pull sgc-registry.deltaww.com/em/sgc2019-ocos-api:$dockerImgVerEmAPI
    docker pull sgc-dev-registry.deltaww.com/deltagrid_em_frontend_prod:$dockerImgVerEmUI
    docker pull sgc-dev-registry.deltaww.com/ev-solution-api-deploy:$dockerImgVerWrapperAPI
    docker pull sgc-dev-registry.deltaww.com/ev-mqtt-proxy:$dockerImgVerMqttProxy
    docker pull sgc-dev-registry.deltaww.com/chargermgmtstd:$dockerImgVerWebAPI
    #docker pull sgc-dev-registry.deltaww.com/charger_management_frontend_std:$dockerImgVerWebUI
    docker pull sgc-registry.deltaww.com/deltagrid-ap/ev-on-premise/frontend:$dockerImgVerWebUI

    docker logout $dockerImgRepoUrl
    echo "Retrieve Docker Images from Delta Docker Image Hub... done";
    echo "";
    echo $progress_save_docker_img > $progress_file
fi

# save retrieved docker image to local file.
if cat $progress_file | grep -q "$progress_save_docker_img"; then
    echo "Save retrieved docker image to local file...";
    #docker save -o $install_path_docker_img/$dockerImgFilePrefixMySQL$dockerImgFileVerMySQL.tar mysql:$dockerImgVerMySQL
    docker save -o $install_path_docker_img/$dockerImgFilePrefixMongo$dockerImgFileVerMongo.tar mongo:$dockerImgVerMongo
    docker save -o $install_path_docker_img/$dockerImgFilePrefixNginx$dockerImgFileVerNginx.tar nginx:$dockerImgVerNginx
    docker save -o $install_path_docker_img/$dockerImgFilePrefixEmAPI$dockerImgFileVerEmAPI.tar sgc-registry.deltaww.com/em/sgc2019-ocos-api:$dockerImgVerEmAPI
    docker save -o $install_path_docker_img/$dockerImgFilePrefixEmUI$dockerImgFileVerEmUI.tar sgc-dev-registry.deltaww.com/deltagrid_em_frontend_prod:$dockerImgVerEmUI
    docker save -o $install_path_docker_img/$dockerImgFilePrefixWrapperAPI$dockerImgFileVerWrapperAPI.tar sgc-dev-registry.deltaww.com/ev-solution-api-deploy:$dockerImgVerWrapperAPI
    docker save -o $install_path_docker_img/$dockerImgFilePrefixMqttProxy$dockerImgFileVerMqttProxy.tar sgc-dev-registry.deltaww.com/ev-mqtt-proxy:$dockerImgVerMqttProxy
    docker save -o $install_path_docker_img/$dockerImgFilePrefixWebAPI$dockerImgFileVerWebAPI.tar sgc-dev-registry.deltaww.com/chargermgmtstd:$dockerImgVerWebAPI
    #docker save -o $install_path_docker_img/$dockerImgFilePrefixWebUI$dockerImgFileVerWebUI.tar sgc-dev-registry.deltaww.com/charger_management_frontend_std:$dockerImgVerWebUI
    docker save -o $install_path_docker_img/$dockerImgFilePrefixWebUI$dockerImgFileVerWebUI.tar sgc-registry.deltaww.com/deltagrid-ap/ev-on-premise/frontend:$dockerImgVerWebUI
    echo "Save retrieved docker image to local file directory '$install_path_docker_img' ... done";
    echo "";
    echo $progress_create_docker_network > $progress_file
fi

# load docker image from local file
if cat $progress_file | grep -q "$progress_load_docker_img"; then
    echo "Load docker image from local file...";
    #funcLoadDockerImgMySQL

    funcLoadDockerImgMongoDb

    funcLoadDockerImgNginx

    funcLoadDockerImgEmApi

    funcLoadDockerImgEmUi

    funcLoadDockerImgWrapperApi

    funcLoadDockerImgMqttProxy

    funcLoadDockerImgWebApi

    funcLoadDockerImgWebUi

    echo "Load docker image from local file directory '$path_docker_image_files' ... done";
    echo "";
    echo $progress_create_docker_network > $progress_file
fi

# create docker network.
if cat $progress_file | grep -q "$progress_create_docker_network"; then
    echo "Create Docker Network...";
    #docker network rm charger_management
    docker network create --driver=bridge charger_management
    #docker network rm em-network
    docker network create -d bridge -o "com.docker.network.bridge.host_binding_ipv4"="0.0.0.0" -o "com.docker.network.bridge.enable_icc"="true"  -o "com.docker.network.bridge.enable_ip_masquerade"="true" em-network
    echo "Create Docker Network... done";
    echo "";
    echo $progress_setup_nginx_config_auth > $progress_file
fi


# modify and copy nginx config file for auth server.
if cat $progress_file | grep -q "$progress_setup_nginx_config_auth"; then
    if [ -f $file_config_auth_nginx ]; then
        echo "Config Nginx Config File for Auth Server...";
        cp $file_config_auth_nginx $file_config_auth_nginx_bak
        sed -i "s/$label_CHANGE_SERVER_IP/$dockerIpGateway/g" $file_config_auth_nginx
        cp $file_config_auth_nginx $install_path_auth_srv_nginx/$file_nginx_config_file
        echo "Config Nginx Config File for Auth Server... done";
        echo "";
    else
        echo "Config Nginx Config File for Auth Server... Failed!  ";
        echo "Unable to find file: $file_config_auth_nginx";
        echo "";
        exit 1
    fi
    echo $progress_setup_docker_compose_auth_server > $progress_file
fi

# modify and copy docker-compose file for auth server.
if cat $progress_file | grep -q "$progress_setup_docker_compose_auth_server"; then
    if [ -f $file_docker_compose_file_auth ]; then
        echo "Config Docker Compose File for Auth Server...";
        cp $file_docker_compose_file_auth $file_docker_compose_file_auth_bak
        sed -i "s/$label_CHANGE_VERSION_MONGO/$dockerImgVerMongo/g" $file_docker_compose_file_auth
        sed -i "s/$label_CHANGE_VERSION_NGINX/$dockerImgVerNginx/g" $file_docker_compose_file_auth
        sed -i "s/$label_CHANGE_VERSION_EM_UI/$dockerImgVerEmUI/g" $file_docker_compose_file_auth
        sed -i "s/$label_CHANGE_VERSION_WEB_UI/$dockerImgVerWebUI/g" $file_docker_compose_file_auth
        sed -i "s/$label_CHANGE_VERSION_EM_API/$dockerImgVerEmAPI/g" $file_docker_compose_file_auth
        sed -i "s/$label_CHANGE_SERVER_IP/$dockerIpGateway/g" $file_docker_compose_file_auth
        cp $file_docker_compose_file_auth $install_path_auth_srv/$file_docker_compose_file
        echo "Config Docker Compose File for Auth Server... done";
        echo "";
    else
        echo "Config Docker Compose File for Auth Server... Failed!  ";
        echo "Unable to find file: $file_docker_compose_file_auth";
        echo "";
        exit 1
    fi
    echo $progress_start_auth_server > $progress_file
fi

# start auth server.
if cat $progress_file | grep -q "$progress_start_auth_server"; then
    if [ -f $install_path_auth_srv/$file_docker_compose_file ]; then
        echo "Start Auth Server...";
        cd $install_path_auth_srv
        docker-compose up -d
        sleep 10
        cd $deployWorkingDir
        echo "Start Auth Server... done";
        echo "";
    else
        cd $deployWorkingDir
        echo "Start Auth Server... Failed!  ";
        echo "Unable to find file: $install_path_auth_srv/$file_docker_compose_file";
        echo "";
        exit 1
    fi
    echo $progress_setup_mongo_db_auth > $progress_file
fi

# load mongo db scheam for auth server.
if cat $progress_file | grep -q "$progress_setup_mongo_db_auth"; then
    if [ -f $path_auth_deploy/$file_js_mongo_init_auth ]; then
        echo "Init Mongo DB Schema for Auth Server...";
        docker cp $path_auth_deploy/$file_js_mongo_init_auth em-mongodb:/tmp/$file_js_mongo_init_auth
        docker exec -it em-mongodb bash -c 'mongo < /tmp/mongodb-initial.js'
        echo "Init Mongo DB Schema for Auth Server... done";
        echo "";
    else
        echo "Init Mongo DB Schema for Auth Server... Failed!  ";
        echo "Unable to find file: $file_js_mongo_init_auth";
        echo "";
        exit 1
    fi
    echo $progress_setup_db_auth_server > $progress_file
fi

# load db schema for auth server.
if cat $progress_file | grep -q "$progress_setup_db_auth_server"; then
    if [ -f $file_dbScript_auth_create_acccount ]; then
        echo "Create DB User for Auth Server...";
        mysql -uroot -p$mysqlRootPass < $file_dbScript_auth_create_acccount
        echo "Create DB User for Auth Server... done";
        echo "";
    else
        echo "Create DB User for Auth Server... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_create_acccount";
        echo "";
        exit 1
    fi
    if [ -f $file_dbScript_auth_create_table ]; then
        echo "Create DB Schema for Auth Server...";
        mysql -usgc-dbuser -p[CREDENTIAL_REDACTED] < $file_dbScript_auth_create_table
        echo "Create DB Schema for Auth Server... done";
        echo "";
    else
        echo "Create DB Schema for Auth Server... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_create_table";
        echo "";
        exit 1
    fi
    if [ -f $file_dbScript_auth_create_table_form ]; then
        echo "Create DB Schema 2 for Auth Server...";
        mysql -usgc-dbuser -p[CREDENTIAL_REDACTED] < $file_dbScript_auth_create_table_form
        echo "Create DB Schema 2 for Auth Server... done";
        echo "";
    else
        echo "Create DB Schema 2 for Auth Server... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_create_table_form";
        echo "";
        exit 1
    fi
    echo $progress_restart_auth_server > $progress_file
fi

# restart auth server.
if cat $progress_file | grep -q "$progress_restart_auth_server"; then
    if [ -f $install_path_auth_srv/$file_docker_compose_file ]; then
        echo "Restart Auth Server...";
        cd $install_path_auth_srv
        docker-compose down
        sleep 10
        docker-compose up -d
        sleep 10
        cd $deployWorkingDir
        echo "Restart Auth Server... done";
        echo "";
    else
        cd $deployWorkingDir
        echo "Restart Auth Server... Failed!  ";
        echo "Unable to find file: $install_path_auth_srv/$file_docker_compose_file";
        echo "";
        exit 1
    fi
    echo $progress_update_db_schema_auth_1_4_41 > $progress_file
fi

# load db schema update 1.4.41 for auth server. 
if cat $progress_file | grep -q "$progress_update_db_schema_auth_1_4_41"; then
    if [ -f $path_auth_deploy_update_1_4_41/$file_js_mongo_upd_1_4_41_auth ]; then
        sleep 10
        echo "Update Mongo DB Schema for Auth Server v1.4.41...";
        docker cp $path_auth_deploy_update_1_4_41/$file_js_mongo_upd_1_4_41_auth em-mongodb:/tmp/$file_js_mongo_upd_1_4_41_auth
        docker exec -it em-mongodb bash -c 'mongo < /tmp/v1.4.41_mongo_update.js'
        echo "Update Mongo DB Schema for Auth Server v1.4.41... done";
        echo "";
    else
        echo "Update Mongo DB Schema for Auth Server v1.4.41... Failed!  ";
        echo "Unable to find file: $path_auth_deploy_update_1_4_41/$file_js_mongo_upd_1_4_41_auth";
        echo "";
        exit 1
    fi
    if [ -f $file_dbScript_auth_update_1_4_41_1 ]; then
        echo "Update DB User for Auth Server v1.4.41...";
        mysql -uroot -p$mysqlRootPass < $file_dbScript_auth_update_1_4_41_1
        echo "Update DB User for Auth Server v1.4.41... done";
        echo "";
    else
        echo "Update DB User for Auth Server v1.4.41... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_update_1_4_41_1";
        echo "";
        exit 1
    fi
    if [ -f $file_dbScript_auth_update_1_4_41_2 ]; then
        echo "Update DB Schema for Auth Server v1.4.41...";
        mysql -usgc-dbuser -p[CREDENTIAL_REDACTED] < $file_dbScript_auth_update_1_4_41_2
        echo "Update DB Schema for Auth Server v1.4.41... done";
        echo "";
    else
        echo "Update DB Schema for Auth Server v1.4.41... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_update_1_4_41_2";
        echo "";
        exit 1
    fi
    echo $progress_update_db_schema_auth_1_4_43 > $progress_file
fi

# load db schema update 1.4.43 for auth server. 
if cat $progress_file | grep -q "$progress_update_db_schema_auth_1_4_43"; then
    if [ -f $file_dbScript_auth_update_1_4_43 ]; then
        echo "Update DB User for Auth Server v1.4.43...";
        mysql -usgc-dbuser -p[CREDENTIAL_REDACTED] < $file_dbScript_auth_update_1_4_43
        echo "Update DB User for Auth Server v1.4.43... done";
        echo "";
    else
        echo "Update DB User for Auth Server v1.4.43... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_update_1_4_43";
        echo "";
        exit 1
    fi
    echo $progress_update_db_schema_auth_1_4_47 > $progress_file
fi

# load db schema update 1.4.47 for auth server. 
if cat $progress_file | grep -q "$progress_update_db_schema_auth_1_4_47"; then
    if [ -f $file_dbScript_auth_update_1_4_47 ]; then
        echo "Update DB User for Auth Server v1.4.47...";
        mysql -usgc-dbuser -p[CREDENTIAL_REDACTED] < $file_dbScript_auth_update_1_4_47
        echo "Update DB User for Auth Server v1.4.47... done";
        echo "";
    else
        echo "Update DB User for Auth Server v1.4.47... Failed!  ";
        echo "Unable to find file: $file_dbScript_auth_update_1_4_47";
        echo "";
        exit 1
    fi
    echo $progress_start_wrapper_api > $progress_file
fi

# start wrapper api.
if cat $progress_file | grep -q "$progress_start_wrapper_api"; then
    if [ -f $install_path_wrap_api/$file_docker_compose_file ]; then
        echo "Start Wrapper API...";
        cd $install_path_wrap_api
        docker-compose up -d
        sleep 10
        cd $deployWorkingDir
        echo "Start Wrapper API... done";
        echo "";
    else
        cd $deployWorkingDir
        echo "Start Wrapper API... Failed!  ";
        echo "Unable to find file: $install_path_wrap_api/$file_docker_compose_file";
        echo "";
        exit 1
    fi
    echo $progress_start_mqtt_proxy > $progress_file
fi

## force to skip start mqtt proxy.
#if cat $progress_file | grep -q "$progress_start_mqtt_proxy"; then
#    #echo $progress_start_web_api > $progress_file
#    echo $progress_create_license_key > $progress_file
#fi

# start mqtt proxy.
if cat $progress_file | grep -q "$progress_start_mqtt_proxy"; then
    if [ -f $install_path_mqtt_proxy/$file_docker_compose_file ]; then
        echo "Start MQTT Proxy...";
        cd $install_path_mqtt_proxy
        docker-compose up -d
        sleep 10
        cd $deployWorkingDir
        echo "Start MQTT Proxy... done";
        echo "";
    else
        cd $deployWorkingDir
        echo "Start MQTT Proxy... Failed!  ";
        echo "Unable to find file: $install_path_mqtt_proxy/$file_docker_compose_file";
        echo "";
        exit 1
    fi
    #echo $progress_start_web_api > $progress_file
    echo $progress_create_license_key > $progress_file
fi


# create license key. 
if cat $progress_file | grep -q "$progress_create_license_key"; then
    echo "Create License Key... ";
    if [ ! -f $deployWorkingDir/$installScript04Bin ]; then
        cd $deployWorkingDir
        echo "Create License Key... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$installScript04Bin";
        echo "";
        exit 1
    fi
    $deployWorkingDir/$installScript04Bin
    result=$?
    if [ 0 == $result ]; then
        echo "Create License Key... Done!  ";
        echo "";
    else
        cd $deployWorkingDir
        echo "Create License Key... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$install_config_file";
        echo "";
        exit 1
    fi
    echo $progress_remove_script_file_license > $progress_file
fi

# remove create license key script. 
if cat $progress_file | grep -q "$progress_remove_script_file_license"; then
    echo "Remove Generate License Key Program ... ";
    if [ -f $deployWorkingDir/$installScript04Bin ]; then
        rm -f $deployWorkingDir/$installScript04Bin
    fi
    echo $progress_start_web_api > $progress_file
fi


# start web api.
if cat $progress_file | grep -q "$progress_start_web_api"; then
    if [ -f $install_path_cm_std/$file_docker_compose_file ]; then
        echo "Start Web API...";
        cd $install_path_cm_std
        docker-compose up -d
        sleep 10
        cd $deployWorkingDir
        echo "Start Web API... done";
        echo "";
    else
        cd $deployWorkingDir
        echo "Start Web API... Failed!  ";
        echo "Unable to find file: $install_path_cm_std/$file_docker_compose_file";
        echo "";
        exit 1
    fi
    echo $progress_set_db_backup_script > $progress_file
fi


# mount extra HDD for data backup, if has second empty HDD. 
# In Ubuntu Desktop GUI, open "Disks" from Setting, 
# select 1TB HDD, from left manual, 
# select center, largest partition of 1TB HDD, 
# format partition to "NTFS" with name "Data".
# set automatic mount, with mount point "/mnt/DataBackupDrive" 

# create external storage backup directory.
funcExtStoreBackupDirectory


# set db backup scripts.
if cat $progress_file | grep -q "$progress_set_db_backup_script"; then
    echo "Setup MySQL DB Auto Backup Script...";
    if [ -f $path_db_backup/$file_script_db_backup_webapi ]; then
        cp $path_db_backup/$file_script_db_backup_webapi $install_path_db_backup/$file_script_db_backup_webapi
        chmod +x $install_path_db_backup/$file_script_db_backup_webapi
    fi
    if [ -f $path_db_backup/$file_script_db_restore_webapi ]; then
        cp $path_db_backup/$file_script_db_restore_webapi $install_path_db_backup/$file_script_db_restore_webapi
    fi
    if [ -f $path_db_backup/$file_script_db_backup_evcore ]; then
        cp $path_db_backup/$file_script_db_backup_evcore $install_path_db_backup/$file_script_db_backup_evcore
        chmod +x $install_path_db_backup/$file_script_db_backup_evcore
    fi
    if [ -f $path_db_backup/$file_script_db_restore_evcore ]; then
        cp $path_db_backup/$file_script_db_restore_evcore $install_path_db_backup/$file_script_db_restore_evcore
    fi
    if [ -f $path_db_backup/$file_script_db_backup_auth ]; then
        cp $path_db_backup/$file_script_db_backup_auth $install_path_db_backup/$file_script_db_backup_auth
        chmod +x $install_path_db_backup/$file_script_db_backup_auth
    fi
    if [ -f $path_db_backup/$file_script_db_restore_auth ]; then
        cp $path_db_backup/$file_script_db_restore_auth $install_path_db_backup/$file_script_db_restore_auth
    fi
    if [ -f $path_db_backup/$file_script_db_backup_cron ]; then
        cp $path_db_backup/$file_script_db_backup_cron $install_path_db_backup/$file_script_db_backup_cron
        chmod 764 $install_path_db_backup/$file_script_db_backup_cron
        ("$install_path_db_backup/$file_script_db_backup_cron")
    fi
    echo "Setup MySQL DB Auto Backup Script... done";
    echo "";
    echo "If has second empty HDD or partition, mount extra HDD for data backup. ";
    echo "In Ubuntu Desktop GUI, open \"Disks\" from Setting, ";
    echo "Select second HDD (not used by Linux), from left manual, ";
    echo "Select center or largest \"NTFS\" partition of second HDD, ";
    echo "Re-Format partition to \"NTFS\" with name \"Data\". ";
    echo "Set automatic mount, with mount point \"/mnt/DataBackupDrive\". ";
    echo "";
    echo $progress_set_db_backup_script_mongo > $progress_file
fi

# set db backup scripts for Mongo.
if cat $progress_file | grep -q "$progress_set_db_backup_script_mongo"; then
    echo "Setup Mongo DB Auto Backup Script...";
    if [ -f $path_db_backup_mongo/$file_script_db_mongo_backup_auth ]; then
        cp $path_db_backup_mongo/$file_script_db_mongo_backup_auth $install_path_db_backup_mongo/$file_script_db_mongo_backup_auth
        chmod +x $install_path_db_backup_mongo/$file_script_db_mongo_backup_auth
    fi
    if [ -f $path_db_backup_mongo/$file_script_db_mongo_restore_auth ]; then
        cp $path_db_backup_mongo/$file_script_db_mongo_restore_auth $install_path_db_backup_mongo/$file_script_db_mongo_restore_auth
    fi
    if [ -f $path_db_backup_mongo/$file_script_db_mongo_backup_cron ]; then
        cp $path_db_backup_mongo/$file_script_db_mongo_backup_cron $install_path_db_backup_mongo/$file_script_db_mongo_backup_cron
        chmod 764 $install_path_db_backup_mongo/$file_script_db_mongo_backup_cron
        ("$install_path_db_backup_mongo/$file_script_db_mongo_backup_cron")
    fi
    echo "Setup Mongo DB Auto Backup Script... done";
    echo "";
    echo "If has second empty HDD or partition, mount extra HDD for data backup. ";
    echo "In Ubuntu Desktop GUI, open \"Disks\" from Setting, ";
    echo "Select second HDD (not used by Linux), from left manual, ";
    echo "Select center or largest \"NTFS\" partition of second HDD, ";
    echo "Re-Format partition to \"NTFS\" with name \"Data\". ";
    echo "Set automatic mount, with mount point \"/mnt/DataBackupDrive\". ";
    echo "";
    echo $progress_copy_log_retrieve_script > $progress_file
fi

# copy log retrieve scripts.
if cat $progress_file | grep -q "$progress_copy_log_retrieve_script"; then
    echo "Copy Log Retrieve Script...";
    if [ -f $path_log_retrieve/$file_script_log_retrieve_std ]; then
        cp $path_log_retrieve/$file_script_log_retrieve_std $install_path_log_retrieve/$file_script_log_retrieve_std
        chmod +x $install_path_log_retrieve/$file_script_log_retrieve_std
    fi
    echo "";
    echo $progress_copy_gen_mac_script > $progress_file
fi

# copy gen mac scripts. 
if cat $progress_file | grep -q "$progress_copy_gen_mac_script"; then
    echo "Setup Gen MAC Script...";
    if [ -f $path_gen_mac/$file_script_gen_mac_std ]; then
        cp $path_gen_mac/$file_script_gen_mac_std $install_path_gen_mac/$file_script_gen_mac_std
        chmod +x $install_path_gen_mac/$file_script_gen_mac_std
    fi
    if [ -f $path_gen_mac/$file_script_gen_mac_std_cron ]; then
        cp $path_gen_mac/$file_script_gen_mac_std_cron $install_path_gen_mac/$file_script_gen_mac_std_cron
        chmod 764 $install_path_gen_mac/$file_script_gen_mac_std_cron
        ("$install_path_gen_mac/$file_script_gen_mac_std_cron")
    fi
    echo "Setup Gen MAC Script... done";
    echo "";
    #echo $progress_done > $progress_file
    echo $progress_remove_installer_file_zip > $progress_file
fi


# remove original compressed installer file. 
if cat $progress_file | grep -q "$progress_remove_installer_file_zip"; then
    echo "Remove Original Compressed Installer File...";
    funcRemoveCompressedInstallerFile
    echo $progress_repack_installer_file > $progress_file
fi

# repack installed installer directory. 
if cat $progress_file | grep -q "$progress_repack_installer_file"; then
    funcRepackInstalledInstallerDirectory
    echo "";
    echo $progress_done > $progress_file
fi


# install process done.
if [ $progress_flag_error -eq "0" ]; then
    echo $progress_done > $progress_file
    echo "";
    echo "Installation Completed...";
    echo "";
    exit 0
else
    echo "";
    echo "Installation Failed...";
    echo "";
    exit 1
fi




