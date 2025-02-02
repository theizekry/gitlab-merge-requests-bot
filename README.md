
# ✨ Automate Your GitLab Merge Requests with One Command! ✨

  

## 🚀 Introducing the GitLab Merge Requests Bot

Managing multiple merge requests can be time-consuming, especially when working with multiple branches. **What if you could create and manage GitLab Merge Requests with a single command?**

  
Meet **GitLab Merge Requests Bot**, a simple yet powerful Bash script that streamlines your PR workflow, making it easier to handle multiple branches and avoid waste of time and repeated tasks even if it simple.
  

## 📚 Why Use This Toolkit?

###  **✅ Key Features:**

-  **One Command PRs:** Automate creating merge requests for multiple branches at once.

-  **Dynamic Project ID Retrieval:** No need to manually set the `PROJECT_ID`; the script fetches it automatically ( but sure it help if token in account level not project level ).

-  **Duplicate PR Prevention:** Checks for existing PRs before creating a new one.

-  **Custom Target Branches:** Specify branches manually or use default ones.

-  **Interactive Confirmation:** Get notified when using default branches.

-  **System-Wide Installation:** Easily install and run from anywhere.

-  **Error Handling & Logging:** Stay informed with detailed logs.

---

## 🛠️ How to Get Started

###  **1️⃣ Install the Script**

Run the following command to install and make it system-wide:

```bash

sudo  curl  -sSLo  /usr/local/bin/gitlab_pr  https://raw.githubusercontent.com/theizekry/gitlab-merge-requests-bot/main/gitlab_pr.sh  &&  sudo  chmod  +x  /usr/local/bin/gitlab_pr

```

###  **2️⃣ Set Up Your GitLab Token**

To authenticate with GitLab, you need a either **Personal Access Token** or **Project Access Token**:

A **Personal Access Token** is linked to your user account for broad access across projects for more info please visit https://shorturl.at/QEbyn., while a **Project Access Token** is limited to a specific project.  
Set your token as `GITLAB_TOKEN` in your environment for authentication.  

**To authenticate with GitLab, you need either a **Personal Access Token** (linked to your user account for broad access across projects) or a **Project Access Token** (limited to specific project repositories for enhanced security).  
For both, the required scopes are **API** and **write_repository**.  
_Note:_ A project token only works with repos granted to it, whereas a personal token can access all projects on your GitLab account; set your token as `GITLAB_TOKEN` in your environment.**

THEN

```bash

echo  'export GITLAB_TOKEN="your_generated_token_here"'  >>  ~/.bashrc

source  ~/.bashrc

```

For **Zsh users**:

```bash

echo  'export GITLAB_TOKEN="your_generated_token_here"'  >>  ~/.zshrc

source  ~/.zshrc

```
---

## 🚀 Usage

###  ✅  **Create Merge Requests for Default Target Branches (`develop`, `master`, `uat`)**

```bash

gitlab_pr

```

  

### ✅  **Specify Target Branches Manually**

```bash

gitlab_pr  staging  production

```

*(Creates MRs for `staging` and `production`.)*

  

### ✅ **Override Default Target Branches**

By default, the script creates merge requests for the following branches: `develop`, `master`, and `uat`. If you need to change this behavior, you can override the default target branches by exporting your own:

```bash

export  DEFAULT_TARGET_BRANCHES="branch1 branch2 branch3"

```

  

### ✅ **Check Logs for Debugging**

```bash

cat  ~/gitlab_pr.log

```
---

## 🎥 Demo in Action

Check out a quick demo of how this tool works:

  

https://github.com/user-attachments/assets/c6cc8e88-6d73-4418-bc41-c3f9dc8b556d

  

---

  

## 🎯 Who Is This For?

-  **Developers & DevOps Engineers** who frequently create GitLab MRs.

-  **Teams working on multiple branches** and need a simple, automated workflow.

-  **Anyone tired of manual PR creation and looking for automation.**

  

---

  

## 💡 Future Enhancements

- ✅ Support for GitLab **group-level MRs**

- ✅ Automatic **review assignments**

- ✅ More **detailed logging & debugging** options

  

---

  

## 🚀 Ready to Automate Your GitLab MRs?

Give it a try today! Feel free to drop feedback or suggestions.

  

🛠 Need help? Open an issue on [GitHub](https://github.com/theizekry/gitlab-merge-requests-bot/issues).

  

Happy coding! 🌟