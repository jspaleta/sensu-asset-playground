#!/bin/bash

mkdir -p ./build/bin
mkdir -p ./build/lib

array=( "duh" "mpstat" "bash" "iostat" "df" "awk" "free" )
all_libs=()
for c in "${array[@]}"; do
  full_path=`which $c`
  if [ ! -z $full_path ] ; then
    echo $c $full_path
    libs=`ldd $full_path | grep "=> /" | awk '{print $3}'`
    all_libs+=( "${libs[@]}" )
    cp -n $full_path build/bin/
  fi
done

for l in "${all_libs[@]}"; do
  cp -n $l build/lib/
done

# ldd $(which mpstat)  | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /
