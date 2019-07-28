#!/usr/bin/env bash

#!/bin/bash

startme() {
    kubectl run -i --tty load-generator --image=busybox /bin/sh
}

stopme() {
    pkill -f "load-generator"
}

case "$1" in
    start)   startme ;;
    stop)    stopme ;;
    restart) stopme; startme ;;
    *) echo "usage: $0 start|stop" >&2
       exit 1
       ;;
esac