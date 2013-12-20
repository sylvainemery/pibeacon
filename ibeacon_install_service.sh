#! /bin/bash
# check root permissions
if [[ $UID != 0 ]]; then
  echo "Please start the script as root or sudo!"
  exit 1
fi


sed "s:/home/pi/iBeacon:$(dirname $(readlink -f $0)):" > /etc/init.d/ibeacon << "EOF"
#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH

DESC="iBeacon Application Software"
PIDFILE=/var/run/ibeacon.pid
SCRIPTNAME=/etc/init.d/ibeacon

case "$1" in
  start)
    printf "%-50s" "Starting ibeacon..."
    cd /home/pi/iBeacon
    ./ibeacon_start
    ;;
  stop)
    printf "%-50s" "Stopping ibeacon..."
    cd /home/pi/iBeacon
    ./ibeacon_stop
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac
EOF

chmod +x /etc/init.d/ibeacon

update-rc.d -f ibeacon start 80 2 3 4 5 . stop 30 0 1 6 .

