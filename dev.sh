#!/bin/bash
while sleep 2; do 
  (
    date
    echo
    ruby a.rb 2>&1 ?>&1 
  )> a
  clear
  cat a 
done
