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

# ssh into environment and dump media
echo $yellow"Step $step: get media from $REFERENCE_HYPERNODE"$clear
((step++))
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

osascript -e 'display notification "Images import succesful!" with title "'$PROJECT_NAME'"'   
