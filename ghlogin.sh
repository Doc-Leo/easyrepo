#!/bin/bash

GITHUB_TOKEN="---PASTE---TOKEN---HERE"

PROJECT_NAME="---YOUR--PROJECT---"
REPO_PATH="----REPOSITORY--PATH--"
CLONE_PATH="$REPO_PATH/PROJECTNAME"


if gh auth status &> /dev/null; then
    echo " Already logged into GitHub."
else
    echo " Logging in to GitHub using embedded token..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token
fi

echo " Checking project directory: $CLONE_PATH"


if [ -d "$CLONE_PATH/.git" ]; then
    cd "$CLONE_PATH" || exit
    echo " Repository found. Navigated to: $CLONE_PATH"
else
    if [ -d "$CLONE_PATH" ]; then
        echo " The directory exists but is not a Git repository."
        read -p " Do you want to remove it and clone again? (y/N): " REPLY
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -rf "$CLONE_PATH"
        else
            echo " Aborting. No changes made."
            exit 1
        fi
    fi

    read -p " Enter the GitHub repository link to clone: " REPO_LINK
    if [[ -n "$REPO_LINK" ]]; then
        gh repo clone "$REPO_LINK" "$CLONE_PATH"
        cd "$CLONE_PATH" || exit
        echo " Repository cloned and navigated to: $CLONE_PATH"
    else
        echo " No repository link provided. Exiting."
        exit 1
    fi
fi

gh status
ls 

