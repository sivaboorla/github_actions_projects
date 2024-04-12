#!/bin/bash

# Define the string containing values
string="info.nt.siva.devops,info.nt.chinna.devops,info.nt.sravya.devops"


# Extract the values using awk
siva=$(echo "$string" | awk -F '[,.]' '{print $3}')

chinna=$(echo "$string" | awk -F '[,.]' '{print $7}')

sravya=$(echo "$string" | awk -F '[,.]' '{print $11}')

# Print the extracted values
echo "The first person is: $siva"
echo "The second person is: $chinna"
echo "The third person is: $sravya"

# Compare if all three values are equal
if [ "$siva" = "$sravya" ] && [ "$siva" = "$chinna" ]; then
    echo "All three values are equal."
else
    echo "Not all three values are equal."
fi
