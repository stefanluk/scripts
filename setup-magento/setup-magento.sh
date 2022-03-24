#!/bin/bash

cyan='\033[0;36m'
clear='\033[0m'
yellow='\033[0;33m'

step=1

# ask php version
# read -p "$(echo $cyan"Php version: "$clear)" PHP_VERSION

# # ask project name
read -p "$(echo $cyan"Project name: "$clear)" PROJECT_NAME

# ask git repository location
read -p "$(echo $cyan"Git clone URL: "$clear)" REPOSITORY_LOCATION

# ask git branch
read -p "$(echo $cyan"Git branch: "$clear)" REPOSITORY_BRANCH

# ask reference hypernode
read -p "$(echo $cyan"Reference hypernode: "$clear)" REFERENCE_HYPERNODE

# ask for clients repository project name
read -p "$(echo $cyan"Clients repo project name: "$clear)" CLIENTS_REPO_PROJECT_NAME 

# ask if media needs to be transfered
read -p "$(echo $cyan"Transfer media? (y/n):"$clear)" TRANSFER_MEDIA

# # check if php version machtes
# if $PHP_VERSION != php --version | tail -r | tail -n 1 | cut -d " " -f 2 | cut -c 1-3 
# 	# switch to given php version
# 	valet use $PHP_VERSION
# end

# change dir into ~/Sites 
echo $yellow"Starting setup..."
echo "Step $step: cd ~/Sites"
((step++))
cd ~/Sites

# create directory
echo "Step $step: mkdir $PROJECT_NAME"
((step++))
mkdir "$PROJECT_NAME"

# change dir into directory
echo "Step $step: cd $PROJECT_NAME"
((step++))
cd "$PROJECT_NAME"

# valet link directory
echo "Step $step: valet link"$clear
((step++))
valet link

# enable https
echo $yellow"Step $step: valet secure"$clear
((step++))
valet secure

# clone repository
echo $yellow"Step $step: git clone repository ."$clear
((step++))
git clone --single-branch --branch "$REPOSITORY_BRANCH" "$REPOSITORY_LOCATION" .
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git config --get remote.origin.fetch
git fetch --all

# create auth.json
echo $yellow"Step $step: fetching auth.json"$clear
((step++))
curl --header "PRIVATE-TOKEN: $FISH_GITLAB_TOKEN" "https://gitlab.frmwrk.nl/api/v4/projects/160/repository/files/$CLIENTS_REPO_PROJECT_NAME%2fauth.json/raw?ref=master" -o ./auth.json

# # composer install
echo $yellow"Step $step: composer install"$clear
((step++))
composer install --ignore-platform-reqs

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

# valet create db
echo $yellow"Step $step: valet db create "$PROJECT_NAME""$clear
((step++))
valet db create "$PROJECT_NAME"

# import database
echo $yellow"Step $step: importing database "$PROJECT_NAME""$clear
((step++))
# unzip DB dump
gunzip remote.sql.gz
# import DB with mysql
mysql -uroot -proot "$PROJECT_NAME" < ./remote.sql

# transfer media
case $TRANSFER_MEDIA in
	y)

		echo $yellow"Step $step: get media from $REFERENCE_HYPERNODE"$clear
		((step++))
		# ssh into environment and dump media
		ssh app@"$REFERENCE_HYPERNODE" <<< '
			cd ~/project/current
			ls -lah
			magerun2 media:dump --strip media.zip
			exit
		'

		# scp copy media dump
		scp app@"$REFERENCE_HYPERNODE":~/project/current/media.zip ./media.zip

		# ssh remove media dump
		ssh app@"$REFERENCE_HYPERNODE" <<< '
			cd ~/project/current
			rm ./media.zip
			exit
		'

		echo $yellow"Step $step: extract media locally"$clear
		((step++))
		# extract into pub
		unzip -o ./media.zip -d ./pub

		# remove media.zip
		rm ./media.zip
	;;
esac

# # create env.php
cp ~/Scripts/setup-magento/env.php ./app/etc/env.php
sed -i .tmpl "s/PROJECT_NAME/'$PROJECT_NAME'/g" ./app/etc/env.php 

# yarn install
echo $yellow"Step $step: yarn install"$clear
((step++))
yarn install

# set deploy mode
echo $yellow"Step $step: bin/magento dep:mode:set developer"$clear
((step++))
bin/magento dep:mode:set developer

# setup:upgrade
echo $yellow"Step $step: bin/magento setup:upgrade"$clear
((step++))
bin/magento setup:upgrade

# setup:di:compile
echo $yellow"Step $step: bin/magento setup:di:compile"$clear
((step++))
bin/magento setup:di:compile

# cache:flush
echo $yellow"Step $step: bin/magento cache:flush"$clear
((step++))
bin/magento cache:flush

# create admin user
echo $yellow"Step $step: create admin user slu"$clear
((step++))
bin/magento admin:user:create --admin-user="slu" --admin-password="Abcd1234#" --admin-email="s.luk@frmwrk.nl" --admin-firstname="Slu" --admin-lastname="Slu"

osascript -e 'display notification "environment setup successful!" with title "'$PROJECT_NAME'"'   