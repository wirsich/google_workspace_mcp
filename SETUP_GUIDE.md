# Google Workspace MCP Server - Local Setup Guide

This guide will help you set up the Google Workspace MCP server to work with Claude Desktop and other MCP clients.

## Prerequisites

- ✅ Python 3.11.9 (managed by pyenv)
- ✅ uv package manager
- ✅ Google Cloud account
- ✅ Claude Desktop installed

## Quick Setup

### 1. Create OAuth 2.0 Credentials

1. Open the [Google Cloud Console Credentials page](https://console.cloud.google.com/apis/credentials)
2. Create a new project or select an existing one
3. Click **"Create Credentials"** → **"OAuth Client ID"**
4. Choose **"Desktop Application"** as the application type
5. Give it a name (e.g., "Google Workspace MCP Client")
6. Click **"Create"**
7. Download the JSON file by clicking the download button (↓)
8. Save it as `client_secret.json` in one of these locations:
   - `~/client_secret.json` (home directory), OR
   - `/Users/wirsich/workspace/ai-projects/google-workspace-mcp/client_secret.json` (project directory)

### 2. Enable Required Google APIs

Enable the following APIs in your Google Cloud project:

- [Google Calendar API](https://console.cloud.google.com/flows/enableapi?apiid=calendar-json.googleapis.com)
- [Google Drive API](https://console.cloud.google.com/flows/enableapi?apiid=drive.googleapis.com)
- [Gmail API](https://console.cloud.google.com/flows/enableapi?apiid=gmail.googleapis.com)
- [Google Docs API](https://console.cloud.google.com/flows/enableapi?apiid=docs.googleapis.com)
- [Google Sheets API](https://console.cloud.google.com/flows/enableapi?apiid=sheets.googleapis.com)
- [Google Slides API](https://console.cloud.google.com/flows/enableapi?apiid=slides.googleapis.com)
- [Google Forms API](https://console.cloud.google.com/flows/enableapi?apiid=forms.googleapis.com)
- [Google Tasks API](https://console.cloud.google.com/flows/enableapi?apiid=tasks.googleapis.com)
- [Google Chat API](https://console.cloud.google.com/flows/enableapi?apiid=chat.googleapis.com)
- [Google Custom Search API](https://console.cloud.google.com/flows/enableapi?apiid=customsearch.googleapis.com)

### 3. Run the Setup Script

```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp
./setup-credentials.sh
```

This script will:
- ✅ Check for your `client_secret.json` file
- ✅ Extract the OAuth credentials
- ✅ Create a `.env` file with your configuration
- ✅ Update Claude Desktop's configuration
- ✅ Back up your existing Claude Desktop config

### 4. Restart Claude Desktop

1. Quit Claude Desktop completely (Cmd+Q or right-click → Quit)
2. Restart Claude Desktop
3. Look for "google-workspace" in the MCP servers list
4. The server should show as "Connected"

## Testing the Connection

### Manual Test (CLI)

Test the server directly in your terminal:

```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp

# Test in stdio mode (default for Claude Desktop)
uv run main.py --tool-tier core

# Test in HTTP mode (for web clients like Gemini)
uv run main.py --transport streamable-http --port 8000
```

### Test with Claude Desktop

Open Claude Desktop and try these example queries:

```
Can you list my upcoming calendar events for this week?
```

```
Search my Gmail for emails from the last 7 days about "project update"
```

```
Show me my recent Google Drive documents
```

## Tool Tiers

The MCP server supports different tool tiers for different use cases:

### Core Tier (Recommended for most users)
Essential tools for everyday tasks:
```bash
uv run main.py --tool-tier core
```

Includes: Gmail (search, read, send), Calendar (list, get, create), Drive (search, get content), Docs (get, create), Sheets (read, modify), and more.

### Extended Tier
Core tools plus management features:
```bash
uv run main.py --tool-tier extended
```

Adds: Gmail labels, folder management, batch operations, advanced search, and more.

### Complete Tier
All available tools including advanced features:
```bash
uv run main.py --tool-tier complete
```

Adds: Comments, headers/footers, publishing settings, administrative functions.

## Configuration Files

### `.env` File
Located at: `/Users/wirsich/workspace/ai-projects/google-workspace-mcp/.env`

Contains your OAuth credentials and configuration:
```bash
GOOGLE_OAUTH_CLIENT_ID="your-client-id.apps.googleusercontent.com"
GOOGLE_OAUTH_CLIENT_SECRET="your-secret"
OAUTHLIB_INSECURE_TRANSPORT=1
USER_GOOGLE_EMAIL="stephan@wirsi.ch"
MCP_ENABLE_OAUTH21=true
```

**⚠️ Security Note:** Never commit the `.env` file to version control!

### Claude Desktop Configuration
Located at: `~/Library/Application Support/Claude/claude_desktop_config.json`

The setup script adds this entry to your config:
```json
{
  "mcpServers": {
    "google-workspace": {
      "command": "uv",
      "args": ["run", "main.py", "--tool-tier", "core"],
      "env": {
        "GOOGLE_OAUTH_CLIENT_ID": "...",
        "GOOGLE_OAUTH_CLIENT_SECRET": "...",
        "OAUTHLIB_INSECURE_TRANSPORT": "1",
        "USER_GOOGLE_EMAIL": "stephan@wirsi.ch",
        "MCP_ENABLE_OAUTH21": "true"
      }
    }
  }
}
```

## OAuth Authentication Flow

The first time you use a Google Workspace tool:

1. The MCP server will provide an authorization URL
2. Open the URL in your browser
3. Sign in with your Google Workspace account (stephan@wirsi.ch)
4. Review and approve the requested permissions
5. The credentials will be saved to `~/.google_workspace_mcp/credentials/`
6. Future requests will use these saved credentials automatically

Token lifetime: 30 minutes (automatically refreshed)

## Troubleshooting

### "OAuth credentials not found"
- Make sure you downloaded the `client_secret.json` file
- Check that it's in the correct location (home or project directory)
- Run the setup script again: `./setup-credentials.sh`

### "API has not been used in project"
- Visit the Google Cloud Console
- Enable the specific API that's causing the error
- Wait a few minutes for the API to become active

### "Server not connecting in Claude Desktop"
- Check the Claude Desktop logs: `~/Library/Logs/Claude/mcp*.log`
- Verify the configuration in `~/Library/Application Support/Claude/claude_desktop_config.json`
- Try running the server manually to see error messages: `uv run main.py --tool-tier core`

### "Invalid grant" or "Token expired"
- Delete the credentials folder: `rm -rf ~/.google_workspace_mcp/credentials/`
- Restart Claude Desktop
- Complete the OAuth flow again

## Using with Other MCP Clients

### For Gemini (Google AI Studio)

The MCP server can also work with Gemini using HTTP transport mode:

1. Start the server in HTTP mode:
```bash
cd /Users/wirsich/workspace/ai-projects/google-workspace-mcp
uv run main.py --transport streamable-http --port 8000
```

2. Configure your Gemini client to connect to: `http://localhost:8000/mcp/`

### For Custom Applications

See the [FastMCP documentation](https://github.com/jlowin/fastmcp) for integrating with custom applications.

## Project Structure

```
google-workspace-mcp/
├── .env                    # Your OAuth credentials (gitignored)
├── .env.template           # Template for credentials
├── setup-credentials.sh    # Setup script
├── SETUP_GUIDE.md         # This file
├── pyproject.toml         # Project dependencies
├── main.py                # Server entry point
├── auth/                  # Authentication modules
├── core/                  # Core MCP server functionality
├── gcalendar/            # Google Calendar tools
├── gdrive/               # Google Drive tools
├── gmail/                # Gmail tools
├── gdocs/                # Google Docs tools
├── gsheets/              # Google Sheets tools
├── gslides/              # Google Slides tools
├── gforms/               # Google Forms tools
├── gtasks/               # Google Tasks tools
├── gchat/                # Google Chat tools
└── gsearch/              # Google Custom Search tools
```

## Additional Resources

- [Official Repository](https://github.com/taylorwilsdon/google_workspace_mcp)
- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [FastMCP Documentation](https://github.com/jlowin/fastmcp)
- [Google Workspace APIs](https://developers.google.com/workspace)

## Support

For issues or questions:
- Check the [GitHub Issues](https://github.com/taylorwilsdon/google_workspace_mcp/issues)
- Review the [README](https://github.com/taylorwilsdon/google_workspace_mcp#readme)
- Consult the [FAQ](https://workspacemcp.com)
