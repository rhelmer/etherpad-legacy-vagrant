#!/bin/bash

as_etherpad() {
    cmds="cd /home/etherpad/src/pad && $*"
    sudo su -  etherpad -c "$cmds"
    exit_code=$?
    if [ $exit_code != 0 ]
    then
      echo "ERROR: exit code was: $exit_code for commands: $cmds"
      exit 1
    fi
}

as_etherpad "./bin/build.sh"
as_etherpad "cd ./etherpad && source ../bin/exports.sh && ./bin/rebuildjar.sh"
as_etherpad "./bin/run.sh" &

sleep 60

Xvfb :0 &
export DISPLAY=:0
python etherpad_selenium.py
