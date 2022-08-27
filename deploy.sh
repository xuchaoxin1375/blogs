#! /bin/bash
# # please edit (modify) the file in the dev environment only (or write the deploy.sh and commit & push the branch at once!otherwise,the modification would be lost!
# # for the initial webhook to work,please manually run`git pull origin main_or_otherBranch`,to get the deploy.sh available in the remote end
# # 使用某些路径符号`~`会导致报错,比如:cd ~/backEnd/
cd /home/cxxu/backEnd/
#git status
git reset --hard origin/main
git log |tail -n 10
#git pull origin/main
git status|head -n 10
echo '----brute force pull done!(by reset to the remote origin/main)'
 
# ll ~
