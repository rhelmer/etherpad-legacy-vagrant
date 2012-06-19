#!/bin/bash

sudo su - etherpad -c "cd /home/etherpad/src/pad && ./bin/run.sh" &

sleep 30

Xvfb :0 &
export DISPLAY=:0
virtualenv .virtualenv
source .virtualenv/bin/activate
pip install selenium
python etherpad_selenium.py
