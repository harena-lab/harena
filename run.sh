#!/bin/bash

sudo apt-get install -y wget docker-compose git 

root_folder=$(pwd)

harena_module_link() 
{
	echo "------------------------------------Link $1-----------------------------------"

	echo "Creating module folder"
	mkdir $root_folder/modules/$1 -p 

	echo "Retrieving docker-compose file"
	wget  -P $root_folder/modules/$1 https://raw.githubusercontent.com/datasci4health/$1/$2/docker-compose.yml --quiet --no-cache  

}


harena_module_unlink() 
{
	echo "------------------------------------Unlink $1-----------------------------------"

	echo "Removing module folder"
	rm    $root_folder/modules/$1 -r -f

}


harena_module_up() 
{
	echo "------------------------------------Up $1-------------------------------------"

	echo "Starting docker-compose"
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name "harena" up   -d  
}


harena_module_down() 
{
	echo "------------------------------------Down $1-----------------------------------"

	echo "Trying to stop docker-compose"
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name "harena" down 

}


harena_module_exec() 
{
	echo "------------------------------------Exec $1-----------------------------------"

	echo "Executing command"
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name "harena" exec $2 $3 
}


harena_module_run() 
{
	echo "------------------------------------Run $1------------------------------------"

	echo "Executing command"
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name "harena" run $2 $3 
}


harena_module_ps() 
{
	sudo  docker-compose --file $root_folder/modules/$1/docker-compose.yml --project-name "harena" ps 
	echo 
}


harena_module_start() 
{
	harena_module_unlink $1 $2
	harena_module_link   $1 $2
	harena_module_down   $1 $2
	harena_module_up     $1 $2
}



#                    module           branch/tag
harena_module_start "harena-space"   "master"  
harena_module_start "harena-manager" "master"
harena_module_start "harena-logger"  "master"


echo "Waiting before running initialization commands via docker exec ..."
sleep 10

#                  module           service          command
harena_module_exec  "harena-manager" "harena-manager" "adonis migration:run --force"
harena_module_exec  "harena-manager" "harena-manager" "adonis seed          --force"

echo "Done. Listing all containers:"
sudo docker ps -a