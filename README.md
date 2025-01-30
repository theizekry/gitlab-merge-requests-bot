# 🚀 GitLab Merge Request Automation Script

## 📖 Overview
This script automates the creation of **Merge Requests (PRs)** in a GitLab repository.  
It supports:
- **Multiple target branches** (specified manually or using defaults)
- **Avoiding duplicate MRs** by checking for existing ones
- **Error handling and logging**

## 🎬 Demo Video
📹 **Watch the script in action**: [Video Link](#) *(Replace with actual link)*

---

## 📌 Prerequisites
Before running the script, you need:
1. **GitLab Personal Access Token** with API access.
2. **GitLab Project ID** (You can find this in your GitLab repo settings).
3. **A Unix-based environment (macOS/Linux)**.

Set the required environment variables:
```bash
export GITLAB_TOKEN="your_token_here"
export GITLAB_PROJECT_ID="your_project_id_here"

## installation

Getting started with gitlab_PR is simple:

```bash
sudo wget -qO /usr/local/bin/gitlab_pr https://github.com/ && sudo chmod +x /usr/local/bin/gitlab_pr
```