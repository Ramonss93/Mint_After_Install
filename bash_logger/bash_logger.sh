#!/bin/bash

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Logging tool for BASH script
# Author            - Sudipta Ghorui <sudipta05@gmail.com>
# Version           - 1.2.010613
# Last modified     - 01-Jun-2013
# Copyright Info    - Copyright 2013-2014 Sudipta Ghorui
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# Default configuration
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

logLevel=DEBUG         
debugLogFile=script-debug.log
infoLogFile=script-info.log
errorLogFile=script-error.log
maxLogFileSize=10000
CYAN="\x1b[36;01m"
GREEN="\x1b[32;01m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
ENDCOLOR="\033[0m"
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function DEBUG() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   log "DEBUG" "`basename ${BASH_SOURCE[1]}`:${FUNCNAME[1]}:${BASH_LINENO[0]} - $@"
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function INFO() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    log "INFO" " - $@"
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function WARN() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    # log "WARN" " `basename ${BASH_SOURCE[1]}`:${FUNCNAME[1]}:${BASH_LINENO[0]} - $@"
    log "WARN" " `basename ${BASH_SOURCE[1]}`: - $@"
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function ERROR() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    log "ERROR" "`basename ${BASH_SOURCE[1]}`:${FUNCNAME[1]}:${BASH_LINENO[0]} - $@"
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function chk_log_file_size() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	[ -s $1 ] || (mkdir -p $(dirname $1) > /dev/null 2>&1 && touch $1)
	[ $(stat -c%s "$1") -gt $(($maxLogFileSize * 1024)) ] && rotate_log_file $1
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function rotate_log_file() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
    logFileToRotate=$1
    length=`expr length $logFileToRotate + 1`
    max=0
    for f in ${logFileToRotate}.[0-9]*; do 
        [ -f "$f" ] && num=${f:$length} && [ $num -gt $max ] && max=$num
    done

    for ((i=$max;i>0;i-=1)); do
        [ -f "$logFileToRotate.$i" ] && mv $logFileToRotate.$i "$logFileToRotate.`expr $i + 1`" > /dev/null 2>&1
    done
    mv $logFileToRotate "${logFileToRotate}.1" > /dev/null 2>&1 && touch $logFileToRotate
}

#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
function log() {
#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 	logFileList=$(echo "$debugLogFile")
	
    if [ $# -eq 2 ]; then
        case "${1}" in
            ERROR )
				logFileList=$(echo "$debugLogFile $infoLogFile $errorLogFile")
				chk_log_file_size $debugLogFile
				chk_log_file_size $infoLogFile
				chk_log_file_size $errorLogFile
                (echo -e $RED"$1 [`date +'%d-%b-%y %T'`] $2"$ENDCOLOR | tee -a $logFileList) || echo "$1 [`date +'%d-%b-%y %T'`] $2" | tee -a $logFileList >> /dev/null
                ;;
            WARN )
                logFileList=$(echo "$debugLogFile $infoLogFile $errorLogFile")
				chk_log_file_size $debugLogFile
				chk_log_file_size $infoLogFile
				chk_log_file_size $errorLogFile
                (echo -e $YELLOW"$1 [`date +'%d-%b-%y %T'`] $2"$ENDCOLOR | tee -a $logFileList) || echo "$1 [`date +'%d-%b-%y %T'`] $2" | tee -a $logFileList >> /dev/null
                ;;
            INFO )
				logFileList=$(echo "$debugLogFile $infoLogFile")
				chk_log_file_size $infoLogFile
				chk_log_file_size $errorLogFile
                (echo -e $GREEN"$1 [`date +'%d-%b-%y %T'`] $2"$ENDCOLOR | tee -a $logFileList) || echo "$1 [`date +'%d-%b-%y %T'`] $2" | tee -a $logFileList >> /dev/null
        
                ;;
            DEBUG )
                logFileList=$(echo "$debugLogFile")
 				chk_log_file_size $debugLogFile
				;;
            *)
				logFileList=$(echo "$debugLogFile")
 				chk_log_file_size $debugLogFile
				;;
        esac
        # ([ "$logLevel" = "STDOUT" ] && echo -e $GREEN"$1 [`date +'%d-%b-%y %T'`] $2"$ENDCOLOR | tee -a $logFileList) || echo "$1 [`date +'%d-%b-%y %T'`] $2" | tee -a $logFileList >> /dev/null
        
    
    else
        ([ "$logLevel" = "STDOUT" ] && echo "log [`date +'%d-%b-%y %T'`] $@" | tee -a $debugLogFile) || ([ "$logLevel" = "DEBUG" ] && echo -e $CYAN"DEBUG [`date +'%d-%b-%y %T'`] $@"$ENDCOLOR | tee -a $debugLogFile >> /dev/null)
 	fi
}
