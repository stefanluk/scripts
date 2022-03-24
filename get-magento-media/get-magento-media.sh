#!/bin/bash

cyan='\033[0;36m'
clear='\033[0m'


# ask php version
# read -p "$(echo $cyan"Php version: "$clear)" PHP_VERSION

# # ask project name
read -p "$(echo $cyan"Project name: "$clear)" PROJECT_NAME

# ask reference hypernode
read -p "$(echo $cyan"Reference hypernode: "$clear)" REFERENCE_HYPERNODE

# change dir into directory
cd "~/Sites/$PROJECT_NAME"

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

# extract into pub
unzip -o ./media.zip -d ./pub

# remove media.zip
rm ./media.zip

osascript -e 'display notification "Images import succesful!" with title "'$PROJECT_NAME'"'   