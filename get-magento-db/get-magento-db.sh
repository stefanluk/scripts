#!/bin/bash

cyan='\033[0;36m'
clear='\033[0m'
yellow='\033[0;33m'

step=1

# # ask project name
read -p "$(echo $cyan"Project name: "$clear)" PROJECT_NAME

# ask reference hypernode
read -p "$(echo $cyan"Reference hypernode: "$clear)" REFERENCE_HYPERNODE

# change dir into directory
echo $yellow"Step $step: cd ~/Sites/$PROJECT_NAME"$clear
((step++))
cd "~/Sites/$PROJECT_NAME"

# ssh into reference hypernode to get DB dump
echo $yellow"Step $step: get database from $REFERENCE_HYPERNODE"$clear
((step++))
ssh app@"$REFERENCE_HYPERNODE" <<< '
    cd ~/project/current
    magerun2 db:dump remote.sql --strip="@development"
    gzip remote.sql
    exit
'

# scp to copy DB dump
scp app@"$REFERENCE_HYPERNODE":~/project/current/remote.sql.gz ./remote.sql.gz

# ssh into reference hypernode to remove DB dump
ssh app@"$REFERENCE_HYPERNODE" <<< '
    cd ~/project/current
    rm remote.sql.gz
    exit
'

# import database
echo $yellow"Step $step: importing database "$PROJECT_NAME""$clear
((step++))
# unzip DB dump
gunzip remote.sql.gz
# import DB with mysql
mysql -uroot -proot "$PROJECT_NAME" < ./remote.sql

osascript -e 'display notification "New DB imported succesfully!" with title "'$PROJECT_NAME'"'   