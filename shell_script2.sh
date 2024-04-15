#!/bin/bash

# Input strings
input_strings=("info.nt.siva.devops" "info.nt.chinna.devops" "info.nt.sravya.devops" "info.nt.venkat.devops")

# Iterate over input strings
for input_string in "${input_strings[@]}"; do
#echo "the values are $input_string"
word=$(echo "$input_string" | awk -F '[.]' '{print $3}')
#echo " the word values are $word"
    #prev_value=""
    for i in "{$word[@]}";do
        echo "$word"

        # Compare the elements
        case $word" in 
            siva)
                if [["$word" == "chinna" | "$word" == "sravya" | "$word" == "venkat"];then
                    echo "$word"
                    echo " matched"
                else
                    echo " OK " ;;

            chinna)
                if [["$word" == "siva" | "$word" == "sravya" | "$word" == "venkat"];then
                    echo "$word"
                    echo " OK "
                else
                    echo "matched" ;;

            sravya)
                if [["$word" == "chinna" | "$word" == "siva" | "$word" == "venkat"];then
                    echo " OK "
                else
                    echo "matched" ;;


            venkat)
                if [["$word" == "chinna" | "$word" == "sravya" | "$word" == "siva"];then
                    echo " OK "
                else
                    echo "matched" ;;        

        esac
            
        #      | "sravya" | "chinna" | "venkat" 
        # # echo "the word is matched ;;
        # # *)
        # #     echo "the word is not matched"
        # #     ;;
        # # esac
        
        
        
        
        # if [[ "$word" == "$prev_value"  && "$word" == "$prev_value"  &&  "$word" == "$prev_value" ]];
        # then
        #     echo " the words are matched "
        #     exit 1
        
        # else
        #     echo ""
            
        #  fi
        #prev_value=$i
    done


done



