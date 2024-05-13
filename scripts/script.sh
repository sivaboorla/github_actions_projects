!/bin/bash


echo "Hello world"  

all_repos="./repos.txt"

for repo in $(cat $all_repos)
do
    repo_folder=$(echo "$repo" | awk -F '[/.]' '{print $6}')
    echo "The repo folder is $repo_folder "
    USERNAME="sivaboorla"
    git config --global user.email "siva.2@yahoo.com
    git config --global user.name "sivaboorla"
    GH_TOKEN=$PASSWORD
    git config credentials.helper 'store --file ~/.git-credentials' 
    echo "https://$GH_TOKEN:x-0auth-basic">~/git-credentials
    git clone -b main $repo
    CLONE_URL=$(https://$USERNAME:$PAT_TOKEN@repo)
    echo "$CLONE_URL"
    git clone -b master $CLONE_URL
    cd $repo_folder
    rm -rf src
    git add .
    git commit -m "src folder deletion" .
    git push origin master
done
