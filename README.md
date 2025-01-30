# 🚀 GitLab Merge Request Automation Script

## 📚 Overview
This script automates the creation of **Merge Requests (PRs)** in a GitLab repository.  
It supports:
- **Multiple target branches** (specified manually or using defaults)
- **Validation of GitLab Token (`GITLAB_TOKEN`) and Project ID (`PROJECT_ID`)**
- **Avoiding duplicate MRs** by checking for existing ones
- **Error handling and logging**

---

## 📌 Setup & Installation

### **1️⃣ Install the Script**
Run the following command to **install the script system-wide**:
```bash
sudo curl -sSLo /usr/local/bin/new_gitlab_pr https://raw.githubusercontent.com/theizekry/gitlab-merge-requests-bot/refs/heads/main/new_gitlab_pr.sh && sudo chmod +x /usr/local/bin/new_gitlab_pr
```
✅ This:
- Downloads the script as `new_gitlab_pr`
- Moves it to `/usr/local/bin/` (making it globally accessible)
- Gives it execution permissions

---

### **2️⃣ Verify Installation**
```bash
new_gitlab_pr --help
```
✅ If installed correctly, this will display the help menu.

---

### **3️⃣ (Optional) Update the Script**
To get the **latest version**, run:
```bash
sudo curl -sSLo /usr/local/bin/new_gitlab_pr https://raw.githubusercontent.com/theizekry/gitlab-merge-requests-bot/refs/heads/main/new_gitlab_pr.sh && sudo chmod +x /usr/local/bin/new_gitlab_pr
```
*(Same as the install command, just overwrites the old version.)*

---

## 🎮 Demo Video
https://github.com/user-attachments/assets/c6cc8e88-6d73-4418-bc41-c3f9dc8b556d

---

## 📌 Prerequisites
Before running the script, you need:
1. **GitLab Personal Access Token** with API access. For more details about access token visit https://shorturl.at/QEbyn.
2. **A Unix-based environment (macOS/Linux)**.

Set the required environment variables:
```bash
export GITLAB_TOKEN="your_token_here"
```

---

## 🚀 Usage

### ✅ **Create Merge Requests for Default Target Branches (`develop`, `master`, `uat`)**
```bash
new_gitlab_pr
```

### ✅ **Specify Target Branches Manually**
```bash
new_gitlab_pr staging production
```
*(Creates MRs for `staging` and `production`.)*

---

## ⚙️ Options & Arguments
| Option | Description |
|--------|------------|
| `-h`, `--help` | Show help information |
| `TARGET_BRANCHES` | Specify target branches manually |

---

## 📝 Example Outputs

### ✅ **Creating a New Merge Request**
```
🚀 Starting Merge Request Process
📌 Target branches: test uat beta

🔍 Checking if target branch 'test' exists...
✅ Target branch 'test'

⚠️ Handling Existing Merge Requests
🔍 Checking if a Merge Request already exists...
⚠️ Merge Request already exists: https://gitlab.com/example/project/-/merge_requests/124
```

🛠️ Troubleshooting, Check logs for debugging
``` bash
cat ~/new_gitlab_pr.log
```