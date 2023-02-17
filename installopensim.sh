#!/bin/bash
# has to be bash cause debconf-set-selections with <<< needs bash and not sh
#
divaname="diva-r09210" #"diva-r08210" #"diva-r09000" #"diva-r08210"
downloaddir="http://metaverseink.com/download/"
#
piuser="pi"
pathtologfile=/home/$piuser/installopensim.log
#
#
function_start () {
   echo "===starting $1"
   echo "===starting $1" >> $pathtologfile
   date
   date >> $pathtologfile
}
#
function_end () {
   echo "=======done $1"
   echo "=======done $1" >> $pathtologfile
   date
   date >> $pathtologfile
}
#
#
#
touch $pathtologfile
function_start "create a log file"
function_end "creating logfile"
#
#
function_start "update and upgrade"
   sudo apt-get update >> $pathtologfile
   sudo apt-get upgrade -y >> $pathtologfile
function_end "update and upgrade"
#
#
function_start "install libgdiplus and git-core"
   sudo apt-get install libgdiplus git-core -y >> $pathtologfile
function_end "install libgdiplus and git-core"
#
#
function_start "add keyserver mono"
   sudo apt-get install dirmngr -y >> $pathtologfile  #needed to add the keyserver..
   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF >> $pathtologfile
function_end "add keyserver mono"
#
#
function_start "add mono to apt source list"
   sudo echo "deb http://download.mono-project.com/repo/debian raspbianjessie main" | sudo tee /etc/apt/sources.list.d/mono-official.list >> $pathtologfile
function_end "add mono to apt source list"
#
#
function_start "update"
   sudo apt-get update >> $pathtologfile
function_end "update"
#
#
function_start "install mono-complete"
   sudo apt-get install mono-complete -y >> $pathtologfile
function_end "install mono-complete"
#
#
echo "---starting install unzip"
   sudo apt-get install unzip -y >> $pathtologfile
function_end "install unzip"
#
#
function_start "download and unzip diva"
   wget $downloaddir$divaname.zip >> $pathtologfile
   unzip $divaname.zip >> $pathtologfile
function_end "download and unzip diva"
#
#
function_start "creating Ode.NET.dll.config"
   cd  /home/$piuser/$divaname/bin/
   > Ode.NET.dll.config
   echo "<configuration>" | sudo tee -a  `pwd`/Ode.NET.dll.config
   echo "  <dllmap dll=\"ode\" target=\"lib32/libode.so\" />" | sudo tee -a  `pwd`/Ode.NET.dll.config
   echo "</configuration>" | sudo tee -a  `pwd`/Ode.NET.dll.config
   cd ../..
function_end "creating Ode.NET.dll.config"
#
#
function_start "install automake libtool gcc"
   sudo apt-get install automake libtool gcc -y >> $pathtologfile
function_end "install automake libtool gcc"
#
#
function_start "clone opensim-libs and autogen ODE"
   git clone git://opensimulator.org/git/opensim-libs
   cd /home/$piuser/opensim-libs/trunk/unmanaged/OpenDynamicsEngine-0.10.1
   cp ./autogen.sh ../OpenDynamicsEngine-0.13.1mod/autogen.sh
   cd ..
   cd OpenDynamicsEngine-0.13.1mod
   sudo chmod 777 autogen.sh
   sh autogen.sh >> $pathtologfile
   cd ../../../..
function_end "clone opensim-libs and autogen ODE"
#
#
function_start "configure ODE"
   cd /home/$piuser/opensim-libs/trunk/unmanaged/OpenDynamicsEngine-0.13.1mod
   ./configure --with-trimesh=opcode --disable-asserts --enable-shared --disable-demos --without-x --disable-threading-intf  >> $pathtologfile
   cd ../../../..
function_end "configure ODE"
#
#
function_start "make for ODE"
   cd /home/$piuser/opensim-libs/trunk/unmanaged/OpenDynamicsEngine-0.13.1mod
   make  >> $pathtologfile
   cd ../../../..
function_end "make for ODE"
#
#
function_start "copy files over for ODE"
   cd /home/$piuser/opensim-libs/trunk/unmanaged/OpenDynamicsEngine-0.13.1mod
   cp ./ode/src/.libs/libode.so.4.1.0 /home/$piuser/$divaname/bin/lib32/libode.so.4.1.0
   cp ./ode/src/.libs/libode.so.4 /home/$piuser/$divaname/bin/lib32/libode.so.4
   cp ./ode/src/.libs/libode.so /home/$piuser/$divaname/bin/lib32/libode.so
   cd ../../../..
function_end "copy files over for ODE"
#
#
function_start "clone libopenmetaverse"
   git clone git://github.com/openmetaversefoundation/libopenmetaverse.git libopenmetaverse
   cd /home/$piuser/libopenmetaverse/openjpeg-dotnet/
   sed -i 's:ARCHFLAGS=-m32:ARCHFLAGS=:g' Makefile
   cd ../..
function_end "clone libopenmetaverse"
#
#
function_start "make openjpeg"
   cd /home/$piuser/libopenmetaverse/openjpeg-dotnet/
   make >> $pathtologfile
   cd ../..
function_end "make openjpeg"
#
#
function_start "copy files over for openjpeg"
   cd /home/$piuser/libopenmetaverse/openjpeg-dotnet/
   cp -p libopenjpeg-dotnet-2-1.5.0-dotnet-1-i686.so /home/$piuser/$divaname/bin/lib32/libopenjpeg.so
   cd ../..
function_end "copy files over for openjpeg"
#
#
function_start "creating OpenMetaverse.dll.config"
   cd  /home/$piuser/$divaname/bin/
   > OpenMetaverse.dll.config
   echo "<configuration>" | sudo tee -a `pwd`/OpenMetaverse.dll.config
   echo "<dllmap dll=\"openjpeg-dotnet.dll\" target=\"lib32/libopenjpeg.so\" />" | sudo tee -a  `pwd`/OpenMetaverse.dll.config
   echo "</configuration>" | sudo tee -a `pwd`/OpenMetaverse.dll.config
   cd ../..
function_end "creating OpenMetaverse.dll.config"
#
#
function_start "install tmux"
   sudo apt-get install tmux -y >> $pathtologfile
function_end "install tmux"
#
#
#normally you would enable ODE physics in config-include/MyWorld.ini and not in OpenSim.ini.
#but it is not generated yet.
#So it is just a dirty workarround to allow the person that installs it to run as few commands as possible.
function_start "enable opendynamic-physics"
   cd  /home/$piuser/$divaname/bin/
   sed -i 's:; physics = OpenDynamicsEngine:physics = OpenDynamicsEngine:g' OpenSim.ini
   cd ../..
function_end "enable opendynamic-physics"
#
#
#normally you would disable index_sims in config-include/MyWorld.ini and not in DivaPreferences.ini.
#but it is not generated yet.
#So it is just a dirty workarround to allow the person that installs it to run as few commands as possible.
function_start "disabling index_sims"
   cd  /home/$piuser/$divaname/bin/config-include/
   sed -i 's:index_sims = true:index_sims = false:g' DivaPreferences.ini
   cd ../../..
function_end "disabling index_sims"
#
#
function_start "make pi owner of diva-folder"
   sudo chown -R pi:pi /home/$piuser/$divaname
function_end " make pi owner of diva-folder"
#
#
function_start "clone git RpiDivaDistroInstaller"
   su pi -l -c 'git clone https://github.com/freddii/RpiDivaDistroInstaller'
function_end "clone git RpiDivaDistroInstaller"
#
#
function_start "install mysql-server"
   sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password pi'
   sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pi'
   sudo apt-get -y install mysql-server >> $pathtologfile
function_end "install mysql-server"
#
#
function_start "creating a database"
   mysql -u root -ppi -e "create database opensim;use opensim;create user 'opensimuser'@'localhost' identified by 'opensimpass';grant all on opensim.* to 'opensimuser'@'localhost';"
function_end "creating a database"
#
#
function_start "install ufw"
   sudo apt-get install ufw -y >> $pathtologfile
function_end "install ufw"
#
#
function_start "setup and activate ufw"
   sudo ufw default deny
   # allow port 22 for ssh
   sudo ufw allow proto tcp from any to any port 22
   # deny connections from an IP address that has attempted to initiate 6 or more connections in the last 30 seconds
   sudo ufw limit proto tcp from any to any port 22
   # allow port 9000 tcp and udp for opensim
   sudo ufw allow 9000/tcp
   sudo ufw allow 9000/udp
   # enable ufw
   echo "y" | sudo ufw enable
function_end "setup and activate ufw"
#
#
function_start "install unattended-upgrades"
   sudo apt-get install unattended-upgrades -y >> $pathtologfile
function_end "install unattended-upgrades"
#
#
function_start "setup unattended-upgrades"
   sudo sed -i 's/^\/\/      "o=Raspbian,n=jessie"/      "o=Raspbian,n=jessie"/g' /etc/apt/apt.conf.d/50unattended-upgrades
   sudo sed -i 's/^\/\/Unattended-Upgrade::Remove-Unused-Dependencies "false";/Unattended-Upgrade::Remove-Unused-Dependencies "true";/g' /etc/apt/apt.conf.d/50unattended-upgrades
   #
   # You could also create this file by running "dpkg-reconfigure -plow unattended-upgrades"
   sudo tee /etc/apt/apt.conf.d/20auto-upgrades > /dev/null <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
   # you can test it with sudo unattended-upgrades --dry-run
   # read the logs with tail -n 4 /var/log/unattended-upgrades/unattended-upgrades.log
function_end "setup unattended-upgrades"
#
#
function_start "install fail2ban"
   sudo apt-get install fail2ban -y >> $pathtologfile
#   # Fail2Ban v0.8.13 had a bug to read more than one line for me ..
#   wget http://ftp.de.debian.org/debian/pool/main/f/fail2ban/fail2ban_0.9.6-1_all.deb >> $pathtologfile
#   sudo dpkg -i fail2ban_0.9.6-1_all.deb >> $pathtologfile
#   sudo apt-get install -f >> $pathtologfile
function_end "install fail2ban"
#
#
#function_start "setup fail2ban"
#   sudo cp /home/$piuser/RpiDivaDistroInstaller/opensim.conf /etc/fail2ban/filter.d/opensim.conf
#   sudo cp /home/$piuser/RpiDivaDistroInstaller/jail.local /etc/fail2ban/jail.local
#   sudo service fail2ban reload
#   # you can read the last 4 lines of fail2ban.log with: tail -4 /var/log/fail2ban.log
#   # or to read the last 4 lines of OpenSim.log: sudo nano /home/pi/diva-r08210/bin/OpenSim.log
#function_end "setup fail2ban"
#
#
function_start "clean up old sourcefiles"
   rm /home/$piuser/$divaname.zip
#   rm /home/$piuser/fail2ban_*.deb
   rm -r /home/$piuser/libopenmetaverse
   rm -r /home/$piuser/opensim-libs
   apt-get clean
function_end "clean up old sourcefiles"
#
#
echo "===INSTALLATION DONE===" >> $pathtologfile
echo "===INSTALLATION DONE==="
