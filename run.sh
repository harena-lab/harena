#!/bin/bash

sudo apt-get install -y wget docker-compose git 

root_folder=$(pwd)

sudo docker-compose --file $root_folder/docker-compose.yml --project-name harena up -d 

start_harena_module() 
{
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name $1 down -d 
	rm    $root_folder/modules/$1 -r
	mkdir $root_folder/modules/$1 -p && cd $root_folder/modules/$1
	wget  https://raw.githubusercontent.com/datasci4health/$1/$2/docker-compose.yml
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name $1 up   -d 
}



start_harena_module "harena-manager" "v0.0.1"
start_harena_module "harena-logger"  "v0.0.4"
start_harena_module "harena-space"   "v0.0.1"
