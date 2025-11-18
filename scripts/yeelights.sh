#!/bin/bash

set -xe

yeecli=/home/maxime/go/bin/yeelightcli

devices=(
  "192.168.1.249:55443" # Ceiling    
  "192.168.1.90:55443" # Pixar
  "192.168.1.94:55443"  # Screen bar 
  # "192.168.1.173:55443" # Salon      
  # "192.168.1.232:55443" # Thomas     
  # "192.168.1.85:55443"  # Couloir    
)

for device in "${devices[@]}"; do
  $yeecli power "$1" "$device"
done
