#!/bin/bash

all_repos="./repos.txt"

for repo in $(cat $all_repos)
do
    repo_folder=$(echo "$repo" | awk -F '[/.]' '{print $6}')
    echo "The repo folder is $repo_folder "
    env:
        USERNAME: ${{ secrets.USERNAME }}
        PASSWORD: ${{ secrets.PASSWORD }}
    git clone -b master $repo
    cd $repo_folder
    rm -rf src
    git add .
    git commit -m "src folder deletion"

    git push origin master
done
