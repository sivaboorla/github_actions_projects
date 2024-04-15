#!/bin/bash

# Input strings
input_strings=("info.nt.siva.devops" "info.nt.chinna.devops" "info.nt.sravya.devops" "info.nt.venkat.devops")

# Iterate over input strings
for input_string in "${input_strings[@]}"; do
    # Extract name using parameter expansion
    name="${input_string#info.nt.}"
    name="${name%.devops}"

    # Print the extracted name
    echo "Extracted name: $name"
    if [ "$name" = "$sravya" ] && [ "$name" = "$chinna" ]; then
    	echo "All three values are equal."
    else
	    echo " All Values are not equal:"
	fi

done

#!/bin/bash

# Initialize the previous value
prev_value=""

# Loop through numbers 1 to 5
for i in {1..5}; do
    # Compare current value with previous value
    if [ "$prev_value" != "" ]; then
        if [ $i -gt $prev_value ]; then
            echo "$i is greater than $prev_value"
        elif [ $i -lt $prev_value ]; then
            echo "$i is less than $prev_value"
        else
            echo "$i is equal to $prev_value"
        fi
    fi

    # Update the previous value
    prev_value=$i
done

