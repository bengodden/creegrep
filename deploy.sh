#!/usr/bin/env sh
# abort on errors
set -e
# build
npm run build
# navigate into the build output directory
cd dist/
# if you are deploying to a custom domain
echo 'BENGODDEN.COM' > CNAME
git add dist -f
git commit -m "deploy+$(date +%Y-%m-%d)"
git subtree push --prefix dist origin gh-pages
# if you are deploying to https://<USERNAME>.github.io
# git push git@github.com:bengodden/bengodden.github.io.git main
# if you are deploying to https://<USERNAME>.github.io/<REPO>
# git push -f git@github.com:<USERNAME>/<REPO>.git main:gh-pages
cd ..