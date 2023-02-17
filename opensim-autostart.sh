#!/bin/sh
#
# /etc/systemd/system/opensim-autostart.sh

case $1 in
  start)
    #bash /root/firewall.sh
    su pi -l -c 'bash autostart.sh' &
    ;;
  stop)
    ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
    ;;
esac
