#!/bin/bash

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 
# 00. Intaller Functions. 
# 
## 

# After Install Ubuntu Desktop 20.04 LTS with minimal installation. 


## 
# check if remote session. 
funcChkIsRemoteSession () {
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        isRemoteSession=1
        # many other tests omitted
    else
      case $(ps -o comm= -p "$PPID") in
        sshd|*/sshd) isRemoteSession=1;;
      esac
    fi
    if [[ $isRemoteSession == 1 ]]; then
        echo "Please Execute this script in console from GUI mode!";
        echo "DO NOT Execute this script from remote session!";
        echo "";
        exit 1
    fi
}



##
# check if use sudo. 
funcChkIsSudo () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Script Filename) is not supplied!";
        echo "";
        exit 1
    fi

    if [[ $EUID != 0 ]]; then
        echo "";
        echo "Please use sudo or root to execute install script '$1'!"
        echo "";
        exit 1
    fi
}

##
# check if not use sudo. 
funcChkIsNotSudo () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Script Filename) is not supplied!";
        echo "";
        exit 1
    fi

    if [[ $EUID == 0 ]]; then
        echo "";
        echo "Please use local user \"administrator\" to execute install script '$1'!"
        echo "";
        exit 1
    fi
}


## 
# initial or check progress file.
funcChkInitInstallForFirstOnly () {
    if [ ! -f $progress_file ]; then
        echo $progress_install_config_input > $progress_file
        chown administrator:administrator $progress_file
    else
        chown administrator:administrator $progress_file
        cp $progress_file $progress_file_previous
        chown administrator:administrator $progress_file_previous
    fi
}

funcChkNotStartInstallation () {
    if [ ! -f $progress_file ]; then
        echo "";
        echo "System has NOT Installed!!";
        echo "Please use sudo or root to execute first install script '$installScript01'!"
        echo "";
        exit 1
    else
        cp $progress_file $progress_file_previous
    fi
}

funcChkDoneInstall () {
    if cat $progress_file | grep -q "$progress_done"; then
        echo "";
        echo "Installation already finished.";
        echo "";
        exit 0
    fi
}


## 
# remove install config when has missing values. 
# check install config for missing values. 
funcChkInstallConfigFileValues () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Is Remove Previous Config File) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
    if [ "y" == $1 ] || [ "Y" == $1 ] || [ "n" == $1 ] || [ "N" == $1 ]; then
        echo "";
    else
        echo "";
        echo "Argument 1 (Is Remove Previous Config File) is not valid!  [y/n]";
        echo "";
        exit 1
    fi
    flagRemove=$1

    if [ -f $install_config_file ]; then
        removeConfigFile=0
        testValue=$(awk -F "=" '/repackInstaller/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/computerBrandName/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/computerModelName/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/computerSn/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/deployWorkingDir/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/localTimeSpan/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/cpoId/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/cpoName/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/siteId/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/siteName/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/iotHubDeviceName/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/mqttProxyClientId/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/maxAllowedChargers/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/ocppPort/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/mysqlRootPass/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/dockerIpRange/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        testValue=$(awk -F "=" '/dockerIpGateway/ {print $2}' $install_config_file)
        if [ -z "${testValue// }" ]; then
            removeConfigFile=1
        fi
        if [ 0 != $removeConfigFile ]; then
            if [ "y" == $flagRemove ] || [ "Y" == $flagRemove ]; then
                rm $install_config_file
                echo $progress_install_config_input > $progress_file
            elif [ "n" == $flagRemove ] || [ "N" == $flagRemove ]; then
                echo "";
                echo "Missing Values in install config file!!";
                echo "Please use sudo or root to execute first install script '$installScript01'!"
                echo "";
            fi
        else
            if cat $progress_file | grep -q "$progress_install_config_input" && [ -f $install_config_file ]; then
                funcReadInstallConfigValueFromFile
                echo $progress_init_os_upd > $progress_file
            elif [ -f $install_config_file ]; then
                funcReadInstallConfigValueFromFile
            fi
        fi
    fi
}


## 
# Ask input paramters within script execution. 
funcAskUserInputOnSetting () {
    if cat $progress_file | grep -q "$progress_install_config_input" || [ ! -f $install_config_file ]; then
        echo "";
        echo "EV Management Standard ${verNumber} installation script '$installScript01'. "
        echo "Please enter following installation configuration settings: "
        echo "Press <Enter> key after value entered, or just press <Enter> key for using default value for optional settings. "
        echo "Press <Ctrl> + <C> key to cancel. "
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Computer Brand Name (no spaces between, allow underline or dash, ex: Asus): " computerBrandName
            if [ -z "${computerBrandName// }" ]; then
                echo "Input 'Computer Brand Name' is empty or white spaces."
            fi
            if ! [ -z "${computerBrandName// }" ]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Computer Model Name (no spaces between, allow underline or dash, ex: WS720T): " computerModelName
            if [ -z "${computerModelName// }" ]; then
                echo "Input 'Computer Model Name' is empty or white spaces."
            fi
            if ! [ -z "${computerModelName// }" ]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Computer Serial Number (no spaces between, allow underline or dash): " computerSn
            if [ -z "${computerSn// }" ]; then
                echo "Input 'Computer Serial Number' is empty or white spaces."
            fi
            if ! [ -z "${computerSn// }" ]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "UTC Timezone Hours (-11 ~ +14, ex: Taiwan 8): " localTimeSpan
            if [ -z "${localTimeSpan// }" ]; then
                echo "Input 'UTC Timezone Hours' is empty or white spaces."
            elif [ "$localTimeSpan" -lt -11 ] && [ "$localTimeSpan" -gt 14 ] ; then
                echo "Input 'UTC Timezone Hours' is out-of-range.";
            fi
            if [ "$localTimeSpan" -ge -11 ] && [ "$localTimeSpan" -le 14 ]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ "0" != "$progress_flag_error" ] ; do
            read -p "CPO ID (format: [A-Za-z]{3}[0-9]{6}): " cpoId
            if [ -z "${cpoId// }" ]; then
                echo "Input 'CPO ID' is empty or white spaces."
            elif ! [[ $cpoId =~ ^[A-Za-z]{3}[0-9]{6}$ ]] ; then
                echo "Input 'CPO ID' format not in [A-Za-z]{3}[0-9]{6}.";
            fi
            if ! [ -z "${cpoId// }" ] && [[ $cpoId =~ ^[A-Za-z]{3}[0-9]{6}$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "CPO Name (no spaces between, allow underline): " cpoName
            if [ -z "${cpoName// }" ]; then
                echo "Input 'CPO Name' is empty or white spaces."
            fi
            if ! [ -z "${cpoName// }" ]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Site Name (no spaces between, allow underline): " siteName
            if [ -z "${siteName// }" ]; then
                echo "Input 'Site Name' is empty or white spaces."
            fi
            if ! [ -z "${siteName// }" ]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Site ID (default: timestamp): " siteId
            if [ -z "${siteId// }" ]; then
                siteId=$(date +%s)
                echo "Use Current Timestamp as Site ID: ${siteId} "
                progress_flag_error=0
            elif ! [[ $siteId =~ ^[0-9]+$ ]] ; then
                echo "Input 'Site ID' is not positive number.";
            fi
            if [[ $siteId =~ ^[0-9]+$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "OCPP Server Port (Default: ${ocppPortDefault}.  Migrate from SMS enter: 6002): " ocppPort
            if [ -z "${ocppPort// }" ]; then
                echo "Use Default OCPP Server Port: ${ocppPortDefault} "
                ocppPort=$ocppPortDefault
                progress_flag_error=0
            elif ! [[ $ocppPort =~ ^[0-9]+$ ]] ; then
                echo "Input 'OCPP Server Port' is not positive number.";
            fi
            if [ "$ocppPort" -lt 1 ] && [ "$ocppPort" -gt 65535 ] ; then
                echo "Input 'OCPP Server Port' is out-of-range.  (1 ~ 65535)";
            fi
            if [[ $ocppPort =~ ^[0-9]+$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "License Allowed Maximum Chargers Count (Default: ${maxAllowedChargersDefault}): " maxAllowedChargers
            if [ -z "${maxAllowedChargers// }" ]; then
                echo "Use Default Allowed Maximum Chargers Count: ${maxAllowedChargersDefault} "
                maxAllowedChargers=$maxAllowedChargersDefault
                progress_flag_error=0
            elif ! [[ $maxAllowedChargers =~ ^[0-9]+$ ]] ; then
                echo "Input 'Allowed Maximum Chargers Count' is not positive number.";
            fi
            if [ "$maxAllowedChargers" -lt 1 ] && [ "$maxAllowedChargers" -gt "$maxAllowedChargersSystem" ] ; then
                echo "Input 'Allowed Maximum Chargers Count' is out-of-range.  (1 ~ ${maxAllowedChargersSystem})";
            fi
            if [[ $maxAllowedChargers =~ ^[0-9]+$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            #read -sp "MySQL root passwd (Default: [DEFAULT_CREDENTIAL_REDACTED]): " mysqlRootPass
            read -p "MySQL root passwd (Default: ${mysqlRootPassDefault}): " mysqlRootPass
            if [ -z "${mysqlRootPass// }" ]; then
                echo "Use Default MySQL root passwd: ${mysqlRootPassDefault} "
                echo "Remember to enter same password during MySQL server installation!"
                mysqlRootPASS=[REDACTED]
                progress_flag_error=0
            else
                echo "Entered MySQL root passwd: ${mysqlRootPass} "
                echo "Remember to enter same password during MySQL server installation!"
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Docker IP Range (Default: ${dockerIpRangeDefault}): " dockerIpRange
            if [ -z "${dockerIpRange// }" ]; then
                echo "Use Default Docker IP Range: ${dockerIpRangeDefault} "
                dockerIpRange=$dockerIpRangeDefault
                progress_flag_error=0
            elif ! [[ $dockerIpRange =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] ; then
                echo "Input 'Docker IP Range' not in IPv4 format.";
            fi
            if [[ $dockerIpRange =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "docker0 IP (Default: ${dockerIpGatewayDefault}): " dockerIpGateway
            if [ -z "${dockerIpGateway// }" ]; then
                echo "Use Default Docker Gateway IP: ${dockerIpGatewayDefault} "
                dockerIpGateway=$dockerIpGatewayDefault
                progress_flag_error=0
            elif ! [[ $dockerIpGateway =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] ; then
                echo "Input 'Docker Gateway IP' not in IPv4 format.";
            fi
            tmpRange=(${dockerIpRange//./ })
            tmpGW=(${dockerIpGateway//./ })
            if [ ${tmpRange[0]} -ne ${tmpGW[0]} ]; then
                echo "Input 'Docker Gateway IP' not match 'Docker IP Range'.";
            fi
            if [ ${tmpRange[1]} -ne ${tmpGW[1]} ]; then
                echo "Input 'Docker Gateway IP' not match 'Docker IP Range'.";
            fi
            if [ ${tmpRange[2]} -ne ${tmpGW[2]} ]; then
                echo "Input 'Docker Gateway IP' not match 'Docker IP Range'.";
            fi
            if [ 1 -ne ${tmpGW[3]} ]; then
                echo "Input 'Docker Gateway IP' not end with '1'.";
            fi
            if [[ $dockerIpGateway =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ "0" != "$progress_flag_error" ] ; do
            read -p "Repacking Installer to ZIP File? (Default: y) [y/n]: " userInput
            if [ -z "${userInput}" ]; then
                echo "Repacking Installer to ZIP File as Default...";
                repackInstaller=y
                progress_flag_error=0
            else
                if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
                    echo "Repacking installer to ZIP File...";
                    repackInstaller=y
                    progress_flag_error=0
                elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
                    echo "NOT repacking installer to ZIP File...";
                    repackInstaller=n
                    progress_flag_error=0
                fi
            fi
        done
        echo "";

        #progress_flag_error=1
        #while [ 0 != $progress_flag_error ] ; do
        #    read -p "Docker Image Hub URL (Default: ${dockerImgRepoUrlDefault}): " dockerImgRepoUrl
        #    if [ -z "${dockerImgRepoUrl// }" ]; then
        #        echo "Use Default Docker Image Hub URL: ${dockerImgRepoUrlDefault} "
        #        dockerImgRepoUrl=$dockerImgRepoUrlDefault
        #        progress_flag_error=0
        #    else
        #        echo "Entered Docker Image Hub URL: ${dockerImgRepoUrl} "
        #        progress_flag_error=0
        #    fi
        #done
        #echo "";
        #
        #progress_flag_error=1
        #while [ 0 != $progress_flag_error ] ; do
        #    read -p "Docker Image Hub Account Login (Default: ${dockerImgRepoLoginDefault}): " dockerImgRepoLogin
        #    if [ -z "${dockerImgRepoLogin// }" ]; then
        #        echo "Use Default Docker Image Hub Account Login: ${dockerImgRepoLoginDefault} "
        #        dockerImgRepoLogin=$dockerImgRepoLoginDefault
        #        progress_flag_error=0
        #    else
        #        echo "Entered Docker Image Hub Account Login: ${dockerImgRepoLogin} "
        #        progress_flag_error=0
        #    fi
        #done
        #echo "";
        #
        #progress_flag_error=1
        #while [ 0 != $progress_flag_error ] ; do
        #    read -p "Docker Image Hub Account Pass (Default: ${dockerImgRepoPassDefault}): " dockerImgRepoPass
        #    if [ -z "${dockerImgRepoPass// }" ]; then
        #        echo "Use Default Docker Image Hub Account Pass: ${dockerImgRepoPassDefault} "
        #        dockerImgRepoPASS=[REDACTED]
        #        progress_flag_error=0
        #    else
        #        echo "Entered Docker Image Hub Account Pass: ${dockerImgRepoPass} "
        #        progress_flag_error=0
        #    fi
        #done
        #echo "";

        echo $progress_install_config_save > $progress_file
        echo "";

        #echo "repackInstaller = ${repackInstaller}";
        #echo "computerBrandName = ${computerBrandName}";
        #echo "computerModelName = ${computerModelName}";
        #echo "computerSn = ${computerSn}";
        #echo "deployWorkingDir = ${deployWorkingDir}";
        #echo "localTimeSpan = ${localTimeSpan}";
        #echo "cpoId = ${cpoId}";
        #echo "cpoName = ${cpoName}";
        #echo "siteId = ${siteId}";
        #echo "siteName = ${siteName}";
        #echo "ocppPort = ${ocppPort}";
        #echo "mysqlRootPass = ${mysqlRootPass}";
        #echo "dockerIpRange = ${dockerIpRange}";
        #echo "dockerIpGateway = ${dockerIpGateway}";
    fi
}


## 
# write install config to ini file.
funcWriteInstallConfigToIniFile () {
    if cat $progress_file | grep -q "$progress_install_config_save"; then
        echo "" > $install_config_file
        echo "EV Charger Management Standard ${verNumber} " >> $install_config_file
        echo "Installation MetaData: " >> $install_config_file
        echo "" >> $install_config_file
        echo "repackInstaller=${repackInstaller}" >> $install_config_file
        echo "" >> $install_config_file
        echo "computerBrandName=${computerBrandName}" >> $install_config_file
        echo "computerModelName=${computerModelName}" >> $install_config_file
        echo "computerSn=${computerSn}" >> $install_config_file
        echo "" >> $install_config_file
        echo "deployWorkingDir=${deployWorkingDir}" >> $install_config_file
        echo "localTimeSpan=${localTimeSpan}" >> $install_config_file
        echo "cpoId=${cpoId}" >> $install_config_file
        echo "cpoName=${cpoName}" >> $install_config_file
        echo "siteId=${siteId}" >> $install_config_file
        echo "siteName=${siteName}" >> $install_config_file
        echo "iotHubDeviceName=${mqttProxyClientIdPrefix}${cpoId}${siteId}" >> $install_config_file
        echo "mqttProxyClientId=${mqttProxyClientIdPrefix}${cpoId}${siteId}" >> $install_config_file
        echo "maxAllowedChargers=${maxAllowedChargers}" >> $install_config_file
        echo "ocppPort=${ocppPort}" >> $install_config_file
        echo "latitude=[LAT_REDACTED]" >> $install_config_file
        echo "longitude=[LONG_REDACTED]" >> $install_config_file
        echo "mysqlRootPASS=[REDACTED] >> $install_config_file
        echo "dockerIpRange=${dockerIpRange}" >> $install_config_file
        echo "dockerIpGateway=${dockerIpGateway}" >> $install_config_file
        echo "" >> $install_config_file
        installDT=$(date +'%Y-%m-%d %H:%M:%S')
        echo "installDT=${installDT}" >> $install_config_file
        echo "installedVersion=${verNumber}" >> $install_config_file
        echo "authServerApiVersion=${dockerImgVerEmAPI}" >> $install_config_file
        echo "authServerUiVersion=${dockerImgVerEmUI}" >> $install_config_file
        echo "wrapperApiVersion=${dockerImgVerWrapperAPI}" >> $install_config_file
        echo "mqttProxyVersion=${dockerImgVerMqttProxy}" >> $install_config_file
        echo "cmWebApiVersion=${dockerImgVerWebAPI}" >> $install_config_file
        echo "cmWebUiVersion=${dockerImgVerWebUI}" >> $install_config_file
        echo "osLogin=administrator" >> $install_config_file
        echo "osPASSWD=[REDACTED] >> $install_config_file
        echo "adminLogin=sysadmin" >> $install_config_file
        echo "adminPASSWD=[REDACTED] >> $install_config_file
        echo "adminEmail=[REDACTED_EMAIL]" >> $install_config_file
        echo "officeLogin=officeadmin" >> $install_config_file
        echo "officePASSWD=[REDACTED] >> $install_config_file
        echo "officeEmail=[REDACTED_EMAIL]" >> $install_config_file
        echo "" >> $install_config_file
        echo "macAddress=${macAddress}" >> $install_config_file
        echo "" >> $install_config_file
        chown administrator:administrator $install_config_file

        # set progres status to init OS update.
        echo $progress_init_os_upd > $progress_file
    fi
}


## 
# get user entered value back from config file. 
funcReadInstallConfigValueFromFile () {
    if [ -f $install_config_file ]; then
        repackInstaller=$(awk -F "=" '/repackInstaller/ {print $2}' $install_config_file)
        computerBrandName=$(awk -F "=" '/computerBrandName/ {print $2}' $install_config_file)
        computerModelName=$(awk -F "=" '/computerModelName/ {print $2}' $install_config_file)
        computerSn=$(awk -F "=" '/computerSn/ {print $2}' $install_config_file)
        deployWorkingDir=$(awk -F "=" '/deployWorkingDir/ {print $2}' $install_config_file)
        localTimeSpan=$(awk -F "=" '/localTimeSpan/ {print $2}' $install_config_file)
        cpoId=$(awk -F "=" '/cpoId/ {print $2}' $install_config_file)
        cpoName=$(awk -F "=" '/cpoName/ {print $2}' $install_config_file)
        siteId=$(awk -F "=" '/siteId/ {print $2}' $install_config_file)
        siteName=$(awk -F "=" '/siteName/ {print $2}' $install_config_file)
        iotHubDeviceName=$(awk -F "=" '/iotHubDeviceName/ {print $2}' $install_config_file)
        mqttProxyClientId=$(awk -F "=" '/mqttProxyClientId/ {print $2}' $install_config_file)
        maxAllowedChargers=$(awk -F "=" '/maxAllowedChargers/ {print $2}' $install_config_file)
        ocppPort=$(awk -F "=" '/ocppPort/ {print $2}' $install_config_file)
        mysqlRootPASS=[REDACTED] -F "=" '/mysqlRootPass/ {print $2}' $install_config_file)
        dockerIpRange=$(awk -F "=" '/dockerIpRange/ {print $2}' $install_config_file)
        dockerIpGateway=$(awk -F "=" '/dockerIpGateway/ {print $2}' $install_config_file)
        tmpInstallConfigFileDir=$defaultUserHomeDir/$siteName'_'$computerBrandName'_'$computerModelName'_'$computerSn
        #echo "repackInstaller = ${repackInstaller}";
        #echo "computerBrandName = ${computerBrandName}";
        #echo "computerModelName = ${computerModelName}";
        #echo "computerSn = ${computerSn}";
        #echo "deployWorkingDir = ${deployWorkingDir}";
        #echo "tmpInstallConfigFileDir = ${tmpInstallConfigFileDir}";
        #echo "localTimeSpan = ${localTimeSpan}";
        #echo "cpoId = ${cpoId}";
        #echo "cpoName = ${cpoName}";
        #echo "siteId = ${siteId}";
        #echo "siteName = ${siteName}";
        #echo "iotHubDeviceName = ${iotHubDeviceName}";
        #echo "mqttProxyClientId = ${mqttProxyClientId}";
        #echo "maxAllowedChargers = ${maxAllowedChargers}";
        #echo "ocppPort = ${ocppPort}";
        #echo "mysqlRootPass = ${mysqlRootPass}";
        #echo "dockerIpRange = ${dockerIpRange}";
        #echo "dockerIpGateway = ${dockerIpGateway}";
    else
        echo "";
        echo "Load User Entered value back from config file Failed!  ";
        echo "Unable to find file: $install_config_file";
        echo "";
        exit 1
    fi
}


## 
# create install path.
funcCreatInstallDirectory () {
    echo "Creating Program Directories...";
    mkdir -p $install_root_path
    mkdir -p $install_path_docker_img
    mkdir -p $install_path_ev_core
    mkdir -p $install_path_auth_srv
    mkdir -p $install_path_auth_srv_mysql
    mkdir -p $install_path_auth_srv_mongo
    mkdir -p $install_path_auth_srv_redis
    mkdir -p $install_path_auth_srv_nginx
    mkdir -p $install_path_auth_srv_log
    mkdir -p $install_path_wrap_api
    mkdir -p $install_path_mqtt_proxy
    mkdir -p $install_path_mqtt_proxy_log
    mkdir -p $install_path_mqtt_proxy_cert
    mkdir -p $install_path_cm_std
    #mkdir -p $install_path_cm_ui_std
    mkdir -p $install_path_db_backup
    mkdir -p $install_path_db_backup_mongo
    mkdir -p $install_path_log_retrieve
    mkdir -p $install_path_gen_mac

    # copy install config file to directories.
    echo "Copy Install Config File to Directories...";
    mkdir -p $tmpInstallConfigFileDir
    if [ -f $install_config_file ]; then
        cp -f $install_config_file $tmpInstallConfigFileDir/$install_config_file
        cp -f $install_config_file $install_path_cm_std/$install_config_file
    fi
    # copy mac addres list file to directories. 
    echo "Copy MAC Address List File to Directories...";
    if [ -f $mac_address_list_file ]; then
        cp -f $mac_address_list_file $tmpInstallConfigFileDir/$mac_address_list_file
        cp -f $mac_address_list_file $install_path_cm_std/$mac_address_list_file
    fi

    cd $defaultUserHomeDir
    chown -R administrator:administrator $tmpInstallConfigFileDir

    cd $path_opt
    chown -R administrator:administrator $path_delta

    cd $deployWorkingDir
}


## 
# load docker image from local file.

# load docker image for MySQL Server.
#funcLoadDockerImgMySQL () {
#    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMySQL$dockerImgFileVerMySQL.tar ]; then
#        echo "Load docker image from local file... Failed!  ";
#        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMySQL$dockerImgFileVerMySQL.tar";
#        exit 1
#    fi
#    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMySQL$dockerImgFileVerMySQL.tar
#}

# load docker image for Mongo DB.
funcLoadDockerImgMongoDb () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMongo$dockerImgFileVerMongo.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMongo$dockerImgFileVerMongo.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMongo$dockerImgFileVerMongo.tar
}

# load docker image for Nginx.
funcLoadDockerImgNginx () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixNginx$dockerImgFileVerNginx.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixNginx$dockerImgFileVerNginx.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixNginx$dockerImgFileVerNginx.tar
}

# load docker image for Auth Server API.
funcLoadDockerImgEmApi () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixEmAPI$dockerImgFileVerEmAPI.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixEmAPI$dockerImgFileVerEmAPI.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixEmAPI$dockerImgFileVerEmAPI.tar
}

# load docker image for Auth Server UI.
funcLoadDockerImgEmUi () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixEmUI$dockerImgFileVerEmUI.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixEmUI$dockerImgFileVerEmUI.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixEmUI$dockerImgFileVerEmUI.tar
}

# load docker image for Wrapper API.
funcLoadDockerImgWrapperApi () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWrapperAPI$dockerImgFileVerWrapperAPI.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWrapperAPI$dockerImgFileVerWrapperAPI.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWrapperAPI$dockerImgFileVerWrapperAPI.tar
}

# load docker image for MQTT Proxy.
funcLoadDockerImgMqttProxy () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMqttProxy$dockerImgFileVerMqttProxy.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMqttProxy$dockerImgFileVerMqttProxy.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixMqttProxy$dockerImgFileVerMqttProxy.tar
}

# load docker image for Web API.
funcLoadDockerImgWebApi () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWebAPI$dockerImgFileVerWebAPI.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWebAPI$dockerImgFileVerWebAPI.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWebAPI$dockerImgFileVerWebAPI.tar
}

# load docker image for Web UI.
funcLoadDockerImgWebUi () {
    if [ ! -f $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWebUI$dockerImgFileVerWebUI.tar ]; then
        echo "Load docker image from local file... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWebUI$dockerImgFileVerWebUI.tar";
        exit 1
    fi
    docker load -i $deployWorkingDir/$path_docker_image_files/$dockerImgFilePrefixWebUI$dockerImgFileVerWebUI.tar
}


## 
# remove original compressed installer file. 
funcRemoveCompressedInstallerFile () {
    if [ -f $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber*.zip ]; then
        rm -f $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber*.zip
    	echo "Remove Original Compressed Installer File... done";
    else
        echo "Unable to remove original compressed installer file ... ";
        echo "Unable to find file: $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber*.zip";
    fi
    echo "";
}


## 
# repack installed installer directory. 
funcRepackInstalledInstallerDirectory () {
    if [ "y" == $repackInstaller ]; then
        echo "Repacking Installed Installer Directory...";
        if [ -d $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber ]; then
            cd $defaultUserHomeDir
            filenamePostfix=_$(date "+%Y%m%d")_installed.zip
            zip -rq $compressedInstallerFilePrefix$verNumber$filenamePostfix $compressedInstallerFilePrefix$verNumber
            if [ -f $external_mnt_pt ]; then
                echo "Copy Repacked Installed Installer File to Backup Disk ... ";
                cp $compressedInstallerFilePrefix$verNumber$filenamePostfix $external_mnt_pt
            else
                echo "Unable to copy repacked installed installer file to backup disk ... ";
                echo "Unable to find backup disk: $external_mnt_pt";
                echo "";
            fi
            cd $deployWorkingDir
        else
            echo "Unable to repack installed installer directory ... ";
            echo "Unable to find directory: $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber";
            echo "";
        fi
    else
        echo "Skip Repacking Installed Installer Directory...";
    fi
}



# ------------------------------------------------------------
# for update or upgrade. 


## 
# set previous installation source directory.
funcSetPrevInstSrcDir () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Old Version Number) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
	oldVerNumb=$1
    if [ -z "$2" ]; then
        echo "";
        echo "Argument 2 (New Version Number) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
	newVerNumb=$2
    preInstallSrcDir=$defaultUserHomeDir/$compressedInstallerFilePrefix$oldVerNumb
    preUpdateSrcDir=$defaultUserHomeDir/$compressedUpdaterFilePrefix$oldVerNumb
    prePatchSrcDir=$defaultUserHomeDir/$compressedPatcherFilePrefix$oldVerNumb
    if [ -d "$preInstallSrcDir" ]; then
        echo "Found Previous Installation Source Directory: $preInstallSrcDir";
        preInstallConfigFile=$defaultUserHomeDir/$compressedInstallerFilePrefix$oldVerNumb/$install_config_file
    elif [ -d "$prePatchSrcDir" ]; then
        echo "Found Previous Patched Source Directory: $prePatchSrcDir";
        preInstallConfigFile=$defaultUserHomeDir/$compressedPatcherFilePrefix$oldVerNumb/$install_config_file
    else
        preInstallSrcDir=$defaultUserHomeDir/$compressedUpdaterFilePrefix$oldVerNumb
        if [ -d "$preInstallSrcDir" ]; then
            echo "Found Previous Installation Source Directory: $preInstallSrcDir";
            preInstallConfigFile=$defaultUserHomeDir/$compressedUpdaterFilePrefix$oldVerNumb/$install_config_file
        else
            echo "";
            echo "Upgrade to version $newVerNumb ... Failed!";
            echo "Unable to find previous installation source directory for version $oldVerNumb ";
            echo "Unable to find directory: $defaultUserHomeDir/$compressedInstallerFilePrefix$oldVerNumb "
            echo "                          or ";
            echo "                          $preInstallSrcDir ";
            echo "";
        exit 1
        fi
    fi
}


## 
# check preinstalled file info.
funcChkPreinstallConfigFile () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Old Version Number) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
	oldVerNumb=$1
    if [ -z "$2" ]; then
        echo "";
        echo "Argument 2 (New Version Number) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
	newVerNumb=$2
    if [ ! -f $preInstallConfigFile ]; then
        echo "";
        echo "Upgrade to version $newVerNumb ... Failed!";
        echo "Unable to find install config file for version $oldVerNumb ";
        echo "Unable to find file: $preInstallConfigFile ";
        echo "";
        exit 1
    fi
}


## 
# check if already install new version.
funcChkNewVerInstalled () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (New Version Number) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
	newVerNumb=$1
    if [ -f $newInstallConfigFile ]; then
        echo "";
        echo "Upgrade to version $newVerNumb ... Failed!";
        echo "Install config file for version $newVerNumb already exist!";
        echo "$newVerNumb install config file: $newInstallConfigFile ";
        echo "";
        exit 1
    fi
}


## 
# get user entered value back from old config file for upgrade. 
funcReadInstallConfigValueFromFileForUpgrade () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Old Version Install Config File) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
	preInstallConfigFile=$1
    if [ -f $preInstallConfigFile ]; then
        repackInstaller=$(awk -F "=" '/repackInstaller/ {print $2}' $preInstallConfigFile)
        computerBrandName=$(awk -F "=" '/computerBrandName/ {print $2}' $preInstallConfigFile)
        computerModelName=$(awk -F "=" '/computerModelName/ {print $2}' $preInstallConfigFile)
        computerSn=$(awk -F "=" '/computerSn/ {print $2}' $preInstallConfigFile)
        localTimeSpan=$(awk -F "=" '/localTimeSpan/ {print $2}' $preInstallConfigFile)
        cpoId=$(awk -F "=" '/cpoId/ {print $2}' $preInstallConfigFile)
        cpoName=$(awk -F "=" '/cpoName/ {print $2}' $preInstallConfigFile)
        siteId=$(awk -F "=" '/siteId/ {print $2}' $preInstallConfigFile)
        siteName=$(awk -F "=" '/siteName/ {print $2}' $preInstallConfigFile)
        iotHubDeviceName=$mqttProxyClientIdPrefix$cpoId$siteId
        mqttProxyClientId=$mqttProxyClientIdPrefix$cpoId$siteId
		#maxAllowedChargers=$maxAllowedChargersDefault
        maxAllowedChargers=$(awk -F "=" '/maxAllowedChargers/ {print $2}' $preInstallConfigFile)
        if [ -z "${maxAllowedChargers// }" ]; then
            maxAllowedChargers=$maxAllowedChargersSystem
        fi
        ocppPort=$(awk -F "=" '/ocppPort/ {print $2}' $preInstallConfigFile)
        mysqlRootPASS=[REDACTED] -F "=" '/mysqlRootPass/ {print $2}' $preInstallConfigFile)
        dockerIpRange=$(awk -F "=" '/dockerIpRange/ {print $2}' $preInstallConfigFile)
        dockerIpGateway=$(awk -F "=" '/dockerIpGateway/ {print $2}' $preInstallConfigFile)
        #tmpInstallConfigFileDir=$defaultUserHomeDir/$siteName'_'$computerBrandName'_'$computerModelName'_'$computerSn
    else
        echo "";
        echo "Load User Entered value back from config file Failed!  ";
        echo "Unable to find file: $preInstallConfigFile";
        echo "";
        exit 1
    fi
}


## 
# ask enter missing config input for upgrade. 
funcAskUserMissingInputOnSettingForUpgrade () {
    if [ -z "$1" ]; then
        echo "";
        echo "Argument 1 (Is Change License) is not supplied!  [y/n]";
        echo "";
        exit 1
    fi
    if [ "y" == $1 ] || [ "Y" == $1 ] || [ "n" == $1 ] || [ "N" == $1 ]; then
        echo "";
    else
        echo "";
        echo "Argument 1 (Is Change License) is not valid!  [y/n]";
        echo "";
        exit 1
    fi
    flagLicense=$1

    progress_flag_error=1
    while [ 0 != $progress_flag_error ] ; do
        if [ -z "${computerBrandName// }" ]; then
            read -p "Computer Brand Name (no spaces between, allow underline or dash, ex: Asus): " computerBrandName
        fi
        if [ -z "${computerBrandName// }" ]; then
            echo "Input 'Computer Brand Name' is empty or white spaces."
        fi
        if ! [ -z "${computerBrandName// }" ]; then
            progress_flag_error=0
        fi
    done
    echo "";

    progress_flag_error=1
    while [ 0 != $progress_flag_error ] ; do
        if [ -z "${computerModelName// }" ]; then
            read -p "Computer Model Name (no spaces between, allow underline or dash, ex: WS720T): " computerModelName
        fi
        if [ -z "${computerModelName// }" ]; then
            echo "Input 'Computer Model Name' is empty or white spaces."
        fi
        if ! [ -z "${computerModelName// }" ]; then
            progress_flag_error=0
        fi
    done
    echo "";

    progress_flag_error=1
    while [ 0 != $progress_flag_error ] ; do
        if [ -z "${computerSn// }" ]; then
            read -p "Computer Serial Number (no spaces between, allow underline or dash): " computerSn
        fi
        if [ -z "${computerSn// }" ]; then
            echo "Input 'Computer Serial Number' is empty or white spaces."
        fi
        if ! [ -z "${computerSn// }" ]; then
            progress_flag_error=0
        fi
    done
    echo "";

    #if [ "y" == $flagLicense ] || [ "Y" == $flagLicense ]; then
	if [ -z "${maxAllowedChargers// }" ]; then
        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            read -p "Is Licensed more than ${maxAllowedChargersDefault} Chargers? [y/n] (Default: n): " userInput
            if [ -z "${userInput}" ]; then
                userInput="n"
            fi
            if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
                maxAllowedChargers=""
                progress_flag_error=0
            elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
                echo "Use Default Allowed Maximum Chargers Count: ${maxAllowedChargersDefault} "
                maxAllowedChargers=$maxAllowedChargersDefault
                progress_flag_error=0
            fi
        done
        echo "";

        progress_flag_error=1
        while [ 0 != $progress_flag_error ] ; do
            if [ -z "${maxAllowedChargers// }" ]; then
                read -p "License Allowed Maximum Chargers Count (Default: ${maxAllowedChargersDefault}): " maxAllowedChargers
            fi
            if [ -z "${maxAllowedChargers// }" ]; then
                echo "Use Default Allowed Maximum Chargers Count: ${maxAllowedChargersDefault} "
                maxAllowedChargers=$maxAllowedChargersDefault
                progress_flag_error=0
            elif ! [[ $maxAllowedChargers =~ ^[0-9]+$ ]] ; then
                echo "Input 'Allowed Maximum Chargers Count' is not positive number.";
            fi
            if [ "$maxAllowedChargers" -lt 1 ] && [ "$maxAllowedChargers" -gt "$maxAllowedChargersSystem" ] ; then
                echo "Input 'Allowed Maximum Chargers Count' is out-of-range.  (1 ~ ${maxAllowedChargersSystem})";
            fi
            if [[ $maxAllowedChargers =~ ^[0-9]+$ ]]; then
                progress_flag_error=0
            fi
        done
        echo "";
    fi

    progress_flag_error=1
    while [ "0" != "$progress_flag_error" ] ; do
        read -p "Repacking Installer to ZIP File? (Default: y) [y/n]: " userInput
        if [ -z "${userInput}" ]; then
            echo "Repacking Installer to ZIP File as Default...";
            repackInstaller=y
            progress_flag_error=0
        else
            if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
                echo "Repacking installer to ZIP File...";
                repackInstaller=y
                progress_flag_error=0
            elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
                echo "NOT repacking installer to ZIP File...";
                repackInstaller=n
                progress_flag_error=0
            fi
        fi
    done
    echo "";
}


## 
# write install config to new version ini file for upgrade.
funcWriteInstallConfigToIniFileForUpgrade () {
    echo "" > $newInstallConfigFile
    echo "EV Charger Management Standard ${verNumber} " >> $newInstallConfigFile
    echo "Installation MetaData: " >> $newInstallConfigFile
    echo "" >> $newInstallConfigFile
    echo "repackInstaller=${repackInstaller}" >> $newInstallConfigFile
    echo "" >> $newInstallConfigFile
    echo "computerBrandName=${computerBrandName}" >> $newInstallConfigFile
    echo "computerModelName=${computerModelName}" >> $newInstallConfigFile
    echo "computerSn=${computerSn}" >> $newInstallConfigFile
    echo "" >> $newInstallConfigFile
    echo "deployWorkingDir=${deployWorkingDir}" >> $newInstallConfigFile
    echo "localTimeSpan=${localTimeSpan}" >> $newInstallConfigFile
    echo "cpoId=${cpoId}" >> $newInstallConfigFile
    echo "cpoName=${cpoName}" >> $newInstallConfigFile
    echo "siteId=${siteId}" >> $newInstallConfigFile
    echo "siteName=${siteName}" >> $newInstallConfigFile
    echo "iotHubDeviceName=${mqttProxyClientIdPrefix}${cpoId}${siteId}" >> $newInstallConfigFile
    echo "mqttProxyClientId=${mqttProxyClientIdPrefix}${cpoId}${siteId}" >> $newInstallConfigFile
    echo "maxAllowedChargers=${maxAllowedChargers}" >> $newInstallConfigFile
    echo "ocppPort=${ocppPort}" >> $newInstallConfigFile
    echo "latitude=[LAT_REDACTED]" >> $newInstallConfigFile
    echo "longitude=[LONG_REDACTED]" >> $newInstallConfigFile
    echo "mysqlRootPASS=[REDACTED] >> $newInstallConfigFile
    echo "dockerIpRange=${dockerIpRange}" >> $newInstallConfigFile
    echo "dockerIpGateway=${dockerIpGateway}" >> $newInstallConfigFile
    echo "" >> $newInstallConfigFile
    installDT=$(date +'%Y-%m-%d %H:%M:%S')
    echo "installDT=${installDT}" >> $newInstallConfigFile
    echo "installedVersion=${verNumber}" >> $newInstallConfigFile
    echo "authServerApiVersion=${dockerImgVerEmAPI}" >> $newInstallConfigFile
    echo "authServerUiVersion=${dockerImgVerEmUI}" >> $newInstallConfigFile
    echo "wrapperApiVersion=${dockerImgVerWrapperAPI}" >> $newInstallConfigFile
    echo "mqttProxyVersion=${dockerImgVerMqttProxy}" >> $newInstallConfigFile
    echo "cmWebApiVersion=${dockerImgVerWebAPI}" >> $newInstallConfigFile
    echo "cmWebUiVersion=${dockerImgVerWebUI}" >> $newInstallConfigFile
    echo "osLogin=administrator" >> $newInstallConfigFile
    echo "osPASSWD=[REDACTED] >> $newInstallConfigFile
    echo "adminLogin=sysadmin" >> $newInstallConfigFile
    echo "adminPASSWD=[REDACTED] >> $newInstallConfigFile
    echo "adminEmail=[REDACTED_EMAIL]" >> $newInstallConfigFile
    echo "officeLogin=officeadmin" >> $newInstallConfigFile
    echo "officePASSWD=[REDACTED] >> $newInstallConfigFile
    echo "officeEmail=[REDACTED_EMAIL]" >> $newInstallConfigFile
    echo "" >> $newInstallConfigFile
    echo "macAddress=${macAddress}" >> $newInstallConfigFile
    echo "" >> $newInstallConfigFile
}


## 
# copy install config file to directories for upgrade.
funcCpInstallConfigToDir () {
    echo "Copy Install Config File to Directories..."
    mkdir -p $tmpInstallConfigFileDir
    if [ -f $newInstallConfigFile ]; then
        cp -f $newInstallConfigFile $tmpInstallConfigFileDir/$install_config_file
        cp -f $newInstallConfigFile $install_path_cm_std/$install_config_file
    fi
    echo "";
}


## 
# set remove mysql binary log files by days.
funcSetMysqlBinLogFileDays () {
    if [ -f $mysqldConfigFile ]; then
        #sudo cp -rf $mysqldConfigFile $mysqldConfigFileBak
        SudoCmd="sudo cp -rf $mysqldConfigFile $mysqldConfigFileBak"
        echo "CMD: $SudoCmd";
        ($SudoCmd)
        if cat $mysqldConfigFile | grep -q "$mysqldConfigExpireLogsDays"; then
            echo "Set remove mysql binary log files by days ... already set";
        else
            #echo "" >> $mysqldConfigFile
            echo "" | sudo tee -a $mysqldConfigFile
            #echo "# remove binary log file by days." >> $mysqldConfigFile
            echo "# remove binary log file by days." | sudo tee -a $mysqldConfigFile
            #echo "${mysqldConfigExpireLogsDays} = ${mysqldConfigExpireLogsDaysValue}" >> $mysqldConfigFile
            echo "${mysqldConfigExpireLogsDays} = ${mysqldConfigExpireLogsDaysValue}" | sudo tee -a $mysqldConfigFile
            #echo "" >> $mysqldConfigFile
            echo "" | sudo tee -a $mysqldConfigFile
            echo "Set remove mysql binary log files by days... done";
            echo "";
        fi
    else
        echo "";
        echo "Set remove mysql binary log files by days... Failed!  Unable to find file: $mysqldConfigFile";
        echo "";
    fi
}


## 
# set redis service delay start on system boot. 
# sudo required. 
funcSetRedisSvcDelayStartOnBoot () {
    if [ -f $redisServiceFile ]; then
        #sudo cp -rf $redisServiceFile $redisServiceFileBak
        SudoCmd="sudo cp -rf $redisServiceFile $redisServiceFileBak"
        echo "CMD: $SudoCmd";
        ($SudoCmd)
        if grep "^After=.*" $redisServiceFile | grep -q "$dockerServiceName"; then
        #if awk -F "=" '/After/' $redisServiceFile | grep -q "$dockerServiceName"; then
            echo "Set Redis Service delay start ... already set";
        else
            SudoCmd="sudo sed -i 's/^After=.*/& '\"$dockerServiceName\"'/' $redisServiceFile"
            echo "CMD: $SudoCmd";
            `sudo sed -i 's/^After=.*/& '"$dockerServiceName"'/' $redisServiceFile`
    
            echo "Set Redis Service delay start ... done";
        fi
        SudoCmd="sudo rm -rf $redisServiceFileBak"
        echo "CMD: $SudoCmd";
        sudo rm -rf $redisServiceFileBak
        echo "";
    else
        echo "Set Redis Service delay start ... Failed!  Unable to find file: $redisServiceFile";
        echo "";
        exit 1
    fi
}


## 
# set docker service delay start on system boot. 
# sudo required. 
funcSetDockerSvcDelayStartOnBoot () {
    if [ -f $dockerServiceFile ]; then
        #sudo cp -rf $dockerServiceFile $dockerServiceFileBak
        SudoCmd="sudo cp -rf $dockerServiceFile $dockerServiceFileBak"
        echo "CMD: $SudoCmd";
        ($SudoCmd)
        if grep "^After=.*" $dockerServiceFile | grep -q "$mysqlServiceName"; then
        #if awk -F "=" '/After/' $dockerServiceFile | grep -q "$mysqlServiceName"; then
            echo "Set Docker Service delay start ... already set";
        else
            SudoCmd="sudo sed -i 's/^After=.*/& '\"$mysqlServiceName\"'/' $dockerServiceFile"
            echo "CMD: $SudoCmd";
            `sudo sed -i 's/^After=.*/& '"$mysqlServiceName"'/' $dockerServiceFile`
    
            echo "Set Docker Service delay start ... done";
        fi
        SudoCmd="sudo rm -rf $dockerServiceFileBak"
        echo "CMD: $SudoCmd";
        sudo rm -rf $dockerServiceFileBak
        echo "";
    else
        echo "Set Docker Service delay start ... Failed!  Unable to find file: $dockerServiceFile";
        echo "";
        exit 1
    fi
}


## 
# create external storage backup directory for upgrade. 
funcExtStoreBackupDirectory () {
    if mountpoint -q $external_mnt_pt
    then
        # Create External backup directory, if not exist. 
        mkdir -p $external_backup_path_mongo_auth

        mkdir -p $external_backup_path_mysql_webapi

        mkdir -p $external_backup_path_mysql_auth
        mkdir -p $external_backup_path_mysql_auth_ancillary
        mkdir -p $external_backup_path_mysql_auth_model
        mkdir -p $external_backup_path_mysql_auth_form
        mkdir -p $external_backup_path_mysql_auth_sspl
        mkdir -p $external_backup_path_mysql_auth_web
        mkdir -p $external_backup_path_mysql_auth_widget
    
        mkdir -p $external_backup_path_mysql_evcore
        mkdir -p $external_backup_path_mysql_evcore_data
        mkdir -p $external_backup_path_mysql_evcore_device
        mkdir -p $external_backup_path_mysql_evcore_gateway
        mkdir -p $external_backup_path_mysql_evcore_ocpp16
        mkdir -p $external_backup_path_mysql_evcore_power
        mkdir -p $external_backup_path_mysql_evcore_realtime
        mkdir -p $external_backup_path_mysql_evcore_remote

        # set directory permission.
        chmod -R 776 $external_backup_path_mongo_auth

        chmod -R 776 $external_backup_path_mysql_webapi

        chmod -R 776 $external_backup_path_mysql_auth
        #chmod -R 776 $external_backup_path_mysql_auth_ancillary
        #chmod -R 776 $external_backup_path_mysql_auth_model
        #chmod -R 776 $external_backup_path_mysql_auth_form
        #chmod -R 776 $external_backup_path_mysql_auth_sspl
        #chmod -R 776 $external_backup_path_mysql_auth_web
        #chmod -R 776 $external_backup_path_mysql_auth_widget

        chmod -R 776 $external_backup_path_mysql_evcore
        #chmod -R 776 $external_backup_path_mysql_evcore_data
        #chmod -R 776 $external_backup_path_mysql_evcore_device
        #chmod -R 776 $external_backup_path_mysql_evcore_gateway
        #chmod -R 776 $external_backup_path_mysql_evcore_ocpp16
        #chmod -R 776 $external_backup_path_mysql_evcore_power
        #chmod -R 776 $external_backup_path_mysql_evcore_realtime
        #chmod -R 776 $external_backup_path_mysql_evcore_remote

        echo "Crate External Backup Storage Directory ... done";
    else
        echo "External Backup Storage is Not Mounted.";
        echo "Unable to create or set permission of backup directory on external backup storage.";
    fi
}


## 
# reset MySQL db backup scripts for upgrade. 
funcResetMysqlBackupScriptForUpgrade () {
    # crontab -u administrator -l | grep -v "mysql_backup_scripts_std" | crontab -u administrator -
    crontab -u administrator -l | grep -v "$path_db_backup" | crontab -u administrator -
    crontab -l | grep -v "$path_db_backup" | crontab -
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_backup_webapi ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_backup_webapi $install_path_db_backup/$file_script_db_backup_webapi
        chown administrator:administrator $install_path_db_backup/$file_script_db_backup_webapi
        chmod +x $install_path_db_backup/$file_script_db_backup_webapi
    fi
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_restore_webapi ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_restore_webapi $install_path_db_backup/$file_script_db_restore_webapi
        chown administrator:administrator $install_path_db_backup/$file_script_db_restore_webapi
    fi
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_backup_evcore ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_backup_evcore $install_path_db_backup/$file_script_db_backup_evcore
        chown administrator:administrator $install_path_db_backup/$file_script_db_backup_evcore
        chmod +x $install_path_db_backup/$file_script_db_backup_evcore
    fi
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_restore_evcore ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_restore_evcore $install_path_db_backup/$file_script_db_restore_evcore
        chown administrator:administrator $install_path_db_backup/$file_script_db_restore_evcore
    fi
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_backup_auth ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_backup_auth $install_path_db_backup/$file_script_db_backup_auth
        chown administrator:administrator $install_path_db_backup/$file_script_db_backup_auth
        chmod +x $install_path_db_backup/$file_script_db_backup_auth
    fi
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_restore_auth ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_restore_auth $install_path_db_backup/$file_script_db_restore_auth
        chown administrator:administrator $install_path_db_backup/$file_script_db_restore_auth
    fi
    if [ -f $deployWorkingDir/$path_db_backup/$file_script_db_backup_cron ]; then
        cp -rf $deployWorkingDir/$path_db_backup/$file_script_db_backup_cron $install_path_db_backup/$file_script_db_backup_cron
        chown administrator:administrator $install_path_db_backup/$file_script_db_backup_cron
        chmod 764 $install_path_db_backup/$file_script_db_backup_cron
    fi
    echo "Reset MySQL DB Auto Backup Script... done";
    echo "";
}


## 
# reset MySQL backup to crontab for upgrade.  
funcResetMysqlBackupCrontabForUpgrade () {
    crontab_cmd_list=`crontab -l`

    if echo "$crontab_cmd_list" | grep -q "$script_file_webapi"; then
       echo "MySQL DB Web API Backup cron job had been added.";
    else
       crontab -u administrator -l | { cat; echo "0 * * * * $script_file_webapi"; } | crontab -u administrator -
       #crontab -l | { cat; echo "0 * * * * $script_file_webapi"; } | crontab -
    fi

    if echo "$crontab_cmd_list" | grep -q "$script_file_evcore"; then
       echo "MySQL DB EV-Core Backup cron job had been added.";
    else
       crontab -u administrator -l | { cat; echo "0 */12 * * * $script_file_evcore"; } | crontab -u administrator -
       #crontab -l | { cat; echo "0 */12 * * * $script_file_evcore"; } | crontab -
    fi

    if echo "$crontab_cmd_list" | grep -q "$script_file_auth"; then
       echo "MySQL DB Auth Server Backup cron job had been added.";
    else
       crontab -u administrator -l | { cat; echo "0 0 * * * $script_file_auth"; } | crontab -u administrator -
       #crontab -l | { cat; echo "0 0 * * * $script_file_auth"; } | crontab -
    fi
    echo "Reset MySQL DB backup to crontab ... done"
    echo "";
}


## 
# reset Mongo db backup scripts for upgrade. 
funcResetMongoBackupScriptForUpgrade () {
    crontab -u administrator -l | grep -v "mongo_backup_scripts_std" | crontab -u administrator -
    crontab -u administrator -l | grep -v "$path_db_backup_mongo" | crontab -u administrator -

    mkdir -p $install_path_db_backup_mongo 
    if [ -f $deployWorkingDir/$path_db_backup_mongo/$file_script_db_mongo_backup_auth ]; then
        cp -rf $deployWorkingDir/$path_db_backup_mongo/$file_script_db_mongo_backup_auth $install_path_db_backup_mongo/$file_script_db_mongo_backup_auth
        chown administrator:administrator $install_path_db_backup_mongo/$file_script_db_mongo_backup_auth
        chmod +x $install_path_db_backup_mongo/$file_script_db_mongo_backup_auth
    fi
    if [ -f $deployWorkingDir/$path_db_backup_mongo/$file_script_db_mongo_restore_auth ]; then
        cp -rf $deployWorkingDir/$path_db_backup_mongo/$file_script_db_mongo_restore_auth $install_path_db_backup_mongo/$file_script_db_mongo_restore_auth
        chown administrator:administrator $install_path_db_backup_mongo/$file_script_db_mongo_restore_auth
    fi
    if [ -f $deployWorkingDir/$path_db_backup_mongo/$file_script_db_mongo_backup_cron ]; then
        cp -rf $deployWorkingDir/$path_db_backup_mongo/$file_script_db_mongo_backup_cron $install_path_db_backup_mongo/$file_script_db_mongo_backup_cron
        chown administrator:administrator $install_path_db_backup_mongo/$file_script_db_mongo_backup_cron
        chmod 764 $install_path_db_backup_mongo/$file_script_db_mongo_backup_cron
    fi
    echo "Reset Mongo DB Auto Backup Script... done";
    echo "";
}


## 
# 15. reset MongoDB backup to crontab for upgrade. 
funcResetMongoBackupCrontabForUpgrade () {
    crontab_cmd_list=`crontab -l`

    if echo "$crontab_cmd_list" | grep -q "$script_file_auth_mongo"; then
       echo "Mongo DB Auth Server Backup cron job had been added.";
    else
       crontab -u administrator -l | { cat; echo "0 0 * * * $script_file_auth_mongo"; } | crontab -u administrator -
    fi
    echo "Reset Mongo DB backup to crontab ... done"
    echo "";
}


## 
# copy log retrieve scripts for upgrade. 
funcCopyLogRetrieveScriptForUpgrade () {
    mkdir -p $install_path_log_retrieve 
    if [ -f $deployWorkingDir/$path_log_retrieve/$file_script_log_retrieve_std ]; then
        cp -rf $deployWorkingDir/$path_log_retrieve/$file_script_log_retrieve_std $install_path_log_retrieve/$file_script_log_retrieve_std
        chown administrator:administrator $install_path_log_retrieve/$file_script_log_retrieve_std
        chmod +x $install_path_log_retrieve/$file_script_log_retrieve_std
    fi
    echo "Copy Log Retrieve Script ... done";
    echo "";
}


## 
# reset gen mac script. 
funcResetGenMacScriptForUpgrade () {
    mkdir -p $install_path_gen_mac
    if [ -f $deployWorkingDir/$path_gen_mac/$file_script_gen_mac_std ]; then
        cp -rf $deployWorkingDir/$path_gen_mac/$file_script_gen_mac_std $install_path_gen_mac/$file_script_gen_mac_std
        chown administrator:administrator $install_path_gen_mac/$file_script_gen_mac_std
        chmod +x $install_path_gen_mac/$file_script_gen_mac_std
    fi
    if [ -f $deployWorkingDir/$path_gen_mac/$file_script_gen_mac_std_cron ]; then
        cp -rf $deployWorkingDir/$path_gen_mac/$file_script_gen_mac_std_cron $install_path_gen_mac/$file_script_gen_mac_std_cron
        chown administrator:administrator $install_path_gen_mac/$file_script_gen_mac_std_cron
        chmod 764 $install_path_gen_mac/$file_script_gen_mac_std_cron
    fi
    crontab_cmd_list=`crontab -l`
    script_file_gen_mac=$install_path_gen_mac/$file_script_gen_mac_std
    if echo "$crontab_cmd_list" | grep -q "$script_file_gen_mac"; then
       echo "Gen MAC File cron job had been added.";
    else
       crontab -u administrator -l | { cat; echo "0 * * * * $script_file_gen_mac"; } | crontab -u administrator -
    fi
    echo "Set Gen MAC Script... done";
    echo "";
}


## 
# start auth server docker. 
funcDockerStartAuthSrv () {
    if [ -f $install_path_auth_srv/$file_docker_compose_file ]; then
        cd $install_path_auth_srv
        docker-compose up -d
        sleep 10
        echo "Start Auth Server... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Start Auth Server... Failed!  Unable to find file: $install_path_auth_srv/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}

## 
# stop auth server docker. 
funcDockerStopAuthSrv () {
    if [ -f $install_path_auth_srv/$file_docker_compose_file ]; then
        cd $install_path_auth_srv
        docker-compose down
        sleep 10
        echo "Stop Auth Server... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Stop Auth Server... Failed!  Unable to find file: $install_path_auth_srv/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}


## 
# start wrapper api docker. 
funcDockerStartWrapperApi () {
    if [ -f $install_path_wrap_api/$file_docker_compose_file ]; then
        cd $install_path_wrap_api
        docker-compose up -d
        sleep 10
        echo "Start Wrapper API... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Start Wrapper API... Failed!  Unable to find file: $install_path_wrap_api/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}

## 
# stop wrapper api docker. 
funcDockerStopWrapperApi () {
    if [ -f $install_path_wrap_api/$file_docker_compose_file ]; then
        cd $install_path_wrap_api
        docker-compose down
        sleep 10
        echo "Stop Wrapper API... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Stop Wrapper API... Failed!  Unable to find file: $install_path_wrap_api/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}


## 
# start mqtt proxy docker. 
funcDockerStartMqttProxy () {
    if [ -f $install_path_mqtt_proxy/$file_docker_compose_file ]; then
        cd $install_path_mqtt_proxy
        docker-compose up -d
        sleep 10
        echo "Start MQTT Proxy... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Start MQTT Proxy... Failed!  Unable to find file: $install_path_mqtt_proxy/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}

## 
# stop mqtt proxy docker. 
funcDockerStopMqttProxy () {
    if [ -f $install_path_mqtt_proxy/$file_docker_compose_file ]; then
        cd $install_path_mqtt_proxy
        docker-compose down
        sleep 10
        echo "Stop MQTT Proxy... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Stop MQTT Proxy... Failed!  Unable to find file: $install_path_mqtt_proxy/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}


## 
# start web api docker. 
funcDockerStartWebApi () {
    if [ -f $install_path_cm_std/$file_docker_compose_file ]; then
        cd $install_path_cm_std
        docker-compose up -d
        sleep 10
        echo "Start Web API... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Start Web API... Failed!  Unable to find file: $install_path_cm_std/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}

## 
# stop web api docker. 
funcDockerStopWebApi () {
    if [ -f $install_path_cm_std/$file_docker_compose_file ]; then
        cd $install_path_cm_std
        docker-compose down
        sleep 10
        echo "Stop Web API... done";
        echo "";
        cd $deployWorkingDir
    else
        cd $deployWorkingDir
        echo "Stop Web API... Failed!  Unable to find file: $install_path_cm_std/$file_docker_compose_file";
        echo "";
        exit 1
    fi
}


## 
# run license key for upgrade. 
funcRunLicenseKeyForUpgrade () {
    echo $progress_create_license_key > $progress_file
    # create license key. 
    echo "Create License Key... ";
    if [ ! -f $deployWorkingDir/$installScript04Bin ]; then
        cd $deployWorkingDir
        echo "Create License Key... Failed!  ";
        echo "Unable to find file: $deployWorkingDir/$installScript04Bin";
        echo "";
        exit 1
    fi
    chmod 764 $deployWorkingDir/$installScript04Bin
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
}


## 
# remove create license key script. 
funcRemoveCreateLicenseKeyScriptForUpgrade () {
    echo "Remove Generate License Key Program ... ";
    if [ -f $deployWorkingDir/$installScript04Bin ]; then
        rm -f $deployWorkingDir/$installScript04Bin
    fi
    echo "Run License Key... done";
    echo "";
}


## 
# remove original compressed installer file for upgrade. 
funcRemoveCompressedInstallerFileForUpgrade () {
    if [ -f $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber*.zip ]; then
        rm -f $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber*.zip
    	echo "Remove Original Compressed Installer File... done";
    else
        echo "Unable to remove original compressed installer file ... ";
        echo "Unable to find file: $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber*.zip";
    fi
    if [ -f $defaultUserHomeDir/$compressedUpdaterFilePrefix$verNumber*.zip ]; then
        rm -f $defaultUserHomeDir/$compressedUpdaterFilePrefix$verNumber*.zip
    	echo "Remove Original Compressed Updater File... done";
    else
        echo "Unable to remove original compressed installer file ... ";
        echo "Unable to find file: $defaultUserHomeDir/$compressedUpdaterFilePrefix$verNumber*.zip";
    fi
    echo "";
}


## 
# repack installed installer directory for upgrade. 
funcRepackInstalledInstallerDirectoryForUpgrade () {
    if [ "y" == $repackInstaller ]; then
        echo "Repacking Installed Installer Directory...";
        if [ -d $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber ]; then
            cd $defaultUserHomeDir
            filenamePostfix=_$(date "+%Y%m%d")_installed.zip
            zip -rq $compressedInstallerFilePrefix$verNumber$filenamePostfix $compressedInstallerFilePrefix$verNumber
            if [ -f $external_mnt_pt ]; then
                echo "Copy Repacked Installed Installer File to Backup Disk ... ";
                cp $compressedInstallerFilePrefix$verNumber$filenamePostfix $external_mnt_pt
            else
                echo "Unable to copy repacked installed installer file to backup disk ... ";
                echo "Unable to find backup disk: $external_mnt_pt";
                echo "";
            fi
            cd $deployWorkingDir
        else
            echo "Unable to repack installed installer directory ... ";
            echo "Unable to find directory: $defaultUserHomeDir/$compressedInstallerFilePrefix$verNumber";
            echo "";
        fi
        echo "Repacking Installed Updater Directory...";
        if [ -d $defaultUserHomeDir/$compressedUpdaterFilePrefix$verNumber ]; then
            cd $defaultUserHomeDir
            filenamePostfix=_$(date "+%Y%m%d")_installed.zip
            zip -rq $compressedUpdaterFilePrefix$verNumber$filenamePostfix $compressedUpdaterFilePrefix$verNumber
            if [ -f $external_mnt_pt ]; then
                echo "Copy Repacked Installed Updater File to Backup Disk ... ";
                cp $compressedUpdaterFilePrefix$verNumber$filenamePostfix $external_mnt_pt
            else
                echo "Unable to copy repacked installed Updater file to backup disk ... ";
                echo "Unable to find backup disk: $external_mnt_pt";
                echo "";
            fi
            cd $deployWorkingDir
        else
            echo "Unable to repack installed Updater directory ... ";
            echo "Unable to find directory: $defaultUserHomeDir/$compressedUpdaterFilePrefix$verNumber";
            echo "";
        fi
    else
        echo "Skip Repacking Installed Installer or Updater Directory...";
    fi
}



