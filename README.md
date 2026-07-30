# 🚀 Nutanix AI Tutorials

A pre-configured AI lab environment using VS Code Dev Containers to learn Nutanix Enterprise AI.

---

## 📋 Prerequisites

Install these tools before proceeding:

1. **[Visual Studio Code](https://www.google.com/search?q=https://code.visualstudio.com/)**
2. **[VS Code Dev Containers Extension](https://www.google.com/search?q=vscode:extension/ms-vscode-remote.remote-containers)**
3. **[Rancher Desktop](https://www.google.com/search?q=https://rancherdesktop.io/)** (Tested container engine)

---

## ⚙️ Required Rancher Desktop Settings

Launch **Rancher Desktop** and ensure these settings are set before opening VS Code:

### 1. Configuration

* Go to **Preferences** ➔ **Container Engine** (or **Virtual Machine**).
* Set engine to **`dockerd (moby)`** *(Required for Dev Containers)*.

* Go to **Preferences** ➔ **Kubernetes**.
* **Uncheck "Enable Kubernetes"** *(Frees up RAM and CPU)*.

```
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

* Go to **Preferences** ➔ **Application** ➔ **Environment / Supporting Utilities** ➔ **Automatic**.

### 3. Elevated Privileges
* Go to **Preferences** ➔ **Application** ➔ **General**
* Enable **Administrative Access / Symlinks** so `docker` CLI commands work globally.

---

## 🚀 How to Launch

### Option 1: 1-Click Launch (Recommended for beginners)

Click the link below to clone and open directly in VS Code:

👉 **[![Launch Environment in VS Code](https://img.shields.io/static/v1?label=Dev%20Container\&message=Open%20in%20VS%20Code\&color=007ACC\&logo=visualstudiocode\&logoColor=white)](https://vscode.dev/redirect?url=vscode://vscode.git/clone?url=https://github.com/nutanixdev/nai-tutorials)**

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

```
[><] Dev Container: Nutanix AI Lab

```

Open the terminal inside VS Code (`Ctrl + ~` or `Terminal -> New Terminal`) to start!
