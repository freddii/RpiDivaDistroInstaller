#!/bin/sh
# wechsele ins OpenSim bin Verzeichnis
cd /home/pi/diva-r08210/bin  #diva-r08210  #diva-r09000
while :
do
# Erststart: warte bis alles hochgefahren ist – später: vermeide häufiges Triggern
sleep 120
# versuche Aufruf und ignoriere den Fehler, wenn es bereits läuft
running=`ps ax | grep OpenSim.exe | grep -v grep`
if [ -z "$running" ]
  then
    tmux new-session -d -s term -n OpenSim 'env LANG=C mono OpenSim.exe -console=rest'
  else
    tmux new-window -n OpenSim -t term:0 'env LANG=C mono OpenSim.exe -console=rest' 2> /dev/null
#    tmux new-session -d -s term -n OpenSim 'env LANG=C mono OpenSim.exe'
#  else
#    tmux new-window -n OpenSim -t term:0 'env LANG=C mono OpenSim.exe' 2> /dev/null
fi
done
