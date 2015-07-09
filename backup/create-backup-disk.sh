#!/bin/bash

size=$1
disk_name=$(hostname).sparsebundle
path="$2"
if [[ -z "$path" ]]; then
  path="."
fi

hdiutil create -size $size -layout SPUD -fs HFS+ -volname backup -type SPARSEBUNDLE $path/$disk_name

