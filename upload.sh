#!/bin/bash

# stops on docusaurus build error
set -e  

BUILD_DIR="build"
REMOTE_USER="root"
REMOTE_HOST="173.249.2.119"
REMOTE_PATH="/var/www/patterns.notmuch.space/"

npx docusaurus build
rsync -az --delete "$BUILD_DIR/" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"

open raycast://confetti
echo "Deployment successful!"