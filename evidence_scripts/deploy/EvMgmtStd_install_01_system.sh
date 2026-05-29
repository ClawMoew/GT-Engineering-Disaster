#!/bin/bash

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 01. Install System Packages. 
# Execute this script in console from GUI mode. 
# Use sudo to execute this script. 
# 
# MySQL Repository Key may be Expired! 
# Get new version repository file from MySQL. 
# https://dev.mysql.com/downloads/repo/apt/ 
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
funcChkIsSudo $installScript01


## 
# initial or check progress file.
funcChkInitInstallForFirstOnly

funcChkDoneInstall

# set working directory. 
#deployWorkingDir=$(pwd)

# get MAC address. 
macAddress=$(cat /sys/class/net/en*/address)
macAddress="${macAddress//$'\n'/, }"
cat /sys/class/net/en*/address | sed s/://g > $mac_address_list_file

# remove install config when has missing values. 
funcChkInstallConfigFileValues y


## 
# Ask input paramters within script execution. 
funcAskUserInputOnSetting

## 
# write install config to ini file.
funcWriteInstallConfigToIniFile

## 
# get user entered value back from config file. 
funcReadInstallConfigValueFromFile


##
# Install Required System Packages. 
# by console command. 
##

# update system 
if cat $progress_file | grep -q "$progress_init_os_upd"; then
    echo "Update OS...";
    apt-get update
    apt update
    apt upgrade
    # Use GUI to preform System Update.
    # -> reboot system is required. 
    # reboot system 
    echo $progress_pkg_sshd > $progress_file
    echo "Update OS... done";
    echo "";
    echo "Please Reboot System, and restart this install script '$installScript01' as \"root\"."
    echo "";
    exit 0
fi

# install sshd
if cat $progress_file | grep -q "$progress_pkg_sshd"; then
    if ! dpkg -S openssh-server >/dev/null 2>/dev/null; then
        echo "Install and Start SSHD...";
        apt install -y -q openssh-server
        systemctl restart ssh
        systemctl enable ssh
        echo $progress_pkg_sys_tool > $progress_file
        echo "Install and Start SSHD... done";
        echo "";
    else
        echo "SSHD Installed... continue";
        echo "";
        echo $progress_pkg_sys_tool > $progress_file
    fi
fi

# install system tools 
if cat $progress_file | grep -q "$progress_pkg_sys_tool"; then
    echo "Install System Tools...";
    apt-get install -y -q curl net-tools jq jo 
    apt-get install -y -q httpie apt-transport-https ca-certificates gnupg lsb-release software-properties-common 
    apt install -y -q dos2unix rar unrar p7zip-full p7zip-rar
    if dpkg -l ubuntu-desktop >/dev/null 2>/dev/null; then
        apt-get install -y -q gnome-system-tools gnome-tweaks brasero gufw hardinfo meld usb-creator-gtk
        #apt-get install -y -q vim vim-gtk
    fi
    echo $progress_pkg_libreoffice > $progress_file
    echo "Install System Tools... done";
    echo "";
fi

# install libreoffice 
if cat $progress_file | grep -q "$progress_pkg_libreoffice"; then
    if dpkg -l ubuntu-desktop >/dev/null 2>/dev/null; then
        echo "Install LibreOffice for Desktop version...";
        apt install -y -q libreoffice-gnome libreoffice
        echo "Install LibreOffice for Desktop version... done";
        echo "";
    fi
    echo $progress_pkg_dev_tool > $progress_file
fi

# install developer package
if cat $progress_file | grep -q "$progress_pkg_dev_tool"; then
    echo "Install developer packages...";
    apt install -y -q build-essential cmake libssl-dev openjdk-11-jdk
    echo $progress_pkg_wireshark > $progress_file
    #echo $progress_pkg_antivirus > $progress_file
    echo "Install developer packages... done";
    echo "";
fi

# install antivirus package 
if cat $progress_file | grep -q "$progress_pkg_antivirus"; then
    echo "Install antivirus packages...";
    echo "To run AntiVirus software, System requires 16GB of RAM. ";
	system_memory_min=14
    system_memory_total=$(free -g | grep Mem: | awk '{print $2}')
	if [ system_memory_min > system_memory_total ]; then
        echo "";
        echo "Not enough System RAM!";
        echo "Install antivirus packages... skipped";
    else
        echo "";
        progress_flag_error=1
        while [ "0" != "$progress_flag_error" ] ; do
            read -p "Continue install AntiVirus software? (Default: n) [y/n]: " userInput
            if [ -z "${userInput}" ]; then
                userInput=n
            fi
            if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
                progress_flag_error=0
            elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
                echo "User skipped install AntiVirus software...";
                progress_flag_error=0
            fi
        done
        if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
            apt install -y -q clamav clamav-daemon
            if dpkg -l ubuntu-desktop >/dev/null 2>/dev/null; then
                apt install -y -q clamtk
            fi
            # update virus database 
            systemctl stop clamav-freshclam
            freshclam
            # set start at boot 
            systemctl start clamav-freshclam
            systemctl enable clamav-freshclam
            #systemctl enable clamav-daemon
            #systemctl start clamav-daemon
            echo "Install antivirus packages... done";
        fi
    fi
    echo "";
    cp $progress_file $progress_file_previous
    echo $progress_pkg_wireshark > $progress_file
fi

# instal wireshark package
if cat $progress_file | grep -q "$progress_pkg_wireshark"; then
    echo "Install wireshark packages...";
    echo "";
    echo "In Configuring wireshark-common Screen: ";
    echo "1. Select [Yes], to allow non-superusers to able capture packets. ";
    echo "";
    progress_flag_error=1
    while [ "0" != "$progress_flag_error" ] ; do
        read -p "Continue install wireshark? [y/n]: " userInput
        if [ -z "${userInput}" ]; then
            userInput=" "
        fi
        if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
            progress_flag_error=0
        elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
            echo "User aborted installation...";
            progress_flag_error=0
            exit 1
        fi
    done
    apt install -y wireshark
    sleep 5
    usermod -aG wireshark administrator
    echo $progress_create_inst_path > $progress_file
    echo "Install wireshark packages... done";
    echo "";
fi

# create install path.
if cat $progress_file | grep -q "$progress_create_inst_path"; then
    funcCreatInstallDirectory
    echo $progress_create_sys_log_rotate_file_evcore > $progress_file
    echo "";
fi

# create system log rotate file for ev-core.
if cat $progress_file | grep -q "$progress_create_sys_log_rotate_file_evcore"; then
    echo "Creating System Log Rotate Config File for EV-Core...";
    echo -e "/opt/delta/apps/ev-solution-device-management/logs/*.log\n/opt/delta/apps/ev-solution-data-collector/logs/*.log\n/opt/delta/apps/ev-solution-ocpp16-server/logs/*.log\n/opt/delta/apps/ev-solution-power-management/logs/*.log\n/opt/delta/apps/ev-solution-realtime-service/logs/*.log\n/opt/delta/apps/ev-solution-remote-control/logs/*.log\n/opt/delta/apps/ev-solution-api-gateway/logs/*.log {\n daily\n rotate 30\n maxsize 20M\n missingok\n notifempty\n copytruncate\n compress\n delaycompress\n}" > $systemLogRotateFileEvCore
    echo $progress_fetch_mysql_installer > $progress_file
    echo "";
fi

# install mysql server, client and workbench 
if cat $progress_file | grep -q "$progress_fetch_mysql_installer"; then
    if ! dpkg -S mysql-apt-config >/dev/null 2>/dev/null; then
        echo "";
        echo "****************************************************************************";
        echo "Caution: "
        echo " MySQL Repository Key may be Expired! ";
        echo " When NOT prompt \"enter root password\", or MySQL Workbench NOT installed, "
        echo " Get get version of Repository file from MySQL. ";
        echo " https://dev.mysql.com/downloads/repo/apt/ ";
        echo "****************************************************************************";
        echo "";
        echo "Download MySQL Repository File ...";
        rm -f mysql-apt-config*.deb
        #wget https://dev.mysql.com/get/mysql-apt-config_0.8.24-1_all.deb
        wget $mysqlConfigVersionUrl
        echo "";
        echo "In MySQL Config Screen: ";
        echo "1. Select [MySQL Server & Cluster], then [Confirm] button. ";
        echo "2. Select [mysql-8.0], then [Confirm] button. ";
        echo "3. Select [OK], then [Confirm] button. ";
        echo "";
        progress_flag_error=1
        while [ "0" != "$progress_flag_error" ] ; do
            read -p "Continue install MySQL Config? [y/n]: " userInput
            if [ -z "${userInput}" ]; then
                userInput=" "
            fi
            if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
                progress_flag_error=0
            elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
                echo "User aborted installation...";
                progress_flag_error=0
                exit 1
            fi
        done
        #apt install -y -q ./mysql-apt-config_0.8.24-1_all.deb
        apt install -y -q ./$mysqlConfigVersionFile
        apt-get update
        echo "Download MySQL Repository ... done";
        echo "";
    fi
    echo $progress_pkg_mysql_server > $progress_file
fi

if cat $progress_file | grep -q "$progress_pkg_mysql_server"; then
    if ! dpkg -S mysql-server >/dev/null 2>/dev/null; then
        echo "Install MySQL Server...";echo "";
        echo "In MySQL Install Screen: ";
        echo "1. Enter MySQL root account password, then [Confirm] button. ";
        echo "2. Re-Enter MySQL root account password, then [Confirm] button. ";
        echo "3. On authentication encrption method notification, select [Confirm] button. ";
        echo "4. on Select default authentication plugin, select [Use Strong Password Encrption (RECOMMENDED)], then [Confirm] button. ";
        echo "";
        progress_flag_error=1
        while [ "0" != "$progress_flag_error" ] ; do
            read -p "Continue install MySQL Server? [y/n]: " userInput
            if [ -z "${userInput}" ]; then
                userInput=" "
            fi
            if [ "y" == $userInput ] || [ "Y" == $userInput ]; then
                progress_flag_error=0
            elif [ "n" == $userInput ] || [ "N" == $userInput ]; then
                echo "User aborted installation...";
                progress_flag_error=0
                exit 1
            fi
        done
        apt install -y mysql-server
        sleep 10
        echo "Install MySQL Server... done";
        echo "";
    fi
    #echo $progress_pkg_mysql_client > $progress_file
    echo $progress_set_mysql_del_bin_log_file > $progress_file
fi

# set remove mysql binary log files by days.
if cat $progress_file | grep -q "$progress_set_mysql_del_bin_log_file"; then
    if [ -f $mysqldConfigFile ]; then
        sudo cp -rf $mysqldConfigFile $mysqldConfigFileBak
        echo "" >> $mysqldConfigFile
        echo "# remove binary log file by days." >> $mysqldConfigFile
        echo "${mysqldConfigExpireLogsDays} = ${mysqldConfigExpireLogsDaysValue}" >> $mysqldConfigFile
        echo "" >> $mysqldConfigFile
        echo "Set remove mysql binary log files by days... done";
        echo "";
    else
        echo "";
        echo "Set remove mysql binary log files by days... Failed!  Unable to find file: $mysqldConfigFile";
        echo "";
    fi
    echo $progress_pkg_mysql_client > $progress_file
fi

if cat $progress_file | grep -q "$progress_pkg_mysql_client"; then
    if ! dpkg -S mysql-client >/dev/null 2>/dev/null; then
        echo "Install MySQL Client...";
        apt-get update
        apt install -y -q mysql-client
        sleep 5
        echo "Install MySQL Client... done";
        echo "";
    fi
    if ! dpkg -S mysql-workbench-community >/dev/null 2>/dev/null; then
        if dpkg -l ubuntu-desktop >/dev/null 2>/dev/null; then
            echo "Install MySQL Workbench...";
            #apt install -y -q mysql-workbench-community
            # Due to MySQL gived-up (screwed up) workbench support for ubuntu 20.04, thus download and install older version. 
            rm -f mysql-workbench-community*.deb
            #wget https://downloads.mysql.com/archives/get/p/8/file/mysql-workbench-community_8.0.29-1ubuntu20.04_amd64.deb
            #apt install -y -q ./mysql-workbench-community_8.0.29-1ubuntu20.04_amd64.deb
            wget $mysqlWrokBenchVersionUrl
            apt install -y -q ./$mysqlWorkBenchVersionFile
            sleep 5
            echo "Install MySQL Workbench... done";
            echo "";
        fi
    fi
    echo $progress_pkg_redis > $progress_file
    apt update
    apt upgrade
fi

# install redis-server
if cat $progress_file | grep -q "$progress_pkg_redis"; then
    echo "Install redis-server...";
    apt install -y -q redis-server
    sleep 5
    echo $progress_set_redis_ip > $progress_file
    #systemctl status redis
    echo "Install redis-server... done";
    echo "";
fi

# add docker bridge ip to redis-server 
if cat $progress_file | grep -q "$progress_set_redis_ip"; then
    if [ -f $redisConfigFile ]; then
        echo "Set redis-server binding IP...";
        cp $redisConfigFile $redisConfigFileBak
        sed "s/^bind.*/& $dockerIpGateway/" $redisConfigFileBak > $redisConfigFile
        echo "Set redis-server binding IP... done";
        echo "";
    else
        echo "Set redis-server binding IP... Failed!  Unable to find file: $redisConfigFile";
        echo "";
        exit 1
    fi
    echo $progress_set_redis_service > $progress_file
fi

# set redis service start after docker.service
if cat $progress_file | grep -q "$progress_set_redis_service"; then
    if [ -f $redisServiceFile ]; then
        echo "Set redis-server.service delay start...";
        cp $redisServiceFile $redisServiceFileBak
        sed "s/^After=.*/& $dockerServiceName/" $redisServiceFileBak > $redisServiceFile
        echo "Set redis-server.service delay start... done";
        echo "";
    else
        echo "Set redis-server.service delay start... Failed!  Unable to find file: $redisServiceFile";
        echo "";
        exit 1
    fi
    echo $progress_pkg_docker > $progress_file
fi

# install docker offical 
if cat $progress_file | grep -q "$progress_pkg_docker"; then
    echo "Install docker...";
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
    sleep 5
    systemctl enable --now docker
    usermod -aG docker administrator
    # reboot system is required. 
    # reboot system 
    #echo $progress_set_docker_ip > $progress_file
    echo $progress_set_docker_service > $progress_file
    echo "Install docker... done";
    echo "";
    #echo "Please Reboot System, and restart this install script '$installScript01'."
    #exit 0
fi

if cat $progress_file | grep -q "$progress_set_docker_service"; then
    if [ -f $dockerServiceFile ]; then
        echo "Set docker.service delay start...";
        cp $dockerServiceFile $dockerServiceFileBak
        sed "s/^After=.*/& $mysqlServiceName/" $dockerServiceFileBak > $dockerServiceFile
        echo "Set docker.service delay start... done";
        echo "";
    else
        echo "Set docker.service delay start... Failed!  Unable to find file: $dockerServiceFile";
        echo "";
        exit 1
    fi
    echo $progress_set_docker_ip > $progress_file
fi

if cat $progress_file | grep -q "$progress_set_docker_ip"; then
    if ! [ $dockerIpRangeDefault == $dockerIpRange ]; then
        echo "Set Docker IP...";
        if [ ! -f $dockerDaemonJsonFile ]; then
            echo "{\"default-address-pools\": [{\"base\":\"$dockerIpRange/16\",\"size\":24}], \"log-driver\": \"json-file\", \"log-opts\": {\"max-size\": \"10m\", \"max-file\": \"10\"}}" > $dockerDaemonJsonFile;
        else
            if cat $dockerDaemonJsonFile | grep -q "default-address-pools" ; then
                echo "Please modify '$dockerDaemonJsonFile', update following item, and restart this install script '$installScript01'. ";
                echo "\"default-address-pools\":[{\"base\":\"$dockerIpRange/16\",\"size\":24}], \"log-driver\": \"json-file\", \"log-opts\": {\"max-size\": \"10m\", \"max-file\": \"10\"}";
                echo "";
                exit 1
            else
                tmpStr1=`sed '$ s/.$//' $dockerDaemonJsonFile`
                tmpStr2=", \"default-address-pools\":[{\"base\":\"$dockerIpRange/16\",\"size\":24}], \"log-driver\": \"json-file\", \"log-opts\": {\"max-size\": \"10m\", \"max-file\": \"10\"}}"
                echo $tmpStr1$tmpStr2 > $dockerDaemonJsonFile
            fi
        fi
    fi

    # reboot system is required. 
    # reboot system 
    echo $progress_pkg_nvm > $progress_file

    echo "";
    echo "Please Reboot System, and execute second install script '$installScript02' as local user \"administrator\".";
    echo "";
    exit 0
fi


# after reboot execute second install script.
echo "";
echo "After Reboot System, Execute second install script '$installScript02' as local user \"administrator\".";
echo "> ./$installScript02";
echo "";

exit 0

