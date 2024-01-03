#!/bin/bash

if [ -z "$1" ]; then
  echo "[CLOSE UPLAY] No command error!"
  exit
fi

exec "$@" &
for PTH in "$@"; do :; done
CMD=($(basename "$PTH"))
GAME=${CMD[0]}

on_run(){
  while true; do
    if [ $((`pgrep -f "$1" | wc -l`)) -lt 4 ]; then
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
  if [ $((`pgrep -f "$GAME" | wc -l`)) -gt 3 ]; then
    echo "[CLOSE UPLAY] Game started."
    on_run $GAME
  fi
done
