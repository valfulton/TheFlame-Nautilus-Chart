#!/bin/bash

# Set repo path
REPO_PATH="/Users/atlanticandvine/Library/CloudStorage/OneDrive-atlanticandvine.com/AtlanticandVine/the_flame/for-github"

# Function to generate unique filename
get_unique_filename() {
    local file="$1"
    local dir="$2"
    local base=$(basename "$file")
    local name="${base%.*}"
    local ext="${base##*.}"
    local counter=1
    local new_file="$dir/$base"

    while [ -f "$new_file" ]; do
        new_file="$dir/${name}_${counter}.${ext}"
        ((counter++))
    done
    echo "$new_file"
}

# Create directories if they don't exist
mkdir -p "$REPO_PATH/logo_design/source_files"
mkdir -p "$REPO_PATH/logo_design/exports"
mkdir -p "$REPO_PATH/logo_design/mockups"
mkdir -p "$REPO_PATH/logo_design/client_feedback"
mkdir -p "$REPO_PATH/docs/latex"
mkdir -p "$REPO_PATH/docs/notes"
mkdir -p "$REPO_PATH/store/assets"
mkdir -p "$REPO_PATH/store/data"

# Move files without overwriting
for file in "$REPO_PATH"/*; do
    if [ -f "$file" ] && [ "$(basename "$file")" != "README.md" ] && [ "$(basename "$file")" != "organize_repo.sh" ] && [ "$(basename "$file")" != "push_to_github.sh" ]; then
        if [[ $file =~ \.(ai|svg)$ ]]; then
            new_file=$(get_unique_filename "$file" "$REPO_PATH/logo_design/source_files")
            mv "$file" "$new_file"
        elif [[ $file =~ \.(png|jpg|pdf)$ ]]; then
            new_file=$(get_unique_filename "$file" "$REPO_PATH/logo_design/exports")
            mv "$file" "$new_file"
        elif [[ $file =~ \.tex$ ]]; then
            new_file=$(get_unique_filename "$file" "$REPO_PATH/docs/latex")
            mv "$file" "$new_file"
        elif [[ $file =~ \.(txt|md)$ ]]; then
            new_file=$(get_unique_filename "$file" "$REPO_PATH/docs/notes")
            mv "$file" "$new_file"
        fi
    fi
done

# Create README.md ONLY if it doesn't exist
if [ ! -f "$REPO_PATH/README.md" ]; then
    cat <<EOL > "$REPO_PATH/README.md"
# The Flame Swag Store

Mockups and store for Kevin and Maile's HH50 Catamaran.

## Mockups and Purchase
Visit: [https://valfulton.github.io/TheFlame-Nautilus-Chart/store.html](logo_design/client_feedback/store.html)

## Folders
- logo_design: AI files, exports, mockups, feedback.
- docs: LaTeX and notes.
- store: Store assets.
EOL
else
    echo "README.md already exists—skipped creation."
fi

# Prompt for GitHub upload
echo "Do you want to push changes to GitHub? (y/n)"
read -r response
if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
    cd "$REPO_PATH" || { echo "Error: Cannot access $REPO_PATH"; exit 1; }
    if [ ! -d ".git" ]; then
        git init
        git remote add origin https://github.com/valfulton/TheFlame-Nautilus-Chart.git
    fi
    git add .
    git commit -m "Organized repo for The Flame swag store"
    git push -u origin main
    echo "Pushed to GitHub successfully."
else
    echo "Skipped GitHub push."
fi

echo "Repo organized successfully."