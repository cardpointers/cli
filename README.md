<p align="center">
  <strong>💳 CardPointers CLI</strong><br>
  <em>Your credit card rewards, right in your terminal.</em>
</p>

<p align="center">
  <a href="https://github.com/cardpointers/cli/releases"><img alt="Release" src="https://img.shields.io/github/v/release/cardpointers/cli?style=flat-square&color=BF45F5"></a>
  <a href="https://www.npmjs.com/package/@cardpointers/cli"><img alt="npm" src="https://img.shields.io/npm/v/@cardpointers/cli?style=flat-square&color=4172F6"></a>
  <a href="https://github.com/cardpointers/cli/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/cardpointers/cli?style=flat-square"></a>
</p>

---

CardPointers CLI lets you manage your [CardPointers](https://cardpointers.com) wallet from the command line — get card recommendations, browse your offers, search for deals, and more. Powered by the [CardPointers MCP API](https://mcp.cardpointers.com/mcp).

> **Requires a [CardPointers+](https://cardpointers.com/pro/) (Pro) subscription.**

## Install

Choose your preferred method:

### Homebrew (macOS/Linux)

```bash
brew tap cardpointers/tap
brew install cardpointers
```

### npm

```bash
npm install -g @cardpointers/cli
```

### Quick install script

```bash
curl -fsSL https://raw.githubusercontent.com/cardpointers/cli/main/install.sh | bash
```

### Manual download

```bash
curl -fsSL https://github.com/cardpointers/cli/releases/latest/download/cardpointers -o cardpointers
chmod +x cardpointers
sudo mv cardpointers /usr/local/bin/
```

## Quick start

### 1. Log in

```bash
cardpointers login
```

Sign in with email/password, or use the browser flow for Apple, Google, or passkey authentication.

### 2. Get card recommendations

```bash
# Best card for a category
cardpointers recommend supermarket

# Best card for a specific merchant
cardpointers recommend --merchant "whole foods"

# Include estimated spend for value calculation
cardpointers recommend dining --amount 75
```

### 3. View your cards

```bash
# Show approved cards
cardpointers cards

# Filter by bank
cardpointers cards --bank chase

# Show all cards (including closed/denied)
cardpointers cards --status all
```

### 4. Browse your offers

```bash
# Active offers
cardpointers offers

# Expiring soon (within 7 days)
cardpointers offers --expiring

# Filter by bank or card
cardpointers offers --bank amex
cardpointers offers --card "gold"

# Only favorites
cardpointers offers --favorite
```

### 5. Search offers

```bash
cardpointers search "streaming"
cardpointers search "whole foods" --favorite
```

## All commands

| Command | Description |
|---------|-------------|
| `login` | Authenticate (email/password or browser OAuth) |
| `logout` | Clear saved credentials |
| `status` | Show account info and connection status |
| `recommend <category>` | Get best card for a purchase category |
| `cards` | List your wallet cards |
| `offers` | List your active offers |
| `search <query>` | Search offers by keyword |
| `ping` | Test API connection |
| `tools` | List available MCP tools |

Run `cardpointers help` or `cardpointers <command> --help` for full option details.

## Configuration

| Item | Location |
|------|----------|
| Auth token | `~/.cardpointers/config` |
| User info | `~/.cardpointers/user.json` |

Override the API endpoint with:

```bash
export CARDPOINTERS_API=https://mcp.cardpointers.com
```

## Requirements

- **bash** (macOS/Linux — Windows via WSL)
- **curl**
- **jq**

## What is CardPointers?

[CardPointers](https://cardpointers.com) helps you maximize your credit card rewards by telling you which card to use for every purchase. Available on [iOS](https://apps.apple.com/app/cardpointers/id1472875808), [Android](https://play.google.com/store/apps/details?id=com.cardpointers.app), and as a [browser extension](https://cardpointers.com/extension/) for Chrome, Firefox, Safari, and Edge.

The CLI brings your wallet to the terminal — perfect for quick lookups, scripting, and AI agent integrations via the [MCP protocol](https://mcp.cardpointers.com/mcp).

## MCP integration

CardPointers CLI talks to the same [MCP (Model Context Protocol)](https://mcp.cardpointers.com/mcp) server that powers integrations with Claude, ChatGPT, and other AI assistants. You can use the CLI as a standalone tool or as part of an AI agent workflow.

## Contributing

Issues and pull requests are welcome! Please open an issue first to discuss what you'd like to change.

## License

[MIT](LICENSE) © CardPointers

---

<p align="center">
  <a href="https://cardpointers.com">cardpointers.com</a> · <a href="https://mcp.cardpointers.com/mcp">MCP API</a> · <a href="https://twitter.com/cardaborpoints">@cardpointers</a>
</p>
