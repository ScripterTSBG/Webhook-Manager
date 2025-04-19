# Webhook Manager

A Roblox script designed to detect, block, delete, or respond to Discord webhook requests — all configurable through a sleek, draggable UI.

## 📌 Features

- ✅ **Webhook Detection**  
  Automatically intercepts any HTTP request targeting a Discord webhook.

- 🧹 **Webhook Deletion**  
  Optionally deletes the intercepted webhook to prevent future use.

- 📩 **Message Sending**  
  Sends a custom message to the webhook if enabled.

- 🚫 **Request Blocking**  
  Stops the webhook request from being sent.

- 🧑‍💻 **UI Interface**  
  Toggle UI with a hotkey and configure behaviors on-the-fly.

- 📦 **Asset Auto-Downloader**  
  Automatically downloads required UI and assets from GitHub.

## 🎮 How It Works

When an HTTP request is made to a Discord webhook URL, this script:
1. Detects the request
2. Displays a notification
3. Performs actions based on your selected toggles:
   - **Send a Message**
   - **Delete the Webhook**
   - **Block the Request**

## 🖥️ User Interface

The UI includes:
- **Home** tab for toggles (Send / Delete / Block)
- **Config** tab to set your message and hotkey
- **Credits** tab
- Custom draggable interface with tween animations
- Activates via default hotkey: `L` (can be changed)

## 🔧 Installation

1. Copy the full Lua script into your Roblox executor.
2. Script will automatically download required UI assets and inject into CoreGui.
3. Toggle UI with the hotkey (`L` by default).

## 📁 Asset Sources

- **UI Model:** [UI.rbxm](https://github.com/ScripterTSBG/Webhook-Manager/raw/refs/heads/main/UI.rbxm)  
- **Avatar Icon:** ![Webhook Icon](https://raw.githubusercontent.com/ScripterTSBG/Webhook-Manager/refs/heads/main/webhook.png)

---

Made by **Astware**
