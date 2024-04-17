#!/bin/bash

# Input strings
input_strings=("info.nt.siva.devops" "info.nt.chinna.devops" "info.nt.siva.devops" "info.nt.venkat.devops")

# Iterate over input strings
for input_string in "${input_strings[@]}"; do
    #echo "the values are $input_string"
    word=$(echo "$input_string" | awk -F '[.]' '{print $3}')
    #echo " the word values are $word"
    declare -a input_array+=(" $word") # Declare and initialize the array with the first input value
    #input_array+=$word # Add the input value to the array

    echo " the values are ${input_array[*]}"
    array_value=${#input_array[*]}
    echo " the array value is $array_value "
    
done

for word in "${input_array[@]}"; do
    echo "the word is $word"
    #echo "the values are $input_string"
    #word=$(echo "$input_string" | awk -F '[.]' '{print $3}')
    count=0
    for compared_word in "${input_array[@]}"; do
        echo " the compared word is $compared_word"
        
        if [[ "$compared_word" == "$word" ]]; then
            count=$(( $count+1 ))
            echo "$count"
        fi
    done
    if [ $count -gt 1 ]; then
        echo "The name $word entered more than one entry"
    else
        echo "$word is ok"
    fi
done
#IFS='' read -r -a words <<< "${input_array[*]}"
#echo "$words"
# for ((i=0;i<${#words[*]};i++)); do
#     word="${words[$i]}"
#     echo " the word is $word"
#     count=0
#     #Compare the word with rest of words
#     for ((j=0;j<${#words[*]};j++)); do
#         echo "${words[j]}"
#         if [["${words[j]}" == "$word"]]; then
#             count=$((count+1))
#         fi
#     done

#done    
