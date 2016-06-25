#!/bin/bash
function huff() {
  (
    date
    echo
    ruby a.rb 2>&1 ?>&1 
  )> a
  clear
  cat a 
}

huff
while sleep 2; do 
  huff &
done
