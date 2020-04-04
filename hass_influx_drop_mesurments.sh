#!/bin/bash

host=localhost
db='homeassistant'
measurements=$1

measurements=($(influx --host $host --execute 'show measurements' --database=$db | grep "$1"))

if (( ${#measurements[@]} ))
then

    echo "Found following measurements: "
    echo

    for m in ${measurements[*]}
    do
        echo " - $m"
    done

    echo
    read -p "Are you sure you want to drop these from database? (y/N)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        for m in ${measurements[*]}
        do
            echo "Dropping $m..."
            influx --host $host --database=$db --execute "drop measurement \"$m\";"
        done
    else
        echo "OK, leaving it alone..."
    fi

else
    echo "Did not found any measurements matching your query. Exiting."
fi
