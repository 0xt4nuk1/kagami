#!/bin/sh

set -e

# Required environment variables
: "${MIRROR_GIT_USERNAME?The env variable MIRROR_GIT_USERNAME is required.}"
: "${MIRROR_GIT_EMAIL?The env variable MIRROR_GIT_EMAIL is required.}"
: "${MIRROR_GIT_TOKEN?The env variable MIRROR_GIT_TOKEN is required.}"
: "${MIRROR_GIT_HOSTNAME?The env variable MIRROR_GIT_HOSTNAME is required.}"
: "${MIRROR_GIT_PROJECT?The env variable MIRROR_GIT_PROJECT is required.}"

# Add the /github/workspace directory to the list of safe directories in Git
sh -c "git config --global --add safe.directory /github/workspace"

# Configure Git
git config --global user.name  "${MIRROR_GIT_USERNAME}"
git config --global user.email "${MIRROR_GIT_EMAIL}"

# Setup credentials cache (default cache timeout is 15 minutes)
git config --global credential.helper cache

# Manually insert credentials into cache
echo "https://${MIRROR_GIT_USERNAME}:${MIRROR_GIT_TOKEN}@${MIRROR_GIT_HOSTNAME}" | git credential approve

# Checkout the current branch
git checkout "$GITHUB_REF_NAME"

# Add Mirror Git remote
git remote add mirror_git "https://${MIRROR_GIT_HOSTNAME}/${MIRROR_GIT_USERNAME}/${MIRROR_GIT_PROJECT}.git"

# Push everything to Mirror Git remote
git push --force mirror_git

# Cleanup credentials from cache
echo "url=https://${MIRROR_GIT_HOSTNAME}" | git credential reject
