#!/bin/bash -e
### BEGIN INIT INFO
# Provides:          drs-seeder
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# X-Interactive:     true
# Short-Description: Start/stop drs-seeder as a daemon
### END INIT INFO

# To start the script automatically at bootup type the following command
# update-rc.d drs-seeder defaults

USER=drs
NAME=drs-seeder
WORKINGDIR="/opt/drs/drs-seeder/"
DAEMON="/opt/drs/drs-seeder/dnsseed"
LOGFILE="/var/log/drs-seeder.log"
PIDFILE="/var/run/drs-seeder.pid"

HOST=dns0.rupee.sh
NS=vps.rupee.sh
PORT=5353
MBOX=clipper@rupee.sh 

ARGS="-h $HOST -n $NS -p $PORT -m $MBOX"

. /lib/lsb/init-functions

case $1 in
 start)
  #display to user that what is being started
  log_daemon_msg "Starting drs-seeder"
  #start the process and record record it's pid
  start-stop-daemon --start --background --chdir "$WORKINGDIR" --pidfile "$PIDFILE" --make-pidfile --startas /bin/bash --user $USER --chuid $USER -- -c "exec $DAEMON $ARGS >>$LOGFILE 2>&1"
  #output failure or success
  #info on how to interact with the torrent
  RET=$?
  if [[ $RET -eq 0 ]]; then
   log_success_msg "The process started successfully"
  else
   log_failure_msg "The process failed to start"
  fi
  exit $RET
 ;;

 status)
    status_of_proc -p $PIDFILE $DAEMON $NAME
 ;;

 stop)
  #display that we are stopping the process
  log_daemon_msg "Stopping drs-seeder"
  #stop the process using pid from start()
  start-stop-daemon --stop --pidfile "$PIDFILE" --user $USER --retry 30
  #output success or failure
  RET=$?
  if [[ $RET -eq 0 ]]; then
   log_success_msg "The process stopped successfully"
  else
   log_failure_msg "The process failed to stop"
  fi
  exit $RET
 ;;

 restart)
    "$0" stop && "$0" start;
 ;;

 *)
  # show the options
   echo "Usage: {start|stop|restart}"
;;
esac