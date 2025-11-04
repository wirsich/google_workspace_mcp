# 🚀 Quick Start Guide

Your Google Workspace MCP Server is now configured and ready to use!

## ✅ Setup Complete

The following has been configured:

1. **OAuth Credentials**: Extracted from your `client_secret.json`
   - Client ID: `470800790681-uk416ol53q9ssannoumif3msnb2pf83r.apps.googleusercontent.com`
   - Stored securely in `.env` file

2. **Claude Desktop**: Updated configuration
   - Server name: `google-workspace`
   - Mode: stdio (default)
   - Tool tier: `core`

3. **Environment**: 
   - Python 3.11.9 with pyenv
   - All dependencies installed via uv
   - Virtual environment ready

## 🧪 Testing the Server

### Option 1: Test with Claude Desktop (Recommended)

1. **Restart Claude Desktop**:
   ```bash
   # Quit Claude Desktop completely
   osascript -e 'quit app "Claude"'
   
   # Wait 2 seconds
   sleep 2
   
   # Open Claude Desktop
   open -a "Claude"
   ```

2. **Check the server status**:
   - Open Claude Desktop
   - Look for "google-workspace" in your MCP servers list
   - Status should show as "Connected"

3. **Test with a query**:
   Ask Claude:
   ```
   Can you list my upcoming calendar events for this week?
   ```
   
   The first time you use it, you'll need to complete OAuth authentication.

### Option 2: Manual CLI Test

Test the server directly in your terminal:

```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp

# Run the test script
./test-connection.sh
```

This will:
- Load your environment variables
- Display your configuration
- Start the server in stdio mode
- Press Ctrl+C when done

### Option 3: HTTP Mode (for Gemini or web clients)

Start the server in HTTP mode:

```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp

# Run the HTTP server
./start-http-server.sh
```

Server will be available at: **http://localhost:8000/mcp/**

## 🔐 OAuth Authentication Flow

When you first use a Google Workspace tool:

1. The server will provide an **authorization URL**
2. Open the URL in your browser
3. Sign in with **stephan@wirsi.ch**
4. Review and approve the permissions
5. Credentials will be saved to `~/.google_workspace_mcp/credentials/`
6. Future requests will use the saved credentials automatically

## 📋 Available Commands

### Start Server (stdio mode for Claude)
```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp
uv run main.py --tool-tier core
```

### Start Server (HTTP mode for Gemini/web)
```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp
uv run main.py --transport streamable-http --tool-tier core
```

### Test with different tool tiers
```bash
# Essential tools only
uv run main.py --tool-tier core

# Core + additional features
uv run main.py --tool-tier extended

# All available tools
uv run main.py --tool-tier complete
```

### Test specific services
```bash
# Only Gmail and Calendar
uv run main.py --tools gmail calendar --tool-tier core

# Only Drive and Docs
uv run main.py --tools drive docs --tool-tier core
```

## 🔧 Configuration Files

### Environment Variables (`.env`)
```
/Users/wirsich/workspace/ai-projects/google-workspace-mcp/.env
```

Contains your OAuth credentials. **Never commit this file!**

### Claude Desktop Config
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

Configuration for Claude Desktop's MCP integration.

### OAuth Credentials Storage
```
~/.google_workspace_mcp/credentials/
```

Stored credentials after OAuth authentication. Auto-refreshed every 30 minutes.

## 🐛 Troubleshooting

### Server not connecting in Claude Desktop

1. Check Claude Desktop logs:
   ```bash
   tail -f ~/Library/Logs/Claude/mcp*.log
   ```

2. Verify configuration:
   ```bash
   cat ~/Library/Application\ Support/Claude/claude_desktop_config.json | grep -A 20 google-workspace
   ```

3. Test server manually:
   ```bash
   cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp
   ./test-connection.sh
   ```

### "API has not been used in project" error

Enable the specific API in Google Cloud Console:
- Visit: https://console.cloud.google.com/apis/library
- Search for the API mentioned in the error
- Click "Enable"
- Wait a few minutes for activation

### "Invalid grant" or "Token expired"

Reset credentials:
```bash
rm -rf ~/.google_workspace_mcp/credentials/
```

Then restart Claude Desktop and complete OAuth flow again.

### OAuth redirect issues

Make sure you created **"Web Application"** credentials (not Desktop Application).

The redirect URI should be: `http://localhost:8000/oauth2callback`

## 📚 Next Steps

1. **Restart Claude Desktop** and test the connection
2. **Try example queries** in Claude
3. **Enable additional APIs** if needed for specific features
4. **Explore different tool tiers** to find what works best for you

## 🎯 Example Queries for Claude

Try these queries to test different Google Workspace features:

**Gmail:**
```
Search my Gmail for emails from the last 7 days about "project update"
```

**Calendar:**
```
Show me my calendar events for tomorrow
```

**Drive:**
```
List my recent Google Drive documents
```

**Docs:**
```
Create a new Google Doc called "Meeting Notes"
```

**Multiple services:**
```
Find emails about "budget" and create a new Google Doc with a summary
```

## 📖 Full Documentation

For complete setup instructions and advanced configuration:
- See `SETUP_GUIDE.md` in this directory
- Visit: https://github.com/taylorwilsdon/google_workspace_mcp

---

**Ready to test!** 🎉

Run `./test-connection.sh` or restart Claude Desktop to begin.
