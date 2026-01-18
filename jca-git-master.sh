#!/usr/bin/env bash

# =============================================
# JCA Git Master - Interactive Git Learning Tool
# =============================================
# Author: Solomon Kassa (Jedan Code Academy)
# Version: 2.0.0
# Website: https://github.com/jedancodeacademy
# =============================================

# Configuration
CONFIG_FILE="$HOME/.jca-git-config"
LOG_FILE="$HOME/jca-git-learning.log"
REPO_DIR="$HOME/JCA-FirstDay"
GITHUB_USER=""
GITHUB_TOKEN=""
USER_NAME=""
USER_EMAIL=""

# Colors and Styles
BOLD="\033[1m"
DIM="\033[2m"
ITALIC="\033[3m"
UNDERLINE="\033[4m"
BLINK="\033[5m"
REVERSE="\033[7m"
HIDDEN="\033[8m"

# Foreground Colors
BLACK="\033[30m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"

# Background Colors
BG_BLACK="\033[40m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"
BG_WHITE="\033[47m"

# Reset
RESET="\033[0m"

# Icons
CHECK="✅"
CROSS="❌"
INFO="ℹ️"
WARN="⚠️"
QUEST="❓"
ROCKET="🚀"
BOOK="📚"
KEY="🔑"
GEAR="⚙️"
CLOUD="☁️"
FOLDER="📁"
TERMINAL="💻"
GIT_ICON="🗃️"
USER_ICON="👤"
EMAIL_ICON="📧"
LINK="🔗"
DOWNLOAD="📥"
UPLOAD="📤"
BRANCH="🌿"
MERGE="🔄"
CODE="💻"
TIME="⏰"
LOCK="🔒"
UNLOCK="🔓"

# Animations
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# ASCII Art Banner
show_banner() {
    clear
    echo -e "${BLUE}${BOLD}"
    cat << "EOF"
   ██╗ ██████╗   █████╗     ██████╗ ██╗████████╗    ███╗   ███╗ █████╗ ███████╗████████╗███████╗██████╗ 
   ██║██╔════╝  ██╔══██╗    ██╔══██╗██║╚══██╔══╝    ████╗ ████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗
   ██║██║       ███████║    ██████╔╝██║   ██║       ██╔████╔██║███████║███████╗   ██║   █████╗  ██████╔╝
██╗██║██║       ██╔══██║    ╔══  ██╗██║   ██║       ██║╚██╔╝██║██╔══██║╚════██║   ██║   ██╔══╝  ██╔══██╗
█████╔╝╚██████╔╝██║  ██║    ║██████ ██║║  ██║       ██║ ╚═╝ ██║██║  ██║███████║   ██║   ███████╗██║  ██║
 ╚════╝  ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
EOF
    echo -e "${RESET}"
    echo -e "${CYAN}${BOLD}Jedan Code Academy - Git Master Learning System${RESET}"
    echo -e "${YELLOW}${ITALIC}Author: Solomon Kassa | Version 2.0.0${RESET}"
    echo -e "${MAGENTA}${UNDERLINE}Master Git from Zero to Hero!${RESET}\n"
}

# Print formatted sections
section() {
    echo -e "\n${BG_BLUE}${WHITE}${BOLD} $1 ${RESET}\n"
}

subsection() {
    echo -e "\n${CYAN}${BOLD}$1${RESET}"
    echo -e "${DIM}${ITALIC}$2${RESET}"
}

success() {
    echo -e "${GREEN}${CHECK} $1${RESET}"
}

error() {
    echo -e "${RED}${CROSS} $1${RESET}"
}

info() {
    echo -e "${BLUE}${INFO} $1${RESET}"
}

warning() {
    echo -e "${YELLOW}${WARN} $1${RESET}"
}

prompt() {
    echo -e "${MAGENTA}${QUEST} $1${RESET}"
}

# Load/Save Configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        success "Configuration loaded"
    else
        info "No configuration found. Starting fresh setup."
    fi
}

save_config() {
    cat > "$CONFIG_FILE" << EOF
GITHUB_USER="$GITHUB_USER"
GITHUB_TOKEN="$GITHUB_TOKEN"
USER_NAME="$USER_NAME"
USER_EMAIL="$USER_EMAIL"
EOF
    success "Configuration saved to $CONFIG_FILE"
}

# Log actions
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Installation Section
install_git() {
    section "STEP 1: ${GIT_ICON} GIT INSTALLATION"
    
    subsection "Checking Git Installation" "Let's verify if Git is already installed on your system"
    
    if command -v git &> /dev/null; then
        success "Git is already installed!"
        git --version
    else
        warning "Git is not installed. Let's install it now."
        
        echo -e "\n${BOLD}Choose your operating system:${RESET}"
        echo "1) macOS (using Homebrew)"
        echo "2) Ubuntu/Debian (using apt)"
        echo "3) CentOS/RHEL/Fedora (using yum/dnf)"
        echo "4) Windows (Git Bash)"
        echo "5) Skip installation"
        
        read -p "Select option (1-5): " os_choice
        
        case $os_choice in
            1)
                info "Installing Git on macOS..."
                if ! command -v brew &> /dev/null; then
                    warning "Homebrew not found. Installing Homebrew first..."
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                fi
                brew install git
                ;;
            2)
                info "Installing Git on Ubuntu/Debian..."
                sudo apt update
                sudo apt install -y git
                ;;
            3)
                info "Installing Git on CentOS/RHEL/Fedora..."
                if command -v dnf &> /dev/null; then
                    sudo dnf install -y git
                else
                    sudo yum install -y git
                fi
                ;;
            4)
                info "For Windows, please download Git from:"
                echo -e "${BLUE}${UNDERLINE}https://git-scm.com/download/win${RESET}"
                echo "After installation, restart your terminal and run this script again."
                exit 0
                ;;
            5)
                info "Skipping Git installation."
                return
                ;;
            *)
                error "Invalid choice"
                install_git
                ;;
        esac
        
        if command -v git &> /dev/null; then
            success "Git installed successfully!"
            git --version
        else
            error "Git installation failed. Please install manually."
            exit 1
        fi
    fi
}

# GitHub Token Guide
github_token_guide() {
    section "STEP 2: ${KEY} GITHUB TOKEN CREATION"
    
    subsection "Why You Need a GitHub Token" "Tokens provide secure access to your GitHub account without using passwords"
    
    echo -e "${BOLD}${GREEN}Follow these steps to create your GitHub Personal Access Token:${RESET}\n"
    
    echo "1. ${USER_ICON} Go to GitHub.com and sign in to your account"
    echo "2. ${GEAR} Click on your profile picture → Settings"
    echo "3. ${LOCK} In the left sidebar, click 'Developer settings'"
    echo "4. ${KEY} Click 'Personal access tokens' → 'Tokens (classic)'"
    echo "5. ${DOWNLOAD} Click 'Generate new token' → 'Generate new token (classic)'"
    echo "6. ${NOTEBOOK} Give your token a descriptive name (e.g., 'JCA-Git-Learning')"
    echo "7. ${CALENDAR} Set expiration (90 days recommended for learning)"
    echo "8. ${CHECKLIST} Select these scopes:"
    echo "   - ✓ repo (Full control of private repositories)"
    echo "   - ✓ workflow"
    echo "   - ✓ write:packages"
    echo "   - ✓ delete:packages"
    echo "9. ${GENERATE} Click 'Generate token'"
    echo "10. ${WARNING} ${RED}${BOLD}COPY THE TOKEN IMMEDIATELY!${RESET} It won't be shown again!"
    echo "11. ${SAVE} Save it in a secure password manager"
    
    echo -e "\n${YELLOW}${BOLD}⚠️ IMPORTANT SECURITY NOTES:${RESET}"
    echo "• Never share your token with anyone"
    echo "• Never commit tokens to version control"
    echo "• Treat tokens like passwords"
    echo "• Rotate tokens regularly"
    
    read -p "Press Enter when you have created your token..."
}

# Configure Git
configure_git() {
    section "STEP 3: ${GEAR} GIT CONFIGURATION"
    
    subsection "Setting Up Your Identity" "Git needs to know who you are for commit tracking"
    
    if [ -z "$USER_NAME" ]; then
        read -p "${USER_ICON} Enter your full name: " USER_NAME
        git config --global user.name "$USER_NAME"
        success "Username set to: $USER_NAME"
    fi
    
    if [ -z "$USER_EMAIL" ]; then
        read -p "${EMAIL_ICON} Enter your email address: " USER_EMAIL
        git config --global user.email "$USER_EMAIL"
        success "Email set to: $USER_EMAIL"
    fi
    
    if [ -z "$GITHUB_USER" ]; then
        read -p "Enter your GitHub username: " GITHUB_USER
    fi
    
    # Configure helpful settings
    git config --global core.editor "nano"
    git config --global init.defaultBranch "main"
    git config --global pull.rebase false
    git config --global color.ui auto
    
    # Configure credential helper
    git config --global credential.helper store
    
    success "Git global configuration completed!"
    
    echo -e "\n${BOLD}Current Git Configuration:${RESET}"
    git config --list | grep -E "user\.|core\.|init\." | head -10
}

# Setup JCA-FirstDay Repository
setup_jca_repo() {
    section "STEP 4: ${FOLDER} JCA-FIRSTDAY REPOSITORY SETUP"
    
    subsection "Creating Learning Environment" "We'll create a practice repository for hands-on learning"
    
    if [ -d "$REPO_DIR" ]; then
        warning "Repository directory already exists at: $REPO_DIR"
        read -p "Do you want to remove it and start fresh? (y/N): " remove_choice
        if [[ $remove_choice =~ ^[Yy]$ ]]; then
            rm -rf "$REPO_DIR"
            success "Removed existing directory"
        else
            info "Using existing repository"
            cd "$REPO_DIR" || exit
            return
        fi
    fi
    
    # Create directory and initialize git
    mkdir -p "$REPO_DIR"
    cd "$REPO_DIR" || exit
    
    info "Initializing new Git repository..."
    git init
    success "Git repository initialized at: $REPO_DIR"
    
    # Create initial files
    cat > README.md << EOF
# JCA-FirstDay Repository
## Jedan Code Academy - Git Learning Project

Welcome to your Git learning journey! This repository is designed to help you practice Git commands.

### Project Structure
- \`README.md\` - This file
- \`scripts/\` - For your code files
- \`notes/\` - For your learning notes
- \`.gitignore\` - Files to ignore in version control

### Learning Objectives
1. Master basic Git commands
2. Understand branching and merging
3. Learn to collaborate using GitHub
4. Practice real-world workflows

**Author:** $USER_NAME  
**Email:** $USER_EMAIL  
**Created:** $(date)
EOF
    
    mkdir -p scripts notes
    echo "print('Hello Git!')" > scripts/hello.py
    echo "# Learning Notes\n\nDay 1: Started Git learning with JCA" > notes/day1.md
    
    cat > .gitignore << EOF
# Python
__pycache__/
*.py[cod]
*$py.class

# Environment
.env
.venv
env/
venv/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF
    
    success "Project structure created with starter files"
    
    # Initial commit
    git add .
    git commit -m "Initial commit: JCA FirstDay repository setup"
    
    success "First commit completed!"
    log_action "Created JCA-FirstDay repository"
}

# Interactive Git Learning Module
git_learning_module() {
    section "STEP 5: ${BOOK} INTERACTIVE GIT LEARNING"
    
    while true; do
        echo -e "\n${BG_CYAN}${WHITE}${BOLD} GIT LEARNING MODULE ${RESET}"
        echo -e "${BOLD}Choose a topic to learn:${RESET}\n"
        
        echo "1) ${TERMINAL} Basic Commands"
        echo "2) ${BRANCH} Branching & Merging"
        echo "3) ${CLOUD} Remote Operations"
        echo "4) ${TIME} Undo & Recovery"
        echo "5) ${CODE} Advanced Techniques"
        echo "6) ${CHECK} Quick Reference (Cheat Sheet)"
        echo "7) ${ROCKET} Practice Exercises"
        echo "8) ${UPLOAD} Push to GitHub"
        echo "0) ${CROSS} Exit to Main Menu"
        
        read -p "Select option (0-8): " learn_choice
        
        case $learn_choice in
            1) learn_basic_commands ;;
            2) learn_branching ;;
            3) learn_remote_ops ;;
            4) learn_undo_recovery ;;
            5) learn_advanced ;;
            6) show_cheat_sheet ;;
            7) practice_exercises ;;
            8) push_to_github ;;
            0) return ;;
            *) error "Invalid selection" ;;
        esac
    done
}

# Basic Commands Lesson
learn_basic_commands() {
    subsection "${TERMINAL} BASIC GIT COMMANDS" "Essential commands every developer must know"
    
    echo -e "${BOLD}Core Workflow:${RESET}"
    
    cat << 'EOF'
┌─────────────────────────────────────────────────────┐
│                Git Basic Workflow                   │
├─────────────────────────────────────────────────────┤
│   Working Directory      Staging Area    Repository │
│        (untracked)          (index)       (history) │
│             │                    │              │   │
│   git add   ├───────────────────►│              │   │
│             │                    │              │   │
│   git commit├──────────────────────────────────►│   │
│             │                    │              │   │
│   git push  └──────────────────────────────────────►│
│             │                    │              │   │
│   git pull  │◄──────────────────────────────────────┤
│             │                    │              │   │
│   git status│ shows state        │              │   │
└─────────────┴────────────────────┴──────────────┘
EOF
    
    echo -e "\n${GREEN}${BOLD}1. Repository Setup:${RESET}"
    echo "   ${BLUE}git init${RESET}               - Initialize new repository"
    echo "   ${BLUE}git clone <url>${RESET}       - Clone existing repository"
    
    echo -e "\n${GREEN}${BOLD}2. File Operations:${RESET}"
    echo "   ${BLUE}git add <file>${RESET}        - Stage file for commit"
    echo "   ${BLUE}git add .${RESET}             - Stage all changes"
    echo "   ${BLUE}git rm <file>${RESET}         - Remove file from tracking"
    echo "   ${BLUE}git mv <old> <new>${RESET}    - Rename or move file"
    
    echo -e "\n${GREEN}${BOLD}3. Commit Operations:${RESET}"
    echo "   ${BLUE}git commit -m \"message\"${RESET} - Commit staged changes"
    echo "   ${BLUE}git commit -am \"message\"${RESET} - Add & commit tracked files"
    echo "   ${BLUE}git log${RESET}               - Show commit history"
    echo "   ${BLUE}git log --oneline${RESET}     - Compact history view"
    echo "   ${BLUE}git log --graph${RESET}       - Visual branch history"
    
    echo -e "\n${GREEN}${BOLD}4. Status & Diff:${RESET}"
    echo "   ${BLUE}git status${RESET}            - Show working directory state"
    echo "   ${BLUE}git diff${RESET}              - Show unstaged changes"
    echo "   ${BLUE}git diff --staged${RESET}     - Show staged changes"
    echo "   ${BLUE}git show <commit>${RESET}     - Show specific commit details"
    
    echo -e "\n${GREEN}${BOLD}5. Practice Now:${RESET}"
    echo "   Try these commands in your JCA-FirstDay repository:"
    echo "   1. ${CYAN}git status${RESET}"
    echo "   2. ${CYAN}git log --oneline${RESET}"
    echo "   3. ${CYAN}git diff${RESET}"
    
    read -p "Press Enter to practice these commands..."
    cd "$REPO_DIR" || exit
    bash -c "git status; echo; git log --oneline"
}

# Branching Lesson
learn_branching() {
    subsection "${BRANCH} BRANCHING & MERGING" "Work with multiple lines of development"
    
    cat << 'EOF'
┌─────────────────────────────────────────────┐
│           Branching Strategies              │
├─────────────────────────────────────────────┤
│   main/master ──────┬─────────────────────► │
│                     │                       │
│          feature ───┘                       │
│                     │                       │
│                hotfix ─────────────────────►│
│                                             │
│   git branch feature                        │
│   git checkout feature                      │
│   git merge feature                         │
└─────────────────────────────────────────────┘
EOF
    
    echo -e "\n${GREEN}${BOLD}1. Branch Operations:${RESET}"
    echo "   ${BLUE}git branch${RESET}            - List all branches"
    echo "   ${BLUE}git branch <name>${RESET}     - Create new branch"
    echo "   ${BLUE}git checkout <branch>${RESET} - Switch to branch"
    echo "   ${BLUE}git switch <branch>${RESET}   - Newer way to switch"
    echo "   ${BLUE}git checkout -b <branch>${RESET} - Create & switch"
    echo "   ${BLUE}git branch -d <branch>${RESET} - Delete branch"
    echo "   ${BLUE}git branch -m <new-name>${RESET} - Rename branch"
    
    echo -e "\n${GREEN}${BOLD}2. Merging:${RESET}"
    echo "   ${BLUE}git merge <branch>${RESET}    - Merge branch into current"
    echo "   ${BLUE}git merge --no-ff${RESET}     - Merge with commit history"
    echo "   ${BLUE}git merge --abort${RESET}     - Abort merge in conflict"
    
    echo -e "\n${GREEN}${BOLD}3. Rebasing:${RESET}"
    echo "   ${BLUE}git rebase <branch>${RESET}   - Reapply commits on top"
    echo "   ${BLUE}git rebase -i${RESET}         - Interactive rebase"
    
    echo -e "\n${GREEN}${BOLD}4. Stashing:${RESET}"
    echo "   ${BLUE}git stash${RESET}             - Save changes temporarily"
    echo "   ${BLUE}git stash list${RESET}        - List stashes"
    echo "   ${BLUE}git stash pop${RESET}         - Apply and remove stash"
    echo "   ${BLUE}git stash apply${RESET}       - Apply stash"
    echo "   ${BLUE}git stash drop${RESET}        - Delete stash"
    
    echo -e "\n${GREEN}${BOLD}5. Practice Exercise:${RESET}"
    echo "   Let's create a feature branch:"
    read -p "Enter feature name (e.g., 'add-login'): " feature_name
    
    cd "$REPO_DIR" || exit
    git checkout -b "feature/$feature_name"
    echo "# Feature: $feature_name" >> "notes/feature-$feature_name.md"
    echo "\nCreated on: $(date)" >> "notes/feature-$feature_name.md"
    
    git add "notes/feature-$feature_name.md"
    git commit -m "Add feature: $feature_name"
    
    success "Created feature branch: feature/$feature_name"
    info "Switch back to main: ${CYAN}git checkout main${RESET}"
    info "Merge feature: ${CYAN}git merge feature/$feature_name${RESET}"
}

# Remote Operations
learn_remote_ops() {
    subsection "${CLOUD} REMOTE OPERATIONS" "Work with GitHub and other remotes"
    
    echo -e "\n${GREEN}${BOLD}1. Remote Repository Setup:${RESET}"
    echo "   ${BLUE}git remote add origin <url>${RESET} - Add remote"
    echo "   ${BLUE}git remote -v${RESET}          - List remotes"
    echo "   ${BLUE}git remote remove origin${RESET} - Remove remote"
    echo "   ${BLUE}git remote set-url origin <url>${RESET} - Change URL"
    
    echo -e "\n${GREEN}${BOLD}2. Push & Pull:${RESET}"
    echo "   ${BLUE}git push origin main${RESET}   - Push to remote"
    echo "   ${BLUE}git push -u origin main${RESET} - Push and set upstream"
    echo "   ${BLUE}git pull origin main${RESET}   - Fetch and merge"
    echo "   ${BLUE}git fetch origin${RESET}       - Download without merge"
    echo "   ${BLUE}git pull --rebase${RESET}      - Pull with rebase"
    
    echo -e "\n${GREEN}${BOLD}3. Working with Forks:${RESET}"
    echo "   ${BLUE}git fork${RESET}               - Create fork (GitHub CLI)"
    echo "   ${BLUE}git remote add upstream <url>${RESET} - Add original repo"
    echo "   ${BLUE}git fetch upstream${RESET}     - Get changes from source"
    echo "   ${BLUE}git merge upstream/main${RESET} - Merge upstream changes"
    
    echo -e "\n${GREEN}${BOLD}4. Tags & Releases:${RESET}"
    echo "   ${BLUE}git tag v1.0.0${RESET}         - Create tag"
    echo "   ${BLUE}git tag -a v1.0.0 -m \"msg\"${RESET} - Annotated tag"
    echo "   ${BLUE}git push origin --tags${RESET} - Push all tags"
    echo "   ${BLUE}git push origin v1.0.0${RESET} - Push specific tag"
    
    if [ -z "$GITHUB_TOKEN" ]; then
        warning "GitHub token not configured."
        read -p "Do you want to configure GitHub remote now? (y/N): " config_remote
        if [[ $config_remote =~ ^[Yy]$ ]]; then
            setup_github_remote
        fi
    fi
}

# Undo & Recovery
learn_undo_recovery() {
    subsection "${TIME} UNDO & RECOVERY" "Fix mistakes and recover lost work"
    
    echo -e "\n${RED}${BOLD}⚠️ CAUTION: Some commands rewrite history!${RESET}"
    echo "Don't use on shared branches without team coordination.\n"
    
    echo -e "${GREEN}${BOLD}1. Safe Undo (Local Only):${RESET}"
    echo "   ${BLUE}git checkout -- <file>${RESET} - Discard unstaged changes"
    echo "   ${BLUE}git restore <file>${RESET}     - Newer way to discard"
    echo "   ${BLUE}git reset HEAD <file>${RESET}  - Unstage file"
    echo "   ${BLUE}git clean -fd${RESET}          - Remove untracked files"
    
    echo -e "\n${GREEN}${BOLD}2. Commit Level Undo:${RESET}"
    echo "   ${BLUE}git commit --amend${RESET}     - Fix last commit message"
    echo "   ${BLUE}git reset --soft HEAD~1${RESET} - Undo commit, keep changes"
    echo "   ${BLUE}git reset --mixed HEAD~1${RESET} - Undo commit, unstage"
    echo "   ${BLUE}git reset --hard HEAD~1${RESET} - ⚠️ Destroy last commit"
    
    echo -e "\n${GREEN}${BOLD}3. Reflog & Recovery:${RESET}"
    echo "   ${BLUE}git reflog${RESET}             - Show ALL reference changes"
    echo "   ${BLUE}git cherry-pick <commit>${RESET} - Apply specific commit"
    echo "   ${BLUE}git revert <commit>${RESET}    - Create undo commit"
    
    echo -e "\n${GREEN}${BOLD}4. Practice Safe Undo:${RESET}"
    cd "$REPO_DIR" || exit
    
    echo "   Let's create a test file to practice:"
    echo "test undo file" > test_undo.txt
    git add test_undo.txt
    
    echo -e "\n${CYAN}Current status:${RESET}"
    git status
    
    echo -e "\n${YELLOW}Try these commands:${RESET}"
    echo "1. ${CYAN}git reset HEAD test_undo.txt${RESET} (unstage)"
    echo "2. ${CYAN}git checkout -- test_undo.txt${RESET} (discard changes)"
    echo "3. ${CYAN}rm test_undo.txt${RESET} (clean up)"
    
    read -p "Press Enter after trying commands..."
}

# Advanced Techniques
learn_advanced() {
    subsection "${CODE} ADVANCED GIT TECHNIQUES" "Power tools for professional workflows"
    
    echo -e "\n${GREEN}${BOLD}1. Interactive Rebase:${RESET}"
    echo "   ${BLUE}git rebase -i HEAD~3${RESET}  - Edit last 3 commits"
    echo "   Commands: pick, reword, edit, squash, fixup, drop"
    
    echo -e "\n${GREEN}${BOLD}2. Bisect (Debugging):${RESET}"
    echo "   ${BLUE}git bisect start${RESET}      - Start binary search"
    echo "   ${BLUE}git bisect bad${RESET}        - Mark current as bad"
    echo "   ${BLUE}git bisect good v1.0${RESET}  - Mark v1.0 as good"
    echo "   ${BLUE}git bisect reset${RESET}      - End bisect session"
    
    echo -e "\n${GREEN}${BOLD}3. Hooks & Automation:${RESET}"
    echo "   ${BLUE}.git/hooks/${RESET}           - Directory for hooks"
    echo "   ${BLUE}pre-commit${RESET}            - Run before commit"
    echo "   ${BLUE}pre-push${RESET}              - Run before push"
    
    echo -e "\n${GREEN}${BOLD}4. Worktrees:${RESET}"
    echo "   ${BLUE}git worktree add ../new-dir${RESET} - Multiple checkouts"
    
    echo -e "\n${GREEN}${BOLD}5. Submodules:${RESET}"
    echo "   ${BLUE}git submodule add <url>${RESET} - Add submodule"
    echo "   ${BLUE}git submodule update --init${RESET} - Initialize"
    
    echo -e "\n${GREEN}${BOLD}6. Filter & Clean History:${RESET}"
    echo "   ${BLUE}git filter-branch${RESET}     - Rewrite history (caution!)"
    echo "   ${BLUE}BFG Repo-Cleaner${RESET}      - Better alternative"
}

# Cheat Sheet
show_cheat_sheet() {
    subsection "${CHECK} GIT QUICK REFERENCE CHEAT SHEET"
    
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                    GIT COMMAND CHEAT SHEET                   ║
╠══════════════════════════════════════════════════════════════╣
║  SETUP & INIT                                                ║
║  ──────────────────────────────────────────────────────────  ║
║  git init                            # New local repo        ║
║  git clone <url>                     # Clone remote repo     ║
║  git config --global user.name ""    # Set name              ║
║  git config --global user.email ""   # Set email             ║
║                                                              ║
║  DAILY WORKFLOW                                              ║
║  ──────────────────────────────────────────────────────────  ║
║  git status                         # Check status           ║
║  git add <file>                     # Stage file             ║
║  git add .                          # Stage all              ║
║  git commit -m "message"            # Commit changes         ║
║  git push origin main               # Push to remote         ║
║  git pull origin main               # Pull from remote       ║
║                                                              ║
║  BRANCHING & MERGING                                         ║
║  ──────────────────────────────────────────────────────────  ║
║  git branch                         # List branches          ║
║  git branch <name>                  # Create branch          ║
║  git checkout <branch>              # Switch branch          ║
║  git checkout -b <branch>           # Create & switch        ║
║  git merge <branch>                 # Merge branch           ║
║  git branch -d <branch>             # Delete branch          ║
║                                                              ║
║  UNDO & RESET                                                ║
║  ──────────────────────────────────────────────────────────  ║
║  git reset --soft HEAD~1            # Undo commit, keep      ║
║  git reset --hard HEAD~1            # ⚠️ Destroy commit      
║  git checkout -- <file>             # Discard changes        ║
║  git revert <commit>                # Safe undo (new commit) ║
║                                                              ║
║  INSPECTION & HISTORY                                        ║
║  ──────────────────────────────────────────────────────────  ║
║  git log                           # Show history            ║
║  git log --oneline                 # Compact history         ║
║  git log --graph                   # Visual history          ║
║  git diff                          # Show changes            ║
║  git show <commit>                 # Show commit             ║
║  git blame <file>                  # Who changed what        ║
║                                                              ║
║  REMOTE OPERATIONS                                           ║
║  ──────────────────────────────────────────────────────────  ║
║  git remote -v                     # List remotes            ║
║  git remote add origin <url>       # Add remote              ║
║  git push -u origin main           # Push & set upstream     ║
║  git fetch origin                  # Download changes        ║
║  git pull --rebase                 # Pull with rebase        ║
║                                                              ║
║  STASHING                                                    ║
║  ──────────────────────────────────────────────────────────  ║
║  git stash                         # Save changes            ║
║  git stash list                    # List stashes            ║
║  git stash pop                     # Apply & remove          ║
║  git stash drop                    # Delete stash            ║
╚══════════════════════════════════════════════════════════════╝
EOF
    
    echo -e "\n${YELLOW}${BOLD}Pro Tip:${RESET} Use aliases for common commands!"
    echo "Add these to your ~/.gitconfig:"
    echo "[alias]"
    echo "  co = checkout"
    echo "  br = branch"
    echo "  ci = commit"
    echo "  st = status"
    echo "  lg = log --oneline --graph --all"
}

# Practice Exercises
practice_exercises() {
    subsection "${ROCKET} PRACTICE EXERCISES" "Hands-on practice with real scenarios"
    
    echo -e "${BOLD}Choose an exercise:${RESET}\n"
    
    echo "1) ${FOLDER} Basic Workflow"
    echo "2) ${BRANCH} Branch Management"
    echo "3) ${MERGE} Merge Conflict Resolution"
    echo "4) ${TIME} Undo Mistakes"
    echo "5) ${CLOUD} GitHub Collaboration"
    
    read -p "Select exercise (1-5): " exercise
    
    cd "$REPO_DIR" || exit
    
    case $exercise in
        1)
            echo -e "\n${GREEN}Exercise 1: Basic Workflow${RESET}"
            echo "1. Create a new file: ${CYAN}touch exercise1.txt${RESET}"
            echo "2. Add content: ${CYAN}echo 'Exercise 1' > exercise1.txt${RESET}"
            echo "3. Stage file: ${CYAN}git add exercise1.txt${RESET}"
            echo "4. Commit: ${CYAN}git commit -m 'Add exercise 1'${RESET}"
            echo "5. Check history: ${CYAN}git log --oneline${RESET}"
            ;;
        2)
            echo -e "\n${GREEN}Exercise 2: Branch Management${RESET}"
            echo "1. Create branch: ${CYAN}git checkout -b feature/exercise${RESET}"
            echo "2. Make changes: ${CYAN}echo 'New feature' > feature.txt${RESET}"
            echo "3. Commit: ${CYAN}git add . && git commit -m 'Add feature'${RESET}"
            echo "4. Switch back: ${CYAN}git checkout main${RESET}"
            echo "5. Merge: ${CYAN}git merge feature/exercise${RESET}"
            echo "6. Delete branch: ${CYAN}git branch -d feature/exercise${RESET}"
            ;;
        3)
            echo -e "\n${GREEN}Exercise 3: Merge Conflict${RESET}"
            echo "1. Create conflict:"
            echo "   ${CYAN}git checkout -b conflict-branch${RESET}"
            echo "   ${CYAN}echo 'Version A' > conflict.txt${RESET}"
            echo "   ${CYAN}git add . && git commit -m 'Version A'${RESET}"
            echo "2. Create different version:"
            echo "   ${CYAN}git checkout main${RESET}"
            echo "   ${CYAN}echo 'Version B' > conflict.txt${RESET}"
            echo "   ${CYAN}git add . && git commit -m 'Version B'${RESET}"
            echo "3. Merge and resolve: ${CYAN}git merge conflict-branch${RESET}"
            echo "4. Resolve in editor, then:"
            echo "   ${CYAN}git add conflict.txt${RESET}"
            echo "   ${CYAN}git commit -m 'Resolve conflict'${RESET}"
            ;;
        4)
            echo -e "\n${GREEN}Exercise 4: Undo Mistakes${RESET}"
            echo "1. Make mistake: ${CYAN}echo 'mistake' > undo.txt${RESET}"
            echo "2. Stage it: ${CYAN}git add undo.txt${RESET}"
            echo "3. Unstage: ${CYAN}git reset HEAD undo.txt${RESET}"
            echo "4. Discard: ${CYAN}git checkout -- undo.txt${RESET}"
            echo "5. Clean up: ${CYAN}rm undo.txt${RESET}"
            ;;
        5)
            echo -e "\n${GREEN}Exercise 5: GitHub Collaboration${RESET}"
            echo "1. Create GitHub repository"
            echo "2. Add remote: ${CYAN}git remote add origin <your-repo-url>${RESET}"
            echo "3. Push: ${CYAN}git push -u origin main${RESET}"
            echo "4. Make change locally"
            echo "5. Push changes: ${CYAN}git push${RESET}"
            ;;
        *)
            error "Invalid exercise"
            ;;
    esac
    
    echo -e "\n${YELLOW}Follow the steps above in your terminal.${RESET}"
    read -p "Press Enter when done..."
}

# Setup GitHub Remote
setup_github_remote() {
    subsection "${CLOUD} SETUP GITHUB REMOTE" "Connect your local repo to GitHub"
    
    if [ -z "$GITHUB_TOKEN" ]; then
        prompt "Enter your GitHub Personal Access Token:"
        read -s GITHUB_TOKEN
        echo
    fi
    
    if [ -z "$GITHUB_USER" ]; then
        prompt "Enter your GitHub username:"
        read GITHUB_USER
    fi
    
    # Create GitHub repository via API
    info "Creating GitHub repository..."
    
    REPO_NAME="JCA-FirstDay-$(date +%s)"
    RESPONSE=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        https://api.github.com/user/repos \
        -d "{\"name\":\"$REPO_NAME\",\"private\":true,\"description\":\"Jedan Code Academy Git Learning Repository\"}")
    
    if echo "$RESPONSE" | grep -q "clone_url"; then
        CLONE_URL=$(echo "$RESPONSE" | grep -o '"clone_url":"[^"]*"' | cut -d'"' -f4)
        success "Repository created: $CLONE_URL"
        
        # Add remote and push
        cd "$REPO_DIR" || exit
        git remote add origin "$CLONE_URL"
        git branch -M main
        git push -u origin main
        
        success "Pushed to GitHub!"
        echo -e "\n${GREEN}Your repository is now at:${RESET}"
        echo -e "${BLUE}https://github.com/$GITHUB_USER/$REPO_NAME${RESET}"
        
        save_config
    else
        error "Failed to create repository"
        echo "Response: $RESPONSE"
    fi
}

# Push to GitHub
push_to_github() {
    if git remote | grep -q origin; then
        cd "$REPO_DIR" || exit
        git push origin main
        success "Pushed changes to GitHub!"
    else
        warning "No remote repository configured."
        read -p "Do you want to set up GitHub remote now? (y/N): " setup_now
        if [[ $setup_now =~ ^[Yy]$ ]]; then
            setup_github_remote
        fi
    fi
}

# Main Menu
main_menu() {
    while true; do
        show_banner
        
        echo -e "${BG_GREEN}${BLACK}${BOLD} MAIN MENU ${RESET}"
        echo -e "${BOLD}Select your learning path:${RESET}\n"
        
        echo "1) ${DOWNLOAD} Install & Setup Git"
        echo "2) ${KEY} GitHub Token Guide"
        echo "3) ${GEAR} Configure Git"
        echo "4) ${FOLDER} Setup JCA Repository"
        echo "5) ${BOOK} Interactive Learning"
        echo "6) ${CHECK} Quick Cheat Sheet"
        echo "7) ${CLOUD} GitHub Integration"
        echo "8) ${TERMINAL} Open Git Terminal"
        echo "9) ${INFO} View Configuration"
        echo "0) ${CROSS} Exit"
        
        echo -e "\n${DIM}Repository: ${REPO_DIR}${RESET}"
        echo -e "${DIM}GitHub User: ${GITHUB_USER}${RESET}"
        
        read -p "Select option (0-9): " main_choice
        
        case $main_choice in
            1) install_git ;;
            2) github_token_guide ;;
            3) configure_git ;;
            4) setup_jca_repo ;;
            5) git_learning_module ;;
            6) show_cheat_sheet ;;
            7) setup_github_remote ;;
            8) 
                cd "$REPO_DIR" || exit
                echo -e "\n${GREEN}Opening Git terminal in repository...${RESET}"
                echo -e "${YELLOW}Type 'exit' to return to menu${RESET}"
                bash
                ;;
            9)
                echo -e "\n${BOLD}Current Configuration:${RESET}"
                echo "GitHub User: $GITHUB_USER"
                echo "User Name: $USER_NAME"
                echo "User Email: $USER_EMAIL"
                echo "Repo Dir: $REPO_DIR"
                echo "Config File: $CONFIG_FILE"
                echo "Log File: $LOG_FILE"
                ;;
            0)
                echo -e "\n${GREEN}Thank you for learning with Jedan Code Academy!${RESET}"
                echo -e "${BLUE}Remember:${RESET}"
                echo "• Practice daily"
                echo "• Use Git in real projects"
                echo "• Join our community"
                echo -e "\n${BOLD}Happy Coding!${RESET}"
                exit 0
                ;;
            *) error "Invalid selection" ;;
        esac
        
        echo -e "\n${DIM}Press Enter to continue...${RESET}"
        read -r
    done
}

# Initialize and run
main() {
    # Check if running in terminal with color support
    if [ -t 1 ]; then
        load_config
        main_menu
    else
        echo "Please run this script in a terminal with color support."
        exit 1
    fi
}

# Run main function
main
