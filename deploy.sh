#!/usr/bin/env sh
# abort on errors
set -e
# build
npm run build
# navigate into the build output directory
cp docs/index.html docs/404.html
# if you are deploying to a custom domain
echo 'BENGODDEN.COM' > docs/CNAME
git add -A
git commit -m "deploy+$(date +%Y-%m-%d)"
git push
echo "Deploy Successful"