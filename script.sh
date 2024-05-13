#!/bin/bash

all_repos="./repos.txt"

for repo in $(cat $all_repos)
do
    repo_folder=$(echo "$repo" | awk -F '[/.]' '{print $6}')
    echo "The repo folder is $repo_folder "
    USERNAME="sivaboorla" 
    CLONE_URL=$(https://$USERNAME:$PAT_TOKEN@repo)
    echo "$CLONE_URL"
    # git clone -b master $CLONE_URL
    # cd $repo_folder
    # rm -rf src
    # git add .
    # git commit -m "src folder deletion"
    # git push origin master
done
