# RpiDivaDistroInstaller
simple setup for opensim (opensimulator) diva distro on a raspberrypi (raspberry pi 2)  

# based on:
https://fredfire1.wordpress.com/2015/11/30/opensimulator-server-on-rpi2-raspberrypi/  
https://fredfire1.wordpress.com/2014/07/20/opensim-raspberrypi/  
http://www.s-config.com/opensimraspberry-pi-rasbian-hard-float-works/  
http://opensimulator.org/wiki/Wifi  
http://metaverseink.com/Downloads.html  
http://www.metaverseink.com/blog/diva-addons/wifi-and-other-diva-addons/  
https://www.youtube.com/watch?v=Fo0Cvh6Rs5s  
https://www.youtube.com/watch?v=ug-EhuKGp-4  
https://hyperweb.eu/Ubuntu_16.04/Autostart  
https://hyperweb.eu/OpenSim_0.8/AutostartTmux  
http://www.hypergridbusiness.com/2014/04/its-easy-to-fix-your-diva-grids-website/  


# If you like to install it also reachable from the internet click the following link:  
[Setup diva distro with Dynamic DNS (more complicated)](Dynamic_DNS_Setup.md)  

if you like to install it only reachable from your local lan you can keep following this instruction.  


# Usage:  
~~download ```http://downloads.raspberrypi.org/raspbian_lite_latest```~~  
download  
http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-07-05/2017-07-05-raspbian-jessie-lite.zip  
unzip it and burn raspbian-lite on a sd-card  

enable ssh on raspbian-lite  
log into your raspbian-lite then run in terminal:  
```
wget https://raw.githubusercontent.com/freddii/RpiDivaDistroInstaller/master/installopensim.sh && chmod u+x installopensim.sh && sudo ./installopensim.sh
```
took ~40min

simply copy the code with "Ctrl + C" in browser and then paste it with "Ctrl + Shift + V" in terminal  

the installer will look stuck sometimes for 10 minutes, cause i am redirecting most of the things it says into the logfile installopensim.log.  
if you like to see some detailed progress have a look at that file in another terminal. ( ```tail installopensim.log``` )  


# Security!!!IMPORTANT!!!
change the default password for user pi:
```
passwd
```

change the mysql password for opensimuser:
```
mysql -u root -p"pi"
SET PASSWORD FOR 'opensimuser'@'localhost' = PASSWORD('HERE_YOUR_NEW_PASSWORD_FOR_OPENSIMUSER');
quit
```

change mysql root password:
```
mysqladmin -u root -p'pi' password
```
then enter your new password for root
```
exit #to logout of console
```

login into console again then shred the logs:
```
shred -n 1 -z -u -v ~/.mysql_history
shred -n 1 -z -u -v ~/.bash_history
```


# Setup diva distro:
```
cd ~/diva-r*/bin && mono Configure.exe
```
4.0.30319.42000
Name of your world: My Opensim Server  
MySql database host: [localhost]  
MySql database schema name: [opensim]  
MySql database user account: [opensim] opensimuser  
MySql database password for that account: HERE_YOUR_NEW_PASSWORD_FOR_OPENSIMUSER  
Your external domain name (preferred) or IP address:192.168.1.x   
This installation is going to run on  
 [1] .NET/Windows  
 [2] *ix/Mono  
Choose 1 or 2 [1]: 2  

The next questions are for configuring Wifi,  
the web application where your users can register.  

Wifi Admin first name [Wifi]:Your_Wifi_USER_FIRSTNAME  
Wifi Admin last name [Admin]:Your_Wifi_USER_LASTNAME  
Wifi Admin password [secret]: YOUR_SECRECT_PASSWORD_FOR_YOUR_WIFI_ADMIN  
Wifi Admin email [admin@localhost]:  
User account creation [o]pen or [c]ontrolled [c]: o  
Wifi sends email notifications via gmail, by default.  
Gmail user name [none]:  
Gmail password [none]:  

Your regions have been successfully configured.  
Your World has been successfully configured  

***************************************************
Your world is My Opensim Server  
Your loginuri is http://192.168.1.x:9000  
Your Wifi app is http://192.168.1.x:9000/wifi  
You admin account for Wifi is:  
  username: Your_Wifi_USER_FIRSTNAME Your_Wifi_USER_LASTNAME  
  passwd:   YOUR_SECRECT_PASSWORD_FOR_WIFI_ADMIN  

Your world's configuration is config-include/MyWorld.ini.  
Please revise it.  
***************************************************

<Press enter to exit>


# First start of OpenSim:
```
cd ~/diva-r*/bin && mono OpenSim.exe
```


Estate owner first name [Test]:YOUR_AVATAR_FIRSTNAME  
Estate owner last name [User]: YOUR_AVATAR_LASTNAME 
Password: YOUR_SPECIAL_PASSWORD  
..  

14:27:08 - [ESTATE]: Region My Opensim Server is not part of an estate.  
14:27:08 - [ESTATE]: No existing estates found.  You must create a new one.  
New estate name [My Estate]: Server Estate  

you can have a look at the webinterface in your browser:  
```
http://192.168.1.x:9000/wifi
```
![Alt text](https://github.com/freddii/RpiDivaDistroInstaller/blob/master/diva_distro_wifi.png?raw=true "Title")

if you like to close the console in the ssh session:  
```
shutdown  
```

# Make diva distro autostart (it will be autostarted 2min after the pi is booted):
```
cd ~/RpiDivaDistroInstaller && sudo ./installautostart.sh && cd .. && sudo reboot
```

# Login with firestorm:  
top left on Viewer > Preferences > Opensim > Grid Manager > Add new grid  
then write in the white field your grid address you used before.  
for example:  
```
http://192.168.1.x:9000/
```
then click "Apply" behind it then "OK" at the bottom  

Now enter your username password and choose as "log into grid" your new grid and press "login".  
