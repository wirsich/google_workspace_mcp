#!/bin/bash

# Test Google Workspace MCP Server Connection
# This script tests the server in different modes

set -e

echo "🧪 Testing Google Workspace MCP Server"
echo "========================================"
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
echo "📋 Testing server help output..."
uv run main.py --help
echo ""

echo "🔧 Configuration:"
echo "  Client ID: ${GOOGLE_OAUTH_CLIENT_ID:0:20}..."
echo "  Email: $USER_GOOGLE_EMAIL"
echo "  OAuth 2.1: $MCP_ENABLE_OAUTH21"
echo ""

echo "🚀 Starting server in stdio mode (core tier)..."
echo "   Press Ctrl+C to stop the server"
echo ""
echo "   When the server is running, you can test it by:"
echo "   1. Checking if it connects without errors"
echo "   2. The first tool call will trigger OAuth authentication"
echo ""

# Start the server
uv run main.py --tool-tier core
