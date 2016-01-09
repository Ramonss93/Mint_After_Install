#sudo apt-get update && sudo apt-get remove openjdk*
#tar -zxvf jdk-8u51-linux-x64.tar.gz 
sudo mkdir -p /opt/java
sudo mv jdk1.8.0_51 /opt/java
sudo update-alternatives --install "/usr/bin/java" "java" "/opt/java/jdk1.8.0_51/bin/java" 1
sudo update-alternatives --set java /opt/java/jdk1.8.0_51/bin/java
ln -s /opt/java/jdk1.8.0_51/jre/lib/amd64/libnpjp2.so ~/.mozzila/plugins/	 