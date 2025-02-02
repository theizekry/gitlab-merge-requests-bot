#!/bin/bash
# GitLab Merge Request Script
# Author: Islam Zekry
# GitHub: https://github.com/theizekry
# Description: This script automates the creation of Merge Requests on GitLab for one or more targets branches by simple one hit.
# Version: 1.0
# Release Date: 01-2025
# ----------------------------------------------------------------


# Some Colors for outputs.
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print & log errors
error() {
  local exit_on_error=${2:-true}  # Default: true (exit)
  echo
  echo -e "${RED}❗️ Error: $1${NC}"
  echo "$(date) - $1" >> "$HOME/gitlab_pr.log"
  
  if [[ "$exit_on_error" == "true" ]]; then
    exit 1
  fi
}

success() {
  local exit_after_echo=${2:-false}  # Default: false (continue)
  echo
  echo -e "${GREEN}$1${NC}"

  if [[ "$exit_after_echo" == "true" ]]; then
    exit 1
  fi
}

warning() {
  echo
  echo -e "${YELLOW}$1${NC}"
}

# Check if DEFAULT_TARGET_BRANCHES is set in the environment
if [[ -n "$DEFAULT_TARGET_BRANCHES" ]]; then
  IFS=' ' read -r -a DEFAULT_TARGET_BRANCHES <<< "$DEFAULT_TARGET_BRANCHES"
else
  DEFAULT_TARGET_BRANCHES=("master" "develop" "uat")
fi


# Function to display help message
show_help() {
  echo "Usage: $(basename "$0") [TARGET_BRANCHES...]"
  echo
  echo -e "${GREEN}Creates GitLab Merge Requests from the current branch to specified target branches.${NC}"
  echo
  echo "Prerequisites:"
  echo -e "${YELLOW} - A valid GitLab Personal Access Token with API & Write access${NC} For more details about access token visit https://shorturl.at/QEbyn."
  echo "  - Set the environment variables before running the script:"
  echo "    export GITLAB_TOKEN='your_token_here'"
  echo
  echo "Arguments:"
  echo "  TARGET_BRANCHES    (Optional) List of target branches for the Merge Request."
  echo "                     If not provided, the default branches will be used: ${DEFAULT_TARGET_BRANCHES[*]}"
  echo
  echo "Options:"
  echo "  -h, --help         Show this help message and exit."
  echo
  echo "Examples:"
  echo "  $(basename "$0")                 # Uses default target branches (test, uat, beta)"
  echo "  $(basename "$0") develop master  # Creates PRs only for 'develop' and 'master'"
  echo
  echo "About:"
  echo "  Author: Islam Zekry"
  echo "  GitHub: https://github.com/theizekry"
  echo "  Description: This script automates the creation of Merge Requests on GitLab for one or more targets branches by simple one hit."
  echo "  Version: 1.0.0"
  echo "  Release Date: 01-2025"
  echo
  exit 0
}

# Check if help flag is passed
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
fi

# Check Current version
if [[ "$1" == "-v" || "$1" == "--version" ]]; then
  success "GitPR Version 1.0.0" true
fi

# Check if the current directory is a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  error "This script must be run inside a Git repository."
fi

# Get repository origin URL
REPO_URL=$(git config --get remote.origin.url)

# Ensure repository is a GitLab repository
if [[ ! "$REPO_URL" =~ gitlab.com ]]; then
  error "This script only supports GitLab repositories. Detected repository: $REPO_URL"
fi

# Configuration
GITLAB_URL="https://gitlab.com/api/v4"            
SOURCE_BRANCH=$(git branch --show-current)
PULL_REQUEST_DESCRIPTION=$(git log -1 --pretty=%B)

# Function to get the GitLab Project ID dynamically
fetch_project_id() {
  local repo_url
  repo_url=$(git config --get remote.origin.url | sed 's/\.git$//')  # Get the repo URL
  repo_url="${repo_url/git@github.com:/https://github.com/}"  # Convert SSH to HTTPS format
  repo_url="${repo_url/git@gitlab.com:/https://gitlab.com/}"  # Convert SSH to HTTPS

  echo "🔍 Fetching Project ID for repository: $repo_url"

  local response
  response=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/projects?search=$(basename "$repo_url")")

  PROJECT_ID=$(echo "$response" | grep -o '"id":[0-9]*' | head -1 | cut -d ':' -f2)

  if [[ -z "$PROJECT_ID" ]]; then
    echo "❌ Error: Could not fetch PROJECT_ID from GitLab. Ensure the repository exists and your token has API access."
    exit 1
  fi

  echo "✅ Project ID: $PROJECT_ID"
  # Set PROJECT ID
  GITLAB_PROJECT_ID=$PROJECT_ID
}

# Function to verify GitLab Token
verify_gitlab_token() {
  local response
  response=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/user")

  if ! echo "$response" | grep -q '"id":'; then
    error "Invalid GitLab Token! Please check and update your GITLAB_TOKEN."
    show_help
  fi
}

# Function to verify Project ID
verify_project_id() {
  local response
  response=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/projects/$GITLAB_PROJECT_ID")

  if ! echo "$response" | grep -q '"id":'; then
    error "Invalid Project ID! Please check and update your GITLAB_PROJECT_ID."
    show_help
  fi
}

fetch_project_id

# Verify Token and Project ID if empty
if [[ -z "$GITLAB_TOKEN" ]]; then
  error "GitLab token is missing! Set it before running the script."
fi

if [[ -z "$GITLAB_PROJECT_ID" ]]; then
  error "Project ID is missing! Set it before running the script."
fi

# Verify AccessToken & Project ID
verify_gitlab_token
verify_project_id

# Check if the user provided target branches, otherwise use default ones
TARGET_BRANCHES=("$@")

if [[ ${#TARGET_BRANCHES[@]} -eq 0 ]]; then
  echo -e "\n${YELLOW}⚠️ No target branches specified. The default target branches will be used${NC}${GREEN}: ${DEFAULT_TARGET_BRANCHES[*]}${NC}"
  read -p "Do you want to proceed? (y/n): " confirm

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    TARGET_BRANCHES=("${DEFAULT_TARGET_BRANCHES[@]}")
    echo -e "${GREEN}✅ Proceeding with default branches: ${TARGET_BRANCHES[*]}${NC}\n"
  else
    error "Operation canceled by the user."
  fi
fi

# Check if branch exists
if [[ -z "$SOURCE_BRANCH" ]]; then
  echo -e "${RED} Error: You are not on a branch. Please checkout a branch first.${NC}"
  exit 1
fi

# Function to check if a branch exists in GitLab
check_branch_exists() {
  local branch=$1
  local response
  response=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/projects/$GITLAB_PROJECT_ID/repository/branches/$branch")

  if echo "$response" | grep -q '"name":'; then
    return 0  # Branch exists
  else
    return 1  # Branch does not exist
  fi
}
 
# Prevent creating an Merge Requests if the source branch is in the target branches
for TARGET_BRANCH in "${TARGET_BRANCHES[@]}"; do
  if [[ "$SOURCE_BRANCH" == "$TARGET_BRANCH" ]]; then
    error "-> Error: Source branch '$SOURCE_BRANCH' is one of the target branches ('$TARGET_BRANCH'). You cannot create a Merge Request from '$SOURCE_BRANCH' to itself."
    exit 1
  fi
done

# Function to check if a Merge Request already exists for the source and target branch
check_existing_mr() {
  local target_branch=$1
  local response
  response=$(curl --silent --header "PRIVATE-TOKEN: $GITLAB_TOKEN" "$GITLAB_URL/projects/$PROJECT_ID/merge_requests?state=opened")

  existing_mr_url=$(echo "$response" | grep -o "\"web_url\":\"[^\"]*\"" | grep "$target_branch" | cut -d '"' -f 4)

  if [[ -n "$existing_mr_url" ]]; then
    echo "$existing_mr_url"
    return 0  # MR already exists
  else
    return 1  # No existing MR found
  fi
}

# Loop through each target branch and validate before creating a merge request
for TARGET_BRANCH in "${TARGET_BRANCHES[@]}"; do
  if check_branch_exists "$TARGET_BRANCH"; then

    TARGET_BRANCH_UC="$(echo "$TARGET_BRANCH" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"
    PULL_REQUEST_TITLE="$TARGET_BRANCH_UC | Merge $SOURCE_BRANCH → $TARGET_BRANCH"

    response=$(curl --silent --show-error --request POST "$GITLAB_URL/projects/$GITLAB_PROJECT_ID/merge_requests" \
      --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
      --header "Content-Type: application/json" \
      --data "{
        \"source_branch\": \"$SOURCE_BRANCH\",
        \"target_branch\": \"$TARGET_BRANCH\",
        \"title\": \"$PULL_REQUEST_TITLE\",
        \"description\": \"$PULL_REQUEST_DESCRIPTION\"
      }")

    # Handle response
    if echo "$response" | grep -q '"id":'; then
      MERGE_REQUEST_URL=$(echo "$response" | grep -o '"web_url":"[^"]*' | sed -n '2p' | cut -d '"' -f 4)
      success "✅ Merge Request Created Successfully for [$TARGET_BRANCH_UC]"
      echo "  Click here to view: $MERGE_REQUEST_URL"
    elif echo "$response" | grep -qo "already exists"; then
      warning "❗️ Merge Request already exists for $SOURCE_BRANCH → $TARGET_BRANCH. Skipped..."
    else
      error "❗️ Failed to create Merge Request for $TARGET_BRANCH."
    fi

  else
    error "❗️ Warning: Target branch '$TARGET_BRANCH' does not exist. Skipping..." false
  fi
done
