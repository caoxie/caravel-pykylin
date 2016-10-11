#!/bin/bash
service sshd start &
/usr/sbin/sshd -D &
nohup gunicorn -w 16 --timeout 60 -b 0.0.0.0:8088 caravel:app >> /tmp/caravel.log 2>&1 &



