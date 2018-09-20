#!/bin/bash

mkdir -p ./build/bin
mkdir -p ./build/lib

##
# Populate by hand
# scripts:  the shell scripts to include into the assets as executables
# commands: the commands shell scripts use internally that also beed to be included
##
scripts=( "metrics-nagios.sh" )
commands=( "duh" "mpstat" "bash" "iostat" "df" "awk" "free" )


##
# Automagically scripting below.
##

# copy shell scripts into asset bin/
for script in "${scripts[@]}"; do
  echo "shell-scripts/${script}"
  cp -n "shell-scripts/${script}" build/bin
done

# copy commands into asset bin/
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

# copy libraries commands depend on in asset lib/
for l in "${sorted_unique_libs[@]}"; do
  cp -n $l build/lib/
done
saved_libs=( $(ls -1 build/lib/ | sort -u) )

echo ${#saved_libs[@]}  ${#sorted_unique_libs[@]}

# check for nested library deps and copy into assest lib/
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
  build_asset=true
  echo "no new libs build_asset: $build_asset"
else
  build_asset=false
  echo "new libs added build_asset: $build_asset\n Re-run script again to check for nested library deps." 
fi

if [ "$build_asset" = true ] ; then
  echo "building asset tarball"
  cd build/
  name="asset.linux.$(uname -i).tar.gz"
  tar cvzf $name bin/ lib/ include/
fi


