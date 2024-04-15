#!/bin/bash

# Input strings
input_strings=("info.nt.siva.devops" "info.nt.chinna.devops" "info.nt.siva.devops" "info.nt.venkat.devops")

# Iterate over input strings
for input_string in "${input_strings[@]}"; do
    #echo "the values are $input_string"
    word=$(echo "$input_string" | awk -F '[.]' '{print $3}')
    #echo " the word values are $word"
    all_values=$word
    all_values=$(($word+$all_values))


    echo "$all_values"

    if [[ "$word" == "$word" ]];then
        echo " word matched"
    else
        echo "not matched
    fi
        
    
    
done