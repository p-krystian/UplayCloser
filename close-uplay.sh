#!/bin/bash

if [ -z "$1" ]; then
  echo "[CLOSE UPLAY] No command given!"
  exit
fi

exec "$@" &
for PTH in "$@"; do :; done
CMD=($(basename "$PTH"))
GAME=${CMD[0]}

on_run(){
  while true; do
    if [ $((`pgrep -f "$1" | wc -l`)) -lt $2 ]; then
      echo "[CLOSE UPLAY] Closing Uplay in 3 secs"
      sleep 3
      kill -SIGTERM $(pgrep -f 'upc.exe')
      exit
    fi
#     echo "[CLOSE UPLAY] Waiting for game exit..."
    sleep 10
  done
}

for i in {1..5}; do
  echo "[CLOSE UPLAY] Waiting for game startup... $i/5"
  sleep 60
  if [ $((`pgrep -f "$GAME" | wc -l`)) -gt 2 ]; then
    echo "[CLOSE UPLAY] Game starting..."
    sleep 45
    PROCESSES=($(pgrep -f "$GAME" | wc -l))
    echo "[CLOSE UPLAY] Game started; Processes: $PROCESSES"
    on_run $GAME $PROCESSES
  fi
done
