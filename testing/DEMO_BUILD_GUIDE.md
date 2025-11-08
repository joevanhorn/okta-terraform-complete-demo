# Okta Terraform Demo Build Guide for Solutions Engineers

**Welcome!** This guide will walk you through building a complete Okta infrastructure demo using Terraform - even if you've never heard of these tools before.

**Time Required:** 2-3 hours (first time)
**Difficulty:** Beginner-friendly
**What You'll Learn:** Infrastructure as Code, Terraform basics, Git/GitHub, Command line essentials

---

## 📖 Table of Contents

1. [What You'll Build (And Why It's Cool)](#1-what-youll-build-and-why-its-cool)
2. [Understanding the Basics](#2-understanding-the-basics)
3. [Before You Start - Prerequisites](#3-before-you-start---prerequisites)
4. [Setting Up Your Computer](#4-setting-up-your-computer)
5. [Getting the Code](#5-getting-the-code)
6. [Understanding What You Have](#6-understanding-what-you-have)
7. [Connecting to Okta](#7-connecting-to-okta)
8. [Your First Terraform Commands](#8-your-first-terraform-commands)
9. [Creating Your First Resource](#9-creating-your-first-resource)
10. [Viewing Your Work in Okta](#10-viewing-your-work-in-okta)
11. [Making Changes](#11-making-changes)
12. [Cleaning Up](#12-cleaning-up)
13. [Troubleshooting](#13-troubleshooting)
14. [Next Steps](#14-next-steps)

---

## 1. What You'll Build (And Why It's Cool)

### The End Result

By the end of this guide, you will have:
- ✅ Created Okta users automatically using code
- ✅ Created groups and assigned users to them
- ✅ Set up applications in Okta
- ✅ Made changes and seen them apply instantly
- ✅ Learned how to "undo" everything safely

### Why This Matters for Sales

**Traditional Way (Manual):**
1. Log into Okta Admin Console
2. Click "Add User" for each person
3. Fill out forms manually
4. Repeat 100 times for 100 users
5. Make a mistake? Start over.
6. Want to demo this for another customer? Repeat everything.

**The Terraform Way (Automated):**
1. Write code once describing what you want
2. Run one command
3. Terraform creates everything automatically
4. Need to demo again? Run the same command
5. Made a mistake? Change one line and re-run
6. Want to delete everything? One command.

**Real-World Example:**
Instead of spending 3 hours clicking through screens to set up a demo, you spend 10 minutes running commands. You can set up, tear down, and rebuild demos as many times as you need.

---

## 2. Understanding the Basics

Before we start, let's understand the tools you'll be using.

### What is Infrastructure as Code (IaC)?

**Simple Analogy:**
Think of IaC like a recipe for a cake:
- **Manual way:** You bake a cake, and if you want another one, you have to remember all the steps
- **Recipe way:** You write down the recipe once, and anyone can bake the same cake by following it

Infrastructure as Code is the "recipe" for your IT infrastructure. Instead of clicking buttons, you write down what you want in a file, and the computer builds it for you.

### What is Terraform?

**Terraform** is a tool that reads your "recipes" (code) and builds infrastructure for you.

**What it does:**
- Reads files you write (with a `.tf` extension)
- Talks to Okta (or AWS, Azure, etc.)
- Creates, updates, or deletes resources automatically
- Keeps track of what it created

**What it doesn't do:**
- It doesn't replace Okta
- It doesn't store your data
- It doesn't make decisions for you (you tell it what to do)

### What is Git and GitHub?

**Git** is like "Track Changes" in Microsoft Word, but for code:
- Saves every version of your files
- Lets you go back to earlier versions
- Shows you what changed

**GitHub** is like Google Drive for code:
- Stores your code online
- Lets teams share code
- Keeps backup copies

### What is the Command Line?

The **command line** (also called "terminal" or "bash") is a way to talk to your computer by typing commands instead of clicking.

**Think of it like:**
- Clicking buttons = talking to your computer in pictures
- Command line = talking to your computer in text

Don't worry - we'll explain every command you type!

---

## 3. Before You Start - Prerequisites

### What You Need

#### Required:
1. **A Computer** - Mac, Windows, or Linux
2. **Internet Connection** - To download tools and connect to Okta
3. **An Okta Account** with admin access
   - Ask your team for access to a demo tenant
   - You need "Super Admin" permissions

#### Nice to Have:
1. **A text editor** - We recommend Visual Studio Code (free)
2. **Patience** - First time always takes longer (that's normal!)

---

## 4. Setting Up Your Computer

We need to install several tools. Don't worry - we'll guide you through each one.

### Step 1: Install a Text Editor (5 minutes)

**What is it?** A program to read and write code files.

**Why do we need it?** To look at and modify the Terraform files.

**How to install:**

1. Go to: https://code.visualstudio.com/
2. Click "Download" for your operating system (Mac/Windows/Linux)
3. Run the installer
4. Click "Next" a few times
5. Done!

**Test it worked:**
- Open Visual Studio Code
- You should see a welcome screen

---

### Step 2: Install Git (10 minutes)

**What is it?** The tool that tracks changes to your files.

#### For Mac Users:

1. Open "Terminal" app:
   - Press `Command + Space`
   - Type "Terminal"
   - Press Enter

2. Type this command and press Enter:
   ```bash
   git --version
   ```

3. If you see a version number, Git is already installed! Skip to Step 3.

4. If not, you'll be prompted to install "Command Line Tools" - click "Install"

#### For Windows Users:

1. Go to: https://git-scm.com/download/win
2. Download the installer
3. Run it and click "Next" for all options (defaults are fine)
4. Restart your computer

**Test it worked:**

1. Open Terminal (Mac) or Git Bash (Windows)
2. Type:
   ```bash
   git --version
   ```
3. You should see something like: `git version 2.39.0`

✅ **Success!** Git is installed.

---

### Step 3: Install Terraform (10 minutes)

**What is it?** The tool that reads your code and talks to Okta.

#### For Mac Users:

1. Open Terminal

2. First, install Homebrew (a tool installer for Mac):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   - This might take 5-10 minutes
   - You'll need to type your computer password

3. Install Terraform:
   ```bash
   brew install terraform
   ```

#### For Windows Users:

1. Go to: https://www.terraform.io/downloads
2. Download "Windows 386" or "Windows AMD64" (most common)
3. Unzip the downloaded file
4. Move `terraform.exe` to `C:\Windows\System32\`
5. Restart Git Bash

#### For Linux Users:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Test it worked:**

```bash
terraform version
```

You should see: `Terraform v1.9.x` (or higher)

✅ **Success!** Terraform is installed.

---

### Step 4: Install Python (5 minutes)

**What is it?** A programming language (we use it for some helper scripts).

#### For Mac Users:

Python is usually pre-installed. Check:

```bash
python3 --version
```

If you see a version number like `Python 3.x.x`, you're good!

If not:
```bash
brew install python3
```

#### For Windows Users:

1. Go to: https://www.python.org/downloads/
2. Download Python 3.11 or higher
3. Run installer
4. **IMPORTANT:** Check "Add Python to PATH" during installation
5. Click "Install Now"

**Test it worked:**

```bash
python3 --version
```

✅ **Success!** Python is installed.

---

### Step 5: Set Up GitHub Account (5 minutes)

**What is it?** A website where the demo code lives.

1. Go to: https://github.com/
2. Click "Sign Up" (if you don't have an account)
3. Follow the prompts to create your account
4. Remember your username and password!

✅ **Success!** GitHub account ready.

---

## 5. Getting the Code

Now we'll download the demo code to your computer.

### Understanding What We're Doing

We're going to "clone" (make a copy of) the demo code from GitHub to your computer.

**Think of it like:**
- The code on GitHub = The original recipe book in a library
- Cloning = Making your own copy to take home
- Your computer = Your kitchen where you'll use the recipe

### Step-by-Step: Clone the Repository

**"Repository" = A folder that contains all the code**

1. **Open your Terminal or Git Bash**

2. **Navigate to where you want to put the code**

   Let's put it in your home folder:
   ```bash
   cd ~
   ```

   **What this means:**
   - `cd` = "change directory" (go to a folder)
   - `~` = your home folder

3. **Clone the repository:**

   ```bash
   git clone https://github.com/joevanhorn/okta-terraform-complete-demo.git
   ```

   **What this does:**
   - Downloads all the code to your computer
   - Creates a folder called `okta-terraform-complete-demo`

   **You should see:**
   ```
   Cloning into 'okta-terraform-complete-demo'...
   remote: Counting objects: 100% (500/500), done.
   remote: Compressing objects: 100% (300/300), done.
   Receiving objects: 100% (500/500), 1.5 MiB | 2.5 MiB/s, done.
   ```

4. **Go into the folder:**

   ```bash
   cd okta-terraform-complete-demo
   ```

5. **Look at what's inside:**

   ```bash
   ls
   ```

   **You should see folders like:**
   - `environments/`
   - `scripts/`
   - `docs/`
   - `.github/`

✅ **Success!** You have the code on your computer.

---

## 6. Understanding What You Have

Let's take a tour of what you downloaded.

### Open the Folder in Visual Studio Code

1. In your terminal, type:
   ```bash
   code .
   ```

   **What this does:** Opens Visual Studio Code with the current folder

   If that doesn't work, you can:
   - Open Visual Studio Code manually
   - Click File → Open Folder
   - Select `okta-terraform-complete-demo`

### The Folder Structure

You'll see this on the left side:

```
okta-terraform-complete-demo/
├── environments/          ← Different Okta setups
│   └── lowerdecklabs/    ← The demo we'll use
│       ├── terraform/    ← The Terraform code files
│       ├── imports/      ← Data imported from Okta
│       └── config/       ← Configuration files
├── scripts/              ← Helper scripts
├── docs/                 ← Documentation (guides like this)
└── testing/              ← Test plans
```

**Think of it like:**
- `environments/` = Different "recipes" for different situations
- `lowerdecklabs/` = The specific recipe we're using today
- `terraform/` = The actual recipe instructions
- `docs/` = The cookbook with explanations

### Key Files to Know

In `environments/lowerdecklabs/terraform/`, you'll find:

- **`provider.tf`** - Tells Terraform to talk to Okta
- **`variables.tf`** - Settings you can customize
- **`user.tf`** - Code to create users
- **`group.tf`** - Code to create groups
- **`app_oauth.tf`** - Code to create applications

**Don't edit these yet!** We'll do that together soon.

---

## 7. Connecting to Okta

Before Terraform can create anything, it needs to know:
1. **Which Okta organization** to connect to
2. **Permission** to make changes (via an API token)

### Step 1: Get Your Okta Details

You need three pieces of information:

1. **Org Name** - Example: `dev-12345678`
2. **Base URL** - Example: `okta.com` (or `oktapreview.com`)
3. **API Token** - A secret key that lets Terraform make changes

#### Finding Your Org Name:

1. Log into Okta Admin Console
2. Look at the URL in your browser
3. It looks like: `https://dev-12345678.okta.com/admin`
4. Your org name is: `dev-12345678`

#### Finding Your Base URL:

Look at the URL again:
- If it ends in `.okta.com` → Base URL is `okta.com`
- If it ends in `.oktapreview.com` → Base URL is `oktapreview.com`

#### Creating an API Token:

1. In Okta Admin Console, go to **Security → API**
2. Click the **Tokens** tab
3. Click **Create Token**
4. Give it a name: `Terraform Demo Token`
5. Click **Create Token**
6. **IMPORTANT:** Copy the token value that appears
   - It looks like: `00H_aBcDeFgHiJkLmNoPqRsTuVwXyZ123456789`
   - **You'll only see this once!** Save it somewhere safe
   - Don't share it with anyone

### Step 2: Create Your Configuration File

Now we'll create a file with your Okta details.

1. In Visual Studio Code, navigate to: `environments/lowerdecklabs/terraform/`

2. Look for a file called `terraform.tfvars.example`

3. Right-click on it and select "Duplicate"

4. Rename the duplicate to: `terraform.tfvars` (remove `.example`)

5. Open `terraform.tfvars` and you'll see:

   ```hcl
   # Okta Configuration
   okta_org_name  = "your-org-name"
   okta_base_url  = "okta.com"
   okta_api_token = "your-api-token-here"
   ```

6. Replace the values with yours:

   ```hcl
   okta_org_name  = "dev-12345678"
   okta_base_url  = "oktapreview.com"
   okta_api_token = "00H_aBcDeFgHiJkLmNoPqRsTuVwXyZ123456789"
   ```

7. **Save the file** (Command+S on Mac, Ctrl+S on Windows)

### Step 3: Verify the File is Ignored by Git

**Important Security Note:** We don't want to accidentally share our API token!

1. Open the file called `.gitignore` (in the root folder)

2. Look for this line:
   ```
   terraform.tfvars
   ```

3. If you see it, great! This means Git will ignore this file and won't upload it anywhere.

✅ **Success!** You're connected to Okta.

---

## 8. Your First Terraform Commands

Now the fun part - actually using Terraform!

### Step 1: Navigate to the Terraform Folder

In your terminal:

```bash
cd ~/okta-terraform-complete-demo/environments/lowerdecklabs/terraform
```

**What this does:** Goes to the folder with the Terraform code

### Step 2: Initialize Terraform

Type this command:

```bash
terraform init
```

**What this does:**
- Downloads the Okta plugin for Terraform
- Sets up Terraform to work in this folder
- Creates a `.terraform` folder with necessary files

**You should see:**
```
Initializing the backend...

Initializing provider plugins...
- Finding okta/okta versions matching "~> 6.1.0"...
- Installing okta/okta v6.1.0...
- Installed okta/okta v6.1.0

Terraform has been successfully initialized!
```

✅ **Success!** Terraform is ready to use.

**If you see errors:** Check the [Troubleshooting](#13-troubleshooting) section

### Step 3: Preview What Terraform Will Do

Before creating anything, let's see what Terraform wants to do:

```bash
terraform plan
```

**What this does:**
- Reads all the `.tf` files
- Compares them to what exists in Okta
- Shows you what it would create/change/delete

**You should see:**
```
Terraform will perform the following actions:

  # okta_user.john_doe will be created
  + resource "okta_user" "john_doe" {
      + email      = "john.doe@example.com"
      + first_name = "John"
      + last_name  = "Doe"
      ...
    }

Plan: 15 to add, 0 to change, 0 to destroy.
```

**Understanding the output:**
- `+` means CREATE (green)
- `~` means CHANGE (yellow)
- `-` means DELETE (red)
- The number at the end (`Plan: 15 to add`) tells you how many resources

**Don't worry!** Nothing has been created yet. This is just a preview.

---

## 9. Creating Your First Resource

Now let's actually create something in Okta!

### Understanding What We're Creating

Look at the file `user.tf`:

```hcl
resource "okta_user" "john_doe" {
  email      = "john.doe@example.com"
  first_name = "John"
  last_name  = "Doe"
  login      = "john.doe@example.com"
}
```

**Breaking this down:**
- `resource` = "I want to create something"
- `"okta_user"` = The type of thing (an Okta user)
- `"john_doe"` = A name for this resource (just for Terraform's reference)
- Everything in `{ }` = The details (email, name, etc.)

**Think of it like filling out a form:**
- Email: john.doe@example.com
- First Name: John
- Last Name: Doe

### Step 1: Create the Resources

Run this command:

```bash
terraform apply
```

**What happens:**
1. Terraform shows you the plan again
2. It asks: "Do you want to perform these actions?"
3. You type: `yes`
4. Terraform creates everything

**You should see:**
```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

**Type:** `yes` and press Enter

**You should then see:**
```
okta_user.john_doe: Creating...
okta_user.john_doe: Creation complete after 2s [id=00u1234567890]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

✅ **Success!** You just created a user in Okta using code!

**What just happened:**
1. Terraform read your code
2. It talked to Okta's API
3. It created the user
4. It saved information about what it created in a file called `terraform.tfstate`

---

## 10. Viewing Your Work in Okta

Let's verify that Terraform actually created the user.

### Step 1: Open Okta Admin Console

1. Go to your Okta admin URL (e.g., `https://dev-12345678.okta.com/admin`)
2. Log in

### Step 2: Find the User

1. Click **Directory** in the left menu
2. Click **People**
3. Look for "John Doe" (or search for `john.doe@example.com`)

**You should see:**
- Name: John Doe
- Email: john.doe@example.com
- Status: Active (or Staged)

✅ **Success!** The user you created with code is really in Okta!

### Cool Things to Notice

1. **You didn't click anything** - Terraform did it for you
2. **You can do this again** - Run the same command on a different Okta org
3. **It's documented** - The `.tf` file shows exactly what was created

---

## 11. Making Changes

Now let's modify our user and see how Terraform handles changes.

### Step 1: Edit the Code

1. Open `user.tf` in Visual Studio Code

2. Find the John Doe user:
   ```hcl
   resource "okta_user" "john_doe" {
     email      = "john.doe@example.com"
     first_name = "John"
     last_name  = "Doe"
     login      = "john.doe@example.com"
   }
   ```

3. Let's add a department. Change it to:
   ```hcl
   resource "okta_user" "john_doe" {
     email      = "john.doe@example.com"
     first_name = "John"
     last_name  = "Doe"
     login      = "john.doe@example.com"
     department = "Engineering"  ← Add this line
   }
   ```

4. **Save the file**

### Step 2: Preview the Change

```bash
terraform plan
```

**You should see:**
```
  # okta_user.john_doe will be updated in-place
  ~ resource "okta_user" "john_doe" {
        email      = "john.doe@example.com"
      + department = "Engineering"
        first_name = "John"
        ...
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

**Notice:**
- `~` means "update" (not delete and recreate)
- `+ department` shows it's adding the department field
- `1 to change` means only updating one resource

### Step 3: Apply the Change

```bash
terraform apply
```

Type `yes` when prompted.

**You should see:**
```
okta_user.john_doe: Modifying... [id=00u1234567890]
okta_user.john_doe: Modifications complete after 1s

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

### Step 4: Verify in Okta

1. Go back to Okta Admin Console
2. Open John Doe's user profile
3. Look for the "Department" field
4. It should now say: "Engineering"

✅ **Success!** You modified a user using code!

---

## 12. Cleaning Up

When you're done with your demo, you can delete everything Terraform created.

### The Easy Way to Delete Everything

Run this command:

```bash
terraform destroy
```

**What this does:**
- Looks at what Terraform created (stored in `terraform.tfstate`)
- Deletes all of it from Okta

**You'll see:**
```
Plan: 0 to add, 0 to change, 15 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value:
```

**Type:** `yes`

**You should see:**
```
okta_user.john_doe: Destroying... [id=00u1234567890]
okta_user.john_doe: Destruction complete after 1s

Destroy complete! Resources: 15 destroyed.
```

### Verify in Okta

1. Go to Okta Admin Console → Directory → People
2. John Doe should be gone

**Important Notes:**
- This only deletes things **Terraform created**
- It won't delete things you created manually in Okta
- You can run `terraform apply` again to recreate everything

✅ **Success!** Clean demo environment.

---

## 13. Troubleshooting

### Problem: "terraform: command not found"

**What it means:** Terraform isn't installed or isn't in your PATH

**Solution:**
1. Reinstall Terraform (see [Step 3](#step-3-install-terraform-10-minutes))
2. Restart your terminal
3. Try again

---

### Problem: "Error: Invalid provider configuration"

**What it means:** Your `terraform.tfvars` file has issues

**Solution:**
1. Check that `terraform.tfvars` exists in `environments/lowerdecklabs/terraform/`
2. Verify all three values are filled in:
   - `okta_org_name`
   - `okta_base_url`
   - `okta_api_token`
3. Make sure there are no extra spaces or quotes

---

### Problem: "Error: 401 Unauthorized"

**What it means:** Your API token is wrong or expired

**Solution:**
1. Go to Okta Admin Console → Security → API → Tokens
2. Create a new API token
3. Update `terraform.tfvars` with the new token
4. Try again

---

### Problem: "Error: Insufficient permissions"

**What it means:** Your API token doesn't have permission to create users

**Solution:**
1. Make sure you're using a Super Admin account
2. Create a new API token from a Super Admin account
3. Update `terraform.tfvars`

---

### Problem: Changes not showing in Okta

**Solution:**
1. Refresh the Okta Admin Console page
2. Run `terraform plan` to see if Terraform knows about the change
3. Check if you saved the `.tf` file

---

### Problem: "Error: Duplicate resource"

**What it means:** You're trying to create something that already exists

**Solution:**
1. Run `terraform destroy` to clean up
2. Or manually delete the conflicting resource in Okta
3. Run `terraform apply` again

---

## 14. Next Steps

Congratulations! You've learned the basics of Infrastructure as Code and Terraform!

### What You Accomplished

- ✅ Installed developer tools
- ✅ Downloaded code from GitHub
- ✅ Connected Terraform to Okta
- ✅ Created resources automatically
- ✅ Modified resources using code
- ✅ Cleaned up when done

### Continue Learning

#### Level 2: Create Your Own Resource

Try creating a new user:

1. Open `user.tf`
2. Add a new user block:
   ```hcl
   resource "okta_user" "your_name" {
     email      = "yourname@example.com"
     first_name = "Your"
     last_name  = "Name"
     login      = "yourname@example.com"
     department = "Sales"
   }
   ```
3. Run `terraform plan` to preview
4. Run `terraform apply` to create
5. Check Okta to verify

#### Level 3: Create a Group

1. Open `group.tf`
2. Add a new group:
   ```hcl
   resource "okta_group" "demo_team" {
     name        = "Demo Team"
     description = "Team for product demos"
   }
   ```
3. Apply it with Terraform
4. Verify in Okta

#### Level 4: Import Existing Resources

Learn how to bring existing Okta resources under Terraform management:
- See: `docs/TERRAFORM_RESOURCES.md`
- Section: "Use Case 1: Import Existing Infrastructure"

### Resources for Learning More

**Terraform:**
- [Official Terraform Tutorial](https://learn.hashicorp.com/terraform)
- [Terraform Documentation](https://www.terraform.io/docs)

**Okta Terraform Provider:**
- [Provider Documentation](https://registry.terraform.io/providers/okta/okta/latest/docs)
- [Complete Resource Guide](../docs/TERRAFORM_RESOURCES.md)

**Git and GitHub:**
- [GitHub Hello World Guide](https://guides.github.com/activities/hello-world/)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)

**Command Line:**
- [Command Line Crash Course](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Understanding_client-side_tools/Command_line)

### Practice Ideas

1. **Build a complete demo environment:**
   - 10 users in different departments
   - 5 groups (Engineering, Sales, Marketing, IT, HR)
   - Assign users to groups
   - Create 2-3 applications

2. **Test disaster recovery:**
   - Build everything with `terraform apply`
   - Destroy it with `terraform destroy`
   - Rebuild it in under 5 minutes
   - Show customers how fast you can recover

3. **Multi-environment demos:**
   - Create separate environments for different demo scenarios
   - Keep them as code
   - Spin up the right one for each customer

### Getting Help

**If you get stuck:**

1. **Check the Troubleshooting section** (above)
2. **Review the validation plan:** `testing/MANUAL_VALIDATION_PLAN.md`
3. **Read the full docs:** `docs/` folder
4. **Ask your team** - Someone has probably seen the issue before
5. **Check official docs** - Terraform and Okta have great documentation

### Share Your Success

When you successfully build your first demo:
1. Take a screenshot of the Terraform output
2. Take a screenshot of the resources in Okta
3. Share with your team!

---

## Appendix: Quick Reference Commands

### Essential Terraform Commands

```bash
# Initialize Terraform (first time only)
terraform init

# See what Terraform will do (preview)
terraform plan

# Create/update resources
terraform apply

# Delete everything Terraform created
terraform destroy

# Check if your code is valid
terraform validate

# Format your code nicely
terraform fmt

# Show current state
terraform show
```

### Essential Git Commands

```bash
# Download code from GitHub
git clone <url>

# See what changed
git status

# Update your code from GitHub
git pull
```

### Essential Terminal Commands

```bash
# Go to a folder
cd folder-name

# Go to home folder
cd ~

# Go up one level
cd ..

# List files in current folder
ls

# Show current folder path
pwd

# Clear the screen
clear
```

---

## Glossary

**Apply** - Tell Terraform to make the changes (create/update/delete resources)

**API Token** - A secret key that gives Terraform permission to change Okta

**Clone** - Make a copy of code from GitHub to your computer

**Destroy** - Delete all resources that Terraform created

**Infrastructure as Code (IaC)** - Managing IT infrastructure using code files instead of manual processes

**Initialize** - Set up Terraform in a folder (download plugins, etc.)

**Plan** - Preview what Terraform will do without actually doing it

**Provider** - A plugin that lets Terraform talk to a service (Okta, AWS, etc.)

**Repository (Repo)** - A folder containing code, tracked by Git

**Resource** - Something Terraform manages (a user, group, app, etc.)

**State** - Terraform's memory of what it created (stored in `terraform.tfstate`)

**Terraform** - Tool that reads code and creates infrastructure

**Terminal** - Program where you type commands (also called "command line" or "bash")

---

**Congratulations on completing the demo build guide!**

You now understand the fundamentals of Infrastructure as Code and can build automated Okta demos. Keep practicing and exploring!

---

*Last updated: 2025-11-07*
