#!/bin/bash

all_repos="./repos.txt"

for repo in $(cat $all_repos)
do
    repo_folder=$(echo "$repo" | awk -F '[/.]' '{print $5}')
    echo "The repo folder is $repo_folder "

    git clone -b master $repo
    cd $repo_folder
    rm -rf src
    git add .
    git commit -m "src folder deletion"

    git push origin master
done
