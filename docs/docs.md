# GitLab Merge Requests Bot - Git Documentation

## Overview
The **GitLab Merge Requests Bot** is a Bash script that automates the creation of merge requests (MRs) on GitLab with a single command. It allows users to define target branches dynamically or use predefined ones, making the MR process faster and more efficient.

### Features
- 🚀 **One-Command Automation** – Create MRs effortlessly.
- ✅ **Custom Target Branches** – Specify branches manually for future use or set different target branches each time, even exporting your daily ones for flexible PR creation.
- 🔄 **Multiple Target Branch Support** – Create MRs for several branches at once.
- 🔐 **Secure API Access** – Uses a GitLab personal access token with required permissions.
- 📜 **Auto-Fetched Project ID** – Dynamically retrieves the GitLab project ID.
- 🛑 **Validation Checks** – Ensures valid branches and avoids duplicate MRs.

---

## Installation & Setup
### Prerequisites
Before running the script, ensure you have:
1. **Git installed** on your system.
2. **A Git repository** cloned locally.

### Step 1: Download the Script
Clone or download the script from [GitHub](https://github.com/theizekry/gitlab-merge-requests-bot):
```bash
git clone https://github.com/theizekry/gitlab-merge-requests-bot.git
cd gitlab-merge-requests-bot
chmod +x gitlab-pr.sh
```

### Step 2: Set Up Environment Variables
(Optional) Set default target branches:
```bash
export DEFAULT_TARGET_BRANCHES="develop master uat"
```

---

## Usage
Run the script inside a Git repository:
```bash
./gitlab-pr.sh [TARGET_BRANCHES...]
```
If no target branches are provided, it defaults to predefined branches (`develop`, `master`, `uat`).

### Example Commands:
- **Use default branches**:
  ```bash
  ./gitlab-pr.sh
  ```
- **Specify custom branches**:
  ```bash
  ./gitlab-pr.sh staging release
  ```
- **Check version**:
  ```bash
  ./gitlab-pr.sh --version
  ```
- **Display help**:
  ```bash
  ./gitlab-pr.sh --help
  ```

---

## How It Works
1. **Verifies Git Repository** – Ensures you are inside a valid Git repository.
2. **Checks for GitLab Token** – Validates that a token is set.
3. **Fetches Project ID** – Retrieves the GitLab project ID dynamically.
4. **Validates Target Branches** – Ensures target branches exist before proceeding.
5. **Prevents Duplicate MRs** – Checks if an MR already exists before creating a new one.
6. **Creates Merge Request** – Sends an API request to GitLab and generates an MR.

---

## Git Commands Used in the Script
### Check if Inside a Git Repository
```bash
git rev-parse --is-inside-work-tree
```

### Get the Current Branch
```bash
git branch --show-current
```

### Get Repository Origin URL
```bash
git config --get remote.origin.url
```

### Fetch Latest Changes from Remote Repository
```bash
git fetch --all
```

---

## Contributing
Feel free to contribute to the project via [GitHub](https://github.com/theizekry/gitlab-merge-requests-bot). Submit issues, feature requests, or pull requests to improve functionality.

---

## License
This project is open-source under the MIT License. See the LICENSE file for details.

**Author**: Islam Zekry  
**GitHub**: [@theizekry](https://github.com/theizekry)  
**Version**: 1.0  
**Release Date**: January 2025

