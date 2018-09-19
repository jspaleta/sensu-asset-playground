#!/bin/bash

mkdir -p ./build/bin
mkdir -p ./build/lib

scripts=( "metrics-nagios.sh" )

for script in "${scripts[@]}"; do
  echo "shell-scripts/${script}"
  cp -n "shell-scripts/${script}" build/bin
done

commands=( "duh" "mpstat" "bash" "iostat" "df" "awk" "free" )
all_libs=()
for c in "${commands[@]}"; do
  full_path=`which $c`
  if [ ! -z $full_path ] ; then
    echo $c $full_path
    libs=`ldd $full_path | grep "=> /" | awk '{print $3}'`
    all_libs+=( "${libs[@]}" )
    cp -n $full_path build/bin/
  fi
done
sorted_unique_libs=($(echo "${all_libs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

for l in "${sorted_unique_libs[@]}"; do
  cp -n $l build/lib/
done
saved_libs=( $(ls -1 build/lib/ | sort -u) )

echo ${#saved_libs[@]}  ${#sorted_unique_libs[@]}

all_libs=()
for lib in "${saved_libs[@]}"; do
  full_path="build/lib/${lib}"
  if [ ! -z $full_path ] ; then
    echo $lib $full_path
    libs=`ldd $full_path | grep "=> /" | awk '{print $3}'`
    all_libs+=( "${libs[@]}" )
    cp -n $full_path build/bin/
  fi
done
sorted_unique_libs=($(echo "${all_libs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
new_saved_libs=( $(ls -1 build/lib/ | sort -u) )
echo ${#saved_libs[@]}  ${#new_saved_libs[@]}

if (( ${#new_saved_libs[@]} <= ${#saved_libs[@]} )) ; then
  echo "no new libs"
  process="false"
else
  echo "new libs added re-run build.sh to make sure deps are added" 
fi

