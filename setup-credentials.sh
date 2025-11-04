#!/bin/bash

# Google Workspace MCP Server Setup Script
# This script helps you configure OAuth credentials and update Claude Desktop configuration

set -e

echo "🔧 Google Workspace MCP Server Setup"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ]; then
    echo "❌ Error: Please run this script from the google-workspace-mcp directory"
    exit 1
fi

# Step 1: Check for client_secret.json
echo "📋 Step 1: Checking for OAuth credentials..."
if [ -f "$HOME/.client_secret.json" ]; then
    echo "✅ Found client_secret.json in home directory"
    CLIENT_SECRET_PATH="$HOME/.client_secret.json"
elif [ -f "client_secret.json" ]; then
    echo "✅ Found client_secret.json in project directory"
    CLIENT_SECRET_PATH="client_secret.json"
else
    echo "❌ OAuth credentials not found!"
    echo ""
    echo "Please download your OAuth 2.0 Client credentials from:"
    echo "https://console.cloud.google.com/apis/credentials"
    echo ""
    echo "Instructions:"
    echo "1. Click 'Create Credentials' → 'OAuth Client ID'"
    echo "2. Choose 'Desktop Application' as the application type"
    echo "3. Download the JSON file"
    echo "4. Save it as 'client_secret.json' in this directory or your home directory"
    echo ""
    exit 1
fi

# Step 2: Extract credentials and create .env file
echo ""
echo "📝 Step 2: Creating .env file..."

if [ ! -f ".env" ]; then
    # Extract client_id and client_secret from JSON
    CLIENT_ID=$(python3 -c "import json; print(json.load(open('$CLIENT_SECRET_PATH'))['installed']['client_id'])")
    CLIENT_SECRET=$(python3 -c "import json; print(json.load(open('$CLIENT_SECRET_PATH'))['installed']['client_secret'])")
    
    # Create .env file
    cat > .env << EOF
GOOGLE_OAUTH_CLIENT_ID="$CLIENT_ID"
GOOGLE_OAUTH_CLIENT_SECRET="$CLIENT_SECRET"
OAUTHLIB_INSECURE_TRANSPORT=1
USER_GOOGLE_EMAIL="stephan@wirsi.ch"
MCP_ENABLE_OAUTH21=true
EOF
    
    echo "✅ Created .env file with OAuth credentials"
    
    # Add .env to .gitignore if not already there
    if ! grep -q "^\.env$" .gitignore 2>/dev/null; then
        echo ".env" >> .gitignore
        echo "✅ Added .env to .gitignore"
    fi
else
    echo "⚠️  .env file already exists, skipping..."
fi

# Step 3: Update Claude Desktop configuration
echo ""
echo "🖥️  Step 3: Updating Claude Desktop configuration..."

CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

if [ ! -f "$CLAUDE_CONFIG" ]; then
    echo "❌ Claude Desktop config not found at: $CLAUDE_CONFIG"
    exit 1
fi

# Backup existing config
cp "$CLAUDE_CONFIG" "$CLAUDE_CONFIG.backup.$(date +%s)"
echo "✅ Backed up existing Claude Desktop configuration"

# Read current credentials
source .env

# Create updated configuration
python3 << PYTHON_SCRIPT
import json
import os

config_path = os.path.expanduser("~/Library/Application Support/Claude/claude_desktop_config.json")
project_path = os.getcwd()

# Read existing config
with open(config_path, 'r') as f:
    config = json.load(f)

# Add Google Workspace MCP server
if 'mcpServers' not in config:
    config['mcpServers'] = {}

config['mcpServers']['google-workspace'] = {
    "command": "uv",
    "args": ["run", "main.py", "--tool-tier", "core"],
    "env": {
        "GOOGLE_OAUTH_CLIENT_ID": "$GOOGLE_OAUTH_CLIENT_ID",
        "GOOGLE_OAUTH_CLIENT_SECRET": "$GOOGLE_OAUTH_CLIENT_SECRET",
        "OAUTHLIB_INSECURE_TRANSPORT": "1",
        "USER_GOOGLE_EMAIL": "stephan@wirsi.ch",
        "MCP_ENABLE_OAUTH21": "true"
    }
}

# Write updated config
with open(config_path, 'w') as f:
    json.dump(config, f, indent=2)

print("✅ Updated Claude Desktop configuration")
PYTHON_SCRIPT

echo ""
echo "✨ Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Restart Claude Desktop"
echo "2. The Google Workspace MCP server should appear in your MCP servers list"
echo "3. Try asking Claude to access your Google Workspace data"
echo ""
echo "To test the server manually, run:"
echo "  cd $(pwd)"
echo "  uv run main.py --tool-tier core"
echo ""
