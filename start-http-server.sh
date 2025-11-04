#!/bin/bash

# Start Google Workspace MCP Server in HTTP Mode
# For use with Gemini, web clients, and other HTTP-based MCP clients

set -e

echo "🌐 Starting Google Workspace MCP Server (HTTP Mode)"
echo "====================================================="
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
echo "🔧 Configuration:"
echo "  Client ID: ${GOOGLE_OAUTH_CLIENT_ID:0:20}..."
echo "  Email: $USER_GOOGLE_EMAIL"
echo "  OAuth 2.1: $MCP_ENABLE_OAUTH21"
echo "  Transport: HTTP"
echo "  Port: 8080"
echo ""

echo "🚀 Starting server..."
echo ""
echo "   Server will be available at:"
echo "   📍 http://localhost:8080/mcp/"
echo ""
echo "   Use this URL in your Gemini or MCP client configuration"
echo ""
echo "   Press Ctrl+C to stop the server"
echo ""

# Start the server in HTTP mode
uv run main.py --transport streamable-http --tool-tier core
