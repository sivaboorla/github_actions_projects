#!/bin/bash

# Input strings
input_strings=("info.nt.siva.devops" "info.nt.chinna.devops" "info.nt.sravya.devops" "info.nt.venkat.devops")

# Iterate over input strings
for input_string in "${input_strings[@]}"; do
    #Extracting the value from the input_strings
    #echo "the values are $input_string"

    #Extracting the value from separated variable
    word=$(echo "$input_string" | awk -F '[.]' '{print $3}')
    #echo " the word values are $word"

    declare -a input_array+=(" $word") # Declare and initialize the array with the first input value
    #echo " the values are ${input_array[*]}"
    
    #Print Number of values in  array
    Number_of_arrays=${#input_array[*]}
    #echo " the array value is $Number_of_arrays"
    
done

for name in "${input_array[@]}"; do
    echo "the name is $word"
    count=0
    for compared_name in "${input_array[@]}"; do
        echo " the compared word is $compared_name"
        
        if [[ "$compared_name" == "$name" ]]; then
            count=$(( $count+1 ))
            echo "$count"
        fi
    done
    if [ $count -gt 1 ]; then
        echo "The name $word entered more than one entry"
    else
        echo "$name  is entered $count time only"
    fi
done
