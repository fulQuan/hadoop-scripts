#!/usr/bin/env bash

# https://github.com/user501254/BD_STTP_2016
#
# InstallPig.sh
# Bash Script for rudimentary Pig Installation
#
# To run:
#  open terminal,
#  change directory to this script's location,
#    $ cd <link to InstallPig.sh parent directory>
#  give execute permission to the script,
#    $ sudo chmod +x InstallPig.sh
#  then execute the script,
#    $ ./InstallPig.sh
#
#
# Copyright (C) 2016 Ashesh Kumar Singh <user501254@gmail.com>
#
# This script may be modified and distributed under the terms
# of the MIT license. See the LICENSE file for details.
#


# Make sure that the script is not being run as root
if [[ "$EUID" -eq 0 ]]; then
  echo -e "\e[31m
  You are running this script as root which can cause problems.
  Please run this script as a normal user. See script file.\n
  Exiting.
  \e[0m"
  exit
else
  echo -e "\e[34m
  This will install the latest version of Pig on your system.\n
  Make sure that you have the following before continuing:
    - working internet connection (optional)
        for downloading installation files if
        not found in the parent directory 
        ie. $PWD
    - fairly up to date system
    - enough free disk space
  I recommend that you also go through the script file once.
  \e[0m"
  while true
  do
    read -r -p 'Do you wish to continue (yes/no)?' choice
    case "$choice" in
      [Nn]* ) echo 'Exiting.'; exit;;
      [Yy]* ) echo ''; break;;
      * ) echo 'Response not valid, try again.';;
    esac
  done
fi

set -eu
set -o pipefail



clear
echo -e "\e[32mDownloading and Extracting Pig archive\e[0m"
echo -e "\e[32m######################################\n\e[0m"
sleep 2s

FILE=$(wget "http://www.eu.apache.org/dist/pig/latest/" -O - | grep -Po "pig-[0-9].[0-9]{2}.[0-9].tar.gz" | head -n 1)
URL=http://www.eu.apache.org/dist/pig/latest/$FILE

if [[ ! -f "$FILE" ]]; then
  echo -e "\e[34mDownloading file \`$FILE'; this may take time.\e[0m"
  wget -c "$URL" -O "$FILE"
  DEL_FILE=true
else
  echo -e "\e[34mFile \`$FILE' already there; not retrieving.\e[0m"
  wget -c "$URL.md5" -O - | md5sum -c
  DEL_FILE=false
fi

echo -e "\e[34mExtracting file \`$FILE'; this may take a few minute.\e[0m"
sudo tar xfz "$FILE" -C /usr/local

if [[ "$DEL_FILE" == "true" ]]; then
  echo -e "\e[34mDeleting file \`$FILE'; to save storage space.\e[0m"
  rm -rf "$FILE"
fi

sudo mv /usr/local/pig-*/ /usr/local/pig
CURRENT=$USER
sudo chown -R "$CURRENT":"$CURRENT" /usr/local/pig
ls -las /usr/local

sleep 1s
echo -e "\n\n"


set -x
echo -e "\e[34mAdding Global Variables to ~/.bashrc file.\e[0m"
cat << 'EOT' >> ~/.bashrc
#PIG VARIABLES START
export PIG_HOME=/usr/local/pig
export PATH=$PATH:$PIG_HOME/bin
#PIG VARIABLES END
EOT
source ~/.bashrc || true
set +x



clear
echo -e "\e[32m
Pig installation was successful!
Open a new terminal and execute:
  $ pig -help
\e[0m"



#echo -e "Show Pig help\n"
#/usr/local/pig/bin/pig -help
