#!/bin/bash
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

# ------------------------------------------------------ 
## 
# Charger Management Standard  
# Program Installation. 
# For Ubuntu 20.04 LTS. 
# 02. Install nvm packages for local user. 
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
funcChkIsNotSudo $installScript02


## 
# initial or check progress file.
funcChkNotStartInstallation

funcChkDoneInstall

# check install config for missing values. 
funcChkInstallConfigFileValues n


## 
# get user entered value back from config file. 
funcReadInstallConfigValueFromFile


# install nvm 
if cat $progress_file | grep -q "$progress_pkg_nvm"; then
    if ! command -v nvm | grep -q nvm; then
        echo "Install nvm...";
        #curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        #echo "Execute following command, and restart second install script '$installScript02'.";
        #echo "> curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash";
        echo $progress_chk_pkg_nvm > $progress_file
        # reopen console terminal. 
        echo "";
        echo "After install 'nvm', Please Logout first, then Login, Open New Console Terminal, ";
        echo "and restart second install script '$installScript02' as local user \"administrator\".";
        echo "> ./$installScript02";
        echo "";
        exit 0
    else
        #echo $progress_chk_pkg_nvm > $progress_file
        # reopen console terminal. 
        echo "";
        echo "Please Logout first, then Login, Open New Console Terminal, ";
        echo "and restart second install script '$installScript02' as local user \"administrator\".";
        echo "> ./$installScript02";
        echo "";
        exit 1
    fi
fi

if cat $progress_file | grep -q "$progress_chk_pkg_nvm"; then
    if command -v nvm | grep -q nvm; then
        echo $progress_pkg_nodejs > $progress_file
        cp $progress_file $progress_file_previous
    else
        progress_flag_error=1
        #echo $progress_chk_pkg_nvm > $progress_file
        echo "";
        echo "Install user package 'nvm' failed.  Check if use new console or other errors.";
        echo "";
        exit 1
    fi
fi

# install nodejs
if cat $progress_file | grep -q "$progress_pkg_nodejs"; then
    if ! node --version | grep -q "$progress_chk_pkg_nodejs_ver"; then
        echo "Install nodejs...";
        #apt update
        #nvm install node 12.21.0
        nvm install 12.21.0
        # it should instal npm automaticly.
        #apt install -y -q npm
        echo $progress_chk_pkg_nodejs > $progress_file
    fi
fi

if cat $progress_file | grep -q "$progress_chk_pkg_nodejs"; then
    if node --version | grep -q "$progress_chk_pkg_nodejs_ver"; then
        echo $progress_pkg_pm2 > $progress_file
    else
        progress_flag_error=1
        #echo $progress_chk_pkg_nodejs > $progress_file
        echo "";
        echo "Install user package 'nodejs' failed.  Check if use new console or other errors.";
        echo "";
        exit 1
    fi
fi

# install pm2
if cat $progress_file | grep -q "$progress_pkg_pm2"; then
    echo "Install pm2...";
    npm install pm2 -g
    echo $progress_install_evcore > $progress_file
    echo "";
    echo "Please Logout first, then Login, Open New Console Terminal, ";
    echo "and start third install script '$installScript03' as local user \"administrator\".";
    echo "";
    exit 0
fi


# execute third install script.
echo "";
echo "Execute third install script '$installScript03' as local user \"administrator\".";
echo "> ./$installScript03";
echo "";

exit 0

