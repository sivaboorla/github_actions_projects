#!/bin/bash

# Input values
values="info.nt.siva.dev,info.nt.siva.dev,info.nt.siva.dev"

# Split the values by comma
IFS=',' read -r -a elements <<< "$values"
#echo " the elements are $elements"

# Extract the third element from each value
third_elements=()
for element in "${elements[@]}"; do
    IFS='.' read -r -a parts <<< "$element"
    third_elements+=("${parts[2]}")
    echo "$third_elements"
done

# Compare the third elements
if [ "${third_elements[0]}" = "${third_elements[1]}" ] && [ "${third_elements[1]}" = "${third_elements[2]}" ]; then
    echo "All third elements are equal: ${third_elements[0]}"
else
    echo "Third elements are not equal"
fi
