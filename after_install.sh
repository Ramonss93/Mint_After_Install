#!/bin/bash
#projects to download

# Source the logger
source ./bash_logger/bash_logger.sh
source ./bash_logger/bash_logger.conf

#home user path
declare -r  USER_HOME=$(eval echo ~${SUDO_USER})

#folder for soft
declare -r  SOFT_DIR="soft"

#current script dir
declare -r  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#resources folder
declare -r  SOURCE_DIR="$SCRIPT_DIR/sources"

## declare an array of Git repos
declare -a REPOS=("https://github.com/Dionach/CMSmap.git"
				  "https://github.com/sullo/nikto"
				  "https://github.com/HispaGatos/openvas_install.git"
				  "https://github.com/andresriancho/w3af.git"
				  "https://github.com/sqlmapproject/sqlmap.git"
				  )

#Main environment for project deploy
declare -a REQ=(
    "python2.7"
    "python2.7-dev"
    "python-setuptools"
    "libpq-dev"
    "git"
    "an"
    "p7zip-rar"
    "p7zip-full"
    "libffi-dev"
    "python-numpy"
    "python-scipy"
    "python-matplotlib"
    "ipython"
    "ipython-notebook"
    "python-pandas"
    "python-sympy"
    "python-nose"
    "guake"
    "mc"
    "wget"

 )

#TODO make function to put programm into startup
# to make a delay set this
# 	[Desktop Entry]
# Encoding=UTF-8
# Name=mintUpdate
# Comment=Linux Mint Update Manager
# Icon=stock_lock
# Exec=mintupdate-launcher
# Terminal=false
# Type=Application
# Categories=
# X-GNOME-Autostart-Delay=20
# X-MATE-Autostart-Delay=20

startup_app(){
	sudo ln -s /usr/share/applications/guake.desktop /etc/xdg/autostart/


}
# check_sources(){
	#check that all needed source are exist
	#TODO
	#check req{2\3}.txt file exist
# }

#check if module\package exists on system
check_apps(){
	sudo apt update -qq
	WARN "apt-get update is DONE"
	for app in "${REQ[@]}";do
		res=`aptitude show ${app} | grep State`	
		
		case $res in
	    	"State: installed"|installed) INFO "${app} : ${res}" ;;
	        *) INFO  " ${app} Not installed"
			sudo apt install --fix-broken --quiet --assume-yes ${app}
			sudo apt autoclean 			
	        ;;        	
	    esac
	done;	
}

install_apps(){
	sudo aptitude -v --show-why --assume-yes install python=2.7 python-dev=2.7 \
	python-setuptools libpq-dev git
	sudo easy_install --upgrade pip
	sudo pip install virtualenv fabric fabtools
}

##clone or update repo
install_from_git(){
	pushd . > /dev/null 
	filepath=$(basename $1)
	# extension="${filename##*.}"
	repo_name="${filepath%.*}"
	if [ ! -d "$USER_HOME/$SOFT_DIR/$repo_name"  ]; then
		# Control will enter here if $DIRECTORY doesn't exist.
		git clone $1 
		INFO "$repo_name -- SETUP IS DONE"
		popd > /dev/null
	else
		cd $repo_name && update_repo $repo_name
		popd > /dev/null
	fi
}


##update Git repo (u need to run it inside Git folder)
update_repo(){
	#TODO make args
	if [[ `git status --porcelain` ]];  then
    	git pull
    	INFO "$1 : Git update is done"
	else
    	INFO "$1 : no changes"
	fi

}
	
create_venv_py2(){
	cd $USER_HOME
	virtualenv  --python=/usr/bin/python2 py2
	source ~/py2/bin/activate
	pip install --upgrade pip
	pip install --upgrade setuptools
	pip install --upgrade wheel
	pip install  --upgrade -r "$SOURCE_DIR/req2.txt"	
}
create_venv_py3(){
	cd $USER_HOME
	virtualenv --python=/usr/bin/python3 py3
	source ~/py_3/bin/activate
	pip install --upgrade pip
	pip install --upgrade setuptools
	pip install --upgrade wheel
	pip install -r "$SOURCE_DIR/req3.txt"
}

postgres_setup(){
	WARN "Instaling postgrSQL 9.5"
	declare -r  PG_REPO="/etc/apt/sources.list.d/postgresql.list"
	sudo touch $PG_REPO
	sudo chmod a+wrx $PG_REPO
	echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main 9.5" > $PG_REPO 
	if [ -f /etc/apt/sources.list.d/postgresql.list ] ; then WARN " File $PG_REPO is created"; fi
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	apt-get update -qq
	apt-get install --fix-broken  --assume-yes postgresql-9.5  postgresql-server-dev-9.5 postgresql-9.5-slony1 postgresql-9.5-postgis-2.2 pgadmin3
	sudo service postgresql restart
	#CHECK how to create user and other 
	# http://www.codeproject.com/Articles/898303/Installing-and-Configuring-PostgreSQL-on-Linux-Min
	# http://stackoverflow.com/questions/1471571/how-to-configure-postgresql-for-the-first-time
	# sudo -u postgres createdb mytestdb
	WARN "Instaling postgrSQL 9.5 done!"
}
#1. create $SOFT_DIR dir in current user root folder
init (){
	cd $USER_HOME
	WARN "====================START SYSTEM INIT============================="
	INFO "Current user: `whoami`"
	INFO "Current path: `pwd`"
	INFO "System `uname -a`"
	check_apps #check dependencies

	if [ ! -d "$USER_HOME/$SOFT_DIR" ]; then
		# Control will enter here if $DIRECTORY doesn't exist.
		INFO "Folder $SOFT_DIR not exists -- creating folder..."
		mkdir $SOFT_DIR
		cd $SOFT_DIR	
	else
		INFO "Folder $SOFT_DIR  exists -- go in..."
		cd $SOFT_DIR
	fi
	#clone repos
	}

instal_repos(){
	cd $SOFT_DIR
	for i in "${REPOS[@]}"; do
		#TODO check if repo is alive
		WARN $i
		status=$(curl -s --head -w %{http_code} $i -o /dev/null)
		echo $status
		git clone $i
		# install_from_git $i
	done 	

}

###RUN SETUP###	
instal_repos
# postgres_setup
# init
# create_venv_py2
# create_venv_py2y3
###########TODO make auto install these packages
#DIRB - URL Bruteforcer
#http://sourceforge.net/projects/dirb/files/dirb/2.22/dirb222.tar.gz/download
