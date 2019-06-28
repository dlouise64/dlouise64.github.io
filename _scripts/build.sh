#!/bin/bash

# Enable error reporting to the console.
set -e

# NPM install if needed.
. $HOME/.nvm/nvm.sh && nvm install 6.1 && nvm use 6.1
npm install

# Build the site.
gulp build

# Checkout `master` and remove everything.
git clone https://${GH_TOKEN}@github.com/dlouise64/dlouise64.github.io.git ../dlouise64.github.io.master
cd ../dlouise64.github.io.master
git checkout master
rm -rf *

# Copy generated HTML site from source branch in original repository.
# Now the `master` branch will contain only the contents of the _site directory.
cp -R ../dlouise64.github.io/_site/* .

# Make sure we have the updated .travis.yml file so tests won't run on master.
cp ../dlouise64.github.io/.travis.yml .
git config user.name "dlouise64"

# Commit and push generated content to `master` branch.
git status
git add -A .
git status
git commit -a -m "Build: #$TRAVIS_BUILD_NUMBER"
git push --quiet origin `master` > /dev/null 2>&1