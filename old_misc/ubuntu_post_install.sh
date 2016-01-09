
sudo apt-get update && sudo apt-get upgrade
# 2. Мультимедиа и кодеки
sudo apt-get install ubuntu-restricted-extras
# 3. Удалить коммерческие объективы
sudo apt-get remove unity-lens-shopping
# 4. ubuntu-tweak
sudo add-apt-repository ppa:tualatrix/next 
sudo apt-get update 
sudo apt-get install ubuntu-tweak 
# 4.2 Редактор dconf
sudo apt-get install dconf-tools
# 4.3 Unsettings
cd /tmp
wget https://launchpad.net/~diesch/+archive/testing/+files/unsettings_0.08ubuntu1_all.deb
sudo dpkg -i unsettings*
# 5. autostart
sudo -i
cd /etc/xdg/autostart/
sudo sed --in-place 's/NoDisplay=true/NoDisplay=false/g' *.desktop
#5.2 Установка Preload.
sudo apt-get install preload
# 6. swap
sudo sed -i 's/\(vm.swappiness=\)[[:digit:]]*$/\112/g' /etc/sysctl.conf
# 7. scrollbars 
gsettings set com.canonical.desktop.interface scrollbar-mode normal
# 8. icons 
sudo add-apt-repository ppa:tiheum/equinox && sudo apt-get update
sudo apt-get install faenza-icon-theme faience-icon-theme

# PACKAGES

#skype
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get update
sudo apt-get install skype && sudo apt-get -f install

# java
sudo apt-get purge openjdk*
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer

#misc
sudo apt-get install p7zip-rar p7zip-full synaptic classicmenu-indicator

#DEV
sudo apt-get install libssl-dev libxml2 libxml2-dev libxslt-dev libmemcached-dev build-essential libfreetype6-dev libpng-dev libcurl4-gnutls-dev 

#PYTHON
sudo apt-get install python-dev
sudo apt-get install build-essential
sudo apt-get install libfreetype6-dev libpng-dev python-virtualenv python-matplotlib
pip install cssselect pycurl
#SYSTEM
#bumblebee
# sudo add-apt-repository ppa:bumblebee/stable
# sudo add-apt-repository ppa:ubuntu-x-swat/x-updates
# sudo apt-get update
#To install Bumblebee using the proprietary nvidia driver:
# sudo apt-get install bumblebee bumblebee-nvidia linux-headers-generic
# echo 'Reboot or re-login!'

#tlp
# sudo add-apt-repository ppa:linrunner/tlp && sudo apt-get update && sudo apt-get install tlp tlp-rdw


 "Downloading GetDeb and PlayDeb" &&
wget http://archive.getdeb.net/install_deb/getdeb-repository_0.1-1~getdeb1_all.deb http://archive.getdeb.net/install_deb/playdeb_0.3-1~getdeb1_all.deb &&

echo "Installing GetDeb" &&
sudo dpkg -i getdeb-repository_0.1-1~getdeb1_all.deb &&

echo "Installing PlayDeb" &&
sudo dpkg -i playdeb_0.3-1~getdeb1_all.deb &&

echo "Deleting Downloads" &&
rm -f getdeb-repository_0.1-1~getdeb1_all.deb &&
rm -f playdeb_0.3-1~getdeb1_all.deb

