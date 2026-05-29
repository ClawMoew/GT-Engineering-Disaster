#!/bin/bash

###
# Charger Management Standard. 
# Software Patch from v.1.4.4.hf5 to v.1.4.4.hf8. 
# For Ubuntu 20.04 LTS. 
# Execute this script in console from GUI mode. 
# 
# Tasks: 
# 01. check previous installation, copy convert previous install config file. 
# 02. ask for missing config. 
# 03. load new docker images. 
# 04. stop auth server docker. 
# 05. modify docker-compose file for auth server. 
# 06. stop web api docker. 
# 07. modify docker-compose file for web api. 
# 08. get mac list. 
# 09. start web api docker. 
# 10. start auth server docker. 
# after upgrade, reboot is recommended. 
###


# version number variables.
source 00_EvMgmtStd_versions.sh

oldVerNumb=$verNumb_1_4_4_hf5
newVerNumb=$verNumb_1_4_4_hf8
verNumber=$newVerNumb

# installer program variables.
source 00_EvMgmtStd_variables.sh

macAddress=$(cat /sys/class/net/en*/address)
macAddress="${macAddress//$'\n'/, }"

# installer file and path variables.
source 00_EvMgmtStd_file_list.sh

deployWorkingDir=$(pwd)
#deployWorkingDir=$defaultUserHomeDir/$compressedInstallerFilePrefix$newVerNumb
preInstallConfigFile=$defaultUserHomeDir/$compressedInstallerFilePrefix$oldVerNumb/$install_config_file
newInstallConfigFile=$deployWorkingDir/$install_config_file
#newInstallConfigFile=$defaultUserHomeDir/$compressedInstallerFilePrefix$newVerNumb/$install_config_file
#deployWorkingDir=$defaultUserHomeDir/$compressedUpdaterFilePrefix$newVerNumb
#preInstallConfigFile=$defaultUserHomeDir/$compressedUpdaterFilePrefix$oldVerNumb/$install_config_file
#newInstallConfigFile=$defaultUserHomeDir/$compressedUpdaterFilePrefix$newVerNumb/$install_config_file

# installer progress flag variables.
source 00_EvMgmtStd_progress_flag.sh

# installer functions.
source 00_EvMgmtStd_functions.sh


echo "";
echo "Charger Management Standard Software Patch from $oldVerNumb to $newVerNumb ...";
echo "";

# check if remote session. 
funcChkIsRemoteSession


# check if use sudo. 
funcChkIsNotSudo $patchScript_144hf5_144hf8


# 01. check previous installation, copy convert previous install config file. 
# check preinstalled file info.
echo "01. Check Previous Installation for version $oldVerNumb ...";
funcSetPrevInstSrcDir $oldVerNumb $newVerNumb
funcChkPreinstallConfigFile $oldVerNumb $newVerNumb

# check if already install new version.
echo "Check Installation for version $newVerNumb ...";
funcChkNewVerInstalled $newVerNumb

# copy previous install config file content to new install config file. 
echo "Create Installation Config File for version $newVerNumb from old version $oldVerNumb ...";
funcReadInstallConfigValueFromFileForUpgrade $preInstallConfigFile


# 02. ask missing config input. 
echo "02. ";
echo "Please enter following installation configuration settings: "
echo "Press <Enter> key after value entered, or just press <Enter> key for using default value for optional settings. "
echo "Press <Ctrl> + <C> key to cancel. "
echo "";
funcAskUserMissingInputOnSettingForUpgrade n

funcWriteInstallConfigToIniFileForUpgrade

# set tmp install config file directory.
#tmpInstallConfigFileDir=$defaultUserHomeDir/$siteName
tmpInstallConfigFileDir=$defaultUserHomeDir/$siteName'_'$computerBrandName'_'$computerModelName'_'$computerSn

# copy install config file to directories.
funcCpInstallConfigToDir


# 03. load new docker images. 
echo "03. Load docker image from local file...";
funcLoadDockerImgWebApi
funcLoadDockerImgEmApi
echo "Load docker image from local file directory '$deployWorkingDir/$path_docker_image_files' ... done";
echo "";


# 04. stop auth server docker. 
echo "04. Stop Auth Server...";
funcDockerStopAuthSrv


# 05. modify docker-compose file for auth server. 
echo "05. Modify Docker Compose File for Auth Server...";
if [ -f $install_path_auth_srv/$file_docker_compose_file ]; then
    cp $install_path_auth_srv/$file_docker_compose_file $install_path_auth_srv/$file_docker_compose_file_patch_bak
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
    echo "Modify Docker Compose File for Auth Server... done";
    echo "";
else
    echo "Modify Docker Compose File for Auth Server... Failed!  Unable to find file: $install_path_auth_srv/$file_docker_compose_file";
    echo "";
    exit 1
fi


# 06. stop web api docker. 
echo "06. Stop Web API...";
funcDockerStopWebApi


# 07. modify docker-compose file for web api. 
echo "07. Modify Docker Compose File for Web API...";
if [ -f $install_path_cm_std/$file_docker_compose_file ]; then
    cp $install_path_cm_std/$file_docker_compose_file $install_path_cm_std/$file_docker_compose_file_patch_bak
    sed -i "s/$dockerComposeFileImgVarSearchKeyWebAPI.*/$dockerComposeFileImgVarSearchKeyWebAPI$dockerImgVerWebAPI/" $install_path_cm_std/$file_docker_compose_file
    echo "Modify Docker Compose File for Web API... done";
    echo "";
else
    echo "Modify Docker Compose File for Web API... Failed!  Unable to find file: $install_path_cm_std/$file_docker_compose_file";
    echo "";
    exit 1
fi


# 08. get mac list. 
echo "08. Get MAC List File...";
cat /sys/class/net/en*/address | sed s/://g > $deployWorkingDir/$mac_address_list_file
cp -f $deployWorkingDir/$mac_address_list_file $tmpInstallConfigFileDir/$mac_address_list_file
cp -f $deployWorkingDir/$mac_address_list_file $install_path_cm_std/$mac_address_list_file
echo "";


# 09. start web api docker. 
echo "09. Start Web API...";
funcDockerStartWebApi


# 10. start auth server docker. 
echo "10. Start Auth Server...";
funcDockerStartAuthSrv


echo $progress_done > $progress_file

# notifysystem reboot.
echo "Charger Management Standard Software Patch from $oldVerNumb to $newVerNumb ... Done";
echo "";


exit 0
