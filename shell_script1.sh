#!/bin/bash

# Define the string containing values
string="info.nt.siva.devops,info.nt.chinna.dev,info.nt.sravya.developer"


# Extract the values using awk
siva=$(echo "$string" | awk -F '[,.]' '{print $3}')

chinna=$(echo "$string" | awk -F '[,.]' '{print $7}')

sravya=$(echo "$string" | awk -F '[,.]' '{print $11}')

# Print the extracted values
echo "The first person is: $siva"
echo "The second person is: $chinna"
echo "The third person is: $sravya"

# Compare if all three values are equal
if [ "$siva" = "$sravya" ] || [ "$siva" = "$chinna" ]; then
    echo "All these values or some values are matched."
else
    echo " all these values are not equal."
fi
