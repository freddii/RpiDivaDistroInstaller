#!/bin/bash
#based on https://hyperweb.eu/Ubuntu_16.04/Autostart
#https://hyperweb.eu/OpenSim_0.8/AutostartTmux
echo "start copy files over"
sudo cp `pwd`/opensim-autostart.sh /etc/systemd/system/opensim-autostart.sh
sudo cp `pwd`/opensim-autostart.service /etc/systemd/system/opensim-autostart.service
sudo systemctl enable opensim-autostart.service
sudo cp `pwd`/autostart.sh ../autostart.sh
echo "done copy files over"
echo "rebooting computer..(opensim will start 2 minutes after each reboot)"
