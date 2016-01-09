#1/usr/bin/shell
#projects to download

# Source the logger
source bash_logger.sh
source bash_logger.conf

#home user path
USER_HOME=$(eval echo ~${SUDO_USER})

#folder for soft
SOFT_DIR="soft_test"

#current script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## declare an array of Git repos
declare -a REPOS=("https://github.com/Dionach/CMSmap.git" \ #web vurn scanner
				  "https://github.com/sullo/nikto" \ #web vuln scanner
				  "https://github.com/HispaGatos/openvas_install.git" \ #openvas repo for install
				  "https://github.com/andresriancho/w3af.git" \ #web vuln scanner
				  "https://github.com/sqlmapproject/sqlmap.git" #sqli scanner
				  )

#Main environment for project deploy
declare -a REQ=("python2.7" "python2.7-dev" "libpq-dev" "git" "an")

check_sources(){
	#check that all needed source are exist
	#TODO
	#check req{2\3}.txt file exist
}
#check if module\package exists on system
check_apps(){
	# sudo apt-get update &> /dev/null
	INFO "apt-get update is DONE"
	for app in "${REQ[@]}";do
		res=`aptitude show ${app} | grep State`	
		
		case $res in
	    	"State: installed"|installed) INFO ${app} : ${res} ;;
	        *) INFO  " ${app} Not installed"
			sudo apt-get install --fix-broken --quiet --assume-yes ${app}
			sudo apt-get autoclean 			
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
	pip install  --upgrade -r "$SCRIPT_DIR/req2.txt"	
}
create_venv_py3(){
	cd $USER_HOME
	virtualenv --python=/usr/bin/python3 py3
	source ~/py_3/bin/activate
	pip install --upgrade pip
	pip install --upgrade setuptools
	pip install --upgrade wheel
	pip install -r "$SCRIPT_DIR/req3.txt"
}
#1. create $SOFT_DIR dir in current user root folder
init (){
	cd $USER_HOME
	INFO "Current user" -- `whoami`
	INFO "Current path" -- `pwd`
	INFO "System" -- `uname -a`
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
	for i in "${REPOS[@]}"; do
		#TODO check if repo is alive
		# status=$(curl -s --head -w %{http_code} $i -o /dev/null)
		# echo $status

		install_from_git $i
	done 	
}


###RUN SETUP###	
init
create_venv_py2
create_venv_py3

###########TODO make auto install these packages
#DIRB - URL Bruteforcer
#http://sourceforge.net/projects/dirb/files/dirb/2.22/dirb222.tar.gz/download
