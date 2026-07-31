# 🚀 Nutanix AI Tutorials

A pre-configured AI lab environment using VS Code Dev Containers to learn Nutanix Enterprise AI.

### 🌐 What's Included Out of the Box?

* **OpenCode:** Accessible directly from the VS Code terminal for command-line AI interactions and code generation.
* **Open WebUI:** Provides a clean graphical interface for interacting with models. It automatically maps to **`http://localhost:8080`** on your machine (or automatically assigns a dynamic port if `8080` is already in use). Check the VS Code **Ports** tab to view the active URL.


---

## 📋 Prerequisites

Install these tools before proceeding:

1. **[Visual Studio Code](https://code.visualstudio.com/)**
2. **[VS Code Dev Containers Extension](https://vscode.dev/redirect?url=vscode:extension/ms-vscode-remote.vscode-remote-extensionpack)**
3. **[Rancher Desktop](https://rancherdesktop.io/)** (Tested container engine)

> **Note:** If you are a Nutanix employee, connect to the VPN.

---

## ⚙️ Required Rancher Desktop Settings

Launch **Rancher Desktop** and ensure these settings are set before opening VS Code:

### 1. Configuration

* Go to **Preferences** ➔ **Container Engine** (or **Virtual Machine**).
* Set engine to **`dockerd (moby)`** *(Required for Dev Containers)*.

* Go to **Preferences** ➔ **Kubernetes**.
* (Optional) **Uncheck "Enable Kubernetes"** *(Frees up RAM and CPU)*.

```text
┌─────────────────────────────────────────────────────────┐
│ Rancher Desktop Preferences                             │
├─────────────────────────────────────────────────────────┤
│ Container Engine:                                       │
│  (●) dockerd (moby)  <-- MUST BE SELECTED               │
│  ( ) containerd                                         │
│                                                         │
│ Kubernetes:                                             │
│  [ ] Enable Kubernetes  <-- Uncheck to save resources   │
└─────────────────────────────────────────────────────────┘

```

### 2. Path Integration

* Go to **Preferences** ➔ **Application** ➔ **Environment / Supporting Utilities**
* Set **Configure PATH to "Automatic"**.

---

## 🚀 How to Launch

### Option 1: 1-Click Launch (Recommended for beginners)

Click the link below to clone and open directly in VS Code:

👉 **[![Launch Environment in VS Code](https://img.shields.io/static/v1?label=Dev%20Container\&message=Open%20in%20VS%20Code\&color=007ACC\&logo=visualstudiocode\&logoColor=white)](https://vscode.dev/redirect?url=vscode://vscode.git/clone?url=https://github.com/nutanixdev/nai-tutorials)**

> **Note:** Select a local folder where to clone the repository. When prompted with opening the repository, click **Open** (maybe you need to do it twice). Click **"Reopen in Container"** when prompted in the bottom-right corner.

### Option 2: Manual VS Code Setup

1. Open **VS Code**.
2. Press `F1` (or `Cmd+Shift+P` / `Ctrl+Shift+P`).
3. Select **`Git: Clone`**
4. Paste repository URL: **[https://github.com/nutanixdev/nai-tutorials.git](https://github.com/nutanixdev/nai-tutorials.git)**

> **Note:** If you already cloned the repo locally, open the folder in VS Code and click **"Reopen in Container"** when prompted in the bottom-right corner.

---

## ⚠️ OS Gotchas

### 🪟 Windows

* **WSL 2 Required:** Run `wsl --install` in Admin PowerShell if Rancher prompts you, then reboot.
* **Performance:** Always use **Option 1 (Container Volume)** to prevent file access slowness between Windows and Linux containers.

### 🍏 macOS (Apple Silicon M-Series)

* **Rosetta 2:** Enable Rosetta support under Rancher **Preferences** ➔ **Virtual Machine** for maximum performance.
* **Socket Permissions:** Allow Rancher Desktop administrator credentials if prompted to setup `/var/run/docker.sock`.

---

## 🎯 Success Check

Look at the **bottom-left corner** of VS Code. When the build finishes, you will see a blue/green badge:

```text
[><] Dev Container: Nutanix Tutorials

```

---

Open the terminal inside VS Code (`Ctrl + ~` or `Terminal -> New Terminal`) to start!
