#!/bin/bash
trap 'sudo kill $(jobs -p); sudo killall -u etherpad java' EXIT

if [ -f etherpad.log ]
then
  rm etherpad.log
fi
sudo su - etherpad -c "cd /home/etherpad/src/pad && ./bin/run.sh" 2>&1 | tee etherpad.log &

while true
do
  grep 'HTTP server listening' etherpad.log
  if [ $? == 0 ]
  then
    break
  else
    sleep 5
  fi
done

Xvfb :0 &
export DISPLAY=:0
virtualenv .virtualenv
source .virtualenv/bin/activate
pip install selenium
python /vagrant/puppet/files/etherpad_selenium.py
