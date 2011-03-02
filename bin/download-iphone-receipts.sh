#!/bin/zsh

if [[ $# -ne 4 ]]; then
    echo "usage: $0 ip directory start_file_number end_file_number"
    exit 1
fi

ip=$1
directory=$2
start=$3
end=$4

for i in {$start..$end}; do
    curl -o ${directory}/${i}.jpg "http://${ip}/${directory}/${i}.jpg"
done

