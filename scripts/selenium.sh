#!/bin/bash
# selenium.sh: Start Selenium up and also start headless screen.
#Xvfb needed: sudo apt-get install xvfb
# /etc/init.d/xvfb:
#  pids=$(pidof /usr/bin/Xvfb)
#  if [ -n "$pids" ]; then
#      echo "xvfb already running"
#  else
#      echo "xvfb: starting new"
#      Xvfb :99 -ac &
#  fi

export DISPLAY=:99
sh -e /etc/init.d/xvfb start
echo "xvfb ready"
sleep 2 
mkdir -p build/logs
java -jar vendor/netwing/selenium-server-standalone/selenium-server-standalone-2.43.0.jar > build/logs/selenium.log 2>&1 &
FF=`firefox --version`
echo "selenium running Firefox $FF" 
sleep 2
