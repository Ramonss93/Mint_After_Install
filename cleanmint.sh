#!/bin/bash
 
 # clean system
 # https://community.linuxmint.com/tutorial/view/373
 # Source the logger
source ./bash_logger/bash_logger.sh
source ./bash_logger/bash_logger.conf

OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)
 
if [ $USER != root ]; then
  ERROR "Error: must be root"
  WARN "Exiting..."
  exit 0
fi
 
INFO "Cleaning apt cache..."
aptitude clean
 
INFO "Removing old config files..."
sudo aptitude purge $OLDCONF
 
INFO "Removing old kernels..."
sudo aptitude purge $OLDKERNELS
 
INFO "Emptying every trashes..."
rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
rm -rf /root/.local/share/Trash/*/** &> /dev/null
 
WARN "Script Finished!"