#!/bin/bash

# Run OAuth Server for Authentication
# This script keeps the server running so you can complete OAuth authentication

set -e

echo "🔐 Starting Google Workspace MCP Server for OAuth Authentication"
echo "================================================================"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
    echo "✅ Loaded environment variables from .env"
else
    echo "❌ .env file not found!"
    exit 1
fi

echo ""
echo "🔧 OAuth Configuration:"
echo "  Client ID: ${GOOGLE_OAUTH_CLIENT_ID:0:20}..."
echo "  Email: $USER_GOOGLE_EMAIL"
echo "  OAuth 2.1: $MCP_ENABLE_OAUTH21"
echo "  Redirect URI: http://localhost:8000/oauth2callback"
echo ""
echo "📝 Important: Make sure this redirect URI is configured in your"
echo "   Google Cloud Console OAuth 2.0 Client ID settings:"
echo "   https://console.cloud.google.com/apis/credentials"
echo ""
echo "🚀 Starting server..."
echo "   The server will stay running until you press Ctrl+C"
echo "   This allows you to complete the OAuth authentication flow"
echo ""

# Start the server (will keep running)
uv run main.py --tool-tier core
