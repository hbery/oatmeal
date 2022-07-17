#!/bin/sh

NUM=$(xrandr --listmonitors | awk '{print $4}' | grep -c .)
 
if [ "$NUM" -gt 1 ]; then
   CMD=$(xrandr --listmonitors | awk '{print $4}' | grep .)
   cnt=0
   for disp in $CMD
   do
      if [ $cnt -gt 0 ]; then
         echo "$disp"
      fi
      cnt=$(( cnt + 1 ))
   done
fi

