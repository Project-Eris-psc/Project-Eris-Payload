#!/bin/sh

if [ ! -e "/lib/modules" ]; then
  mount -o remount,rw /
  mkdir "/lib/modules"
  sync
  mount -o remount,ro /
fi
