<div align="center">

# 🚀 **CDA Prod Dev Shell**

[![Build and Push Workspace Shell Image](https://github.com/Cdaprod/dockerized-dev-shell/actions/workflows/docker-build.yml/badge.svg)](https://github.com/Cdaprod/dockerized-dev-shell/actions/workflows/docker-build.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/cdaprod/dev-shell?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/cdaprod/dev-shell)
[![Docker Image Size](https://img.shields.io/docker/image-size/cdaprod/dev-shell/latest?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/r/cdaprod/dev-shell)

## *The Ultimate Dockerized Development Environment*

<p>
  <a href="https://youtube.com/@Cdaprod">
    <img src="https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube Channel" />
  </a>
  <a href="https://twitter.com/cdasmktcda">
    <img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter Follow" />
  </a>
  <a href="https://www.linkedin.com/in/cdasmkt">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" />
  </a>
  <a href="https://github.com/Cdaprod">
    <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub followers" />
  </a>
  <a href="https://sanity.cdaprod.dev">
    <img src="https://img.shields.io/badge/Blog-FF5722?style=for-the-badge&logo=blogger&logoColor=white" alt="Personal Blog" />
  </a>
</p>

</div>

-----

## 🎯 **What’s This About?**

Tired of spending hours setting up your development environment? **Say goodbye to “it works on my machine”** and hello to instant, consistent, and powerful development environments!

This is a **multi-stage Docker image** that gives you a **fully-loaded development shell** with all the modern tools you need, ready to go in seconds.

## ✨ **What You Get Out of the Box**

### 🔧 **Modern CLI Tools**

- **Zsh** with Oh My Zsh and the **Agnoster theme**
- **Neovim** with sensible defaults
- **Tmux** for terminal multiplexing
- **FZF** for fuzzy finding everything
- **Ripgrep** (`rg`) for blazing fast search
- **Bat** for syntax-highlighted file viewing
- **Exa** for beautiful directory listings
- **Fd** for lightning-fast file finding

### 🚀 **Developer Experience**

- **Auto-suggestions** and **syntax highlighting** in zsh
- **Git integration** with useful aliases
- **Docker & Docker Compose** plugin support
- **Python development** tools pre-installed
- **Persistent history** across sessions
- **Smart completions** for everything

### 🎨 **Customization Ready**

- **Non-root user** (`appuser`) for security
- **Volume mounting** for your projects
- **Extensible** configuration
- **Multi-architecture** support (AMD64 & ARM64)

-----

## 🏃‍♂️ **Quick Start**

### **One-Line Magic** ✨

```bash
docker run -it --rm -v $(pwd):/home/appuser/workspace cdaprod/dev-shell:latest
```

### **Development Mode** 🔥

```bash
# Mount your entire project and start coding
docker run -it --rm \
  -v $(pwd):/home/appuser/workspace \
  -v ~/.ssh:/home/appuser/.ssh:ro \
  -v ~/.gitconfig:/home/appuser/.gitconfig:ro \
  cdaprod/dev-shell:latest
```

### **Persistent Container** 🏠

```bash
# Create a named container for long-term use
docker run -it --name my-dev-shell \
  -v my-projects:/home/appuser/workspace \
  cdaprod/dev-shell:latest

# Restart anytime
docker start -ai my-dev-shell
```

-----

## 🛠️ **Manual Build & Push Script**

For those who want to build locally or understand the process:

```bash
#!/bin/bash

# 🔨 Build the workspace shell image
docker build -t cdaprod/dev-shell:latest -f Dockerfile .

# 🏷️ Tag with additional version if needed
docker tag cdaprod/dev-shell:latest cdaprod/dev-shell:v$(date +%Y.%m.%d)

# 🔑 Login to Docker Hub (if not already logged in)
docker login

# 🚀 Push to Docker Hub
docker push cdaprod/dev-shell:latest
docker push cdaprod/dev-shell:v$(date +%Y.%m.%d)

# 🧪 Test the image locally
echo "🧪 Testing the image locally..."
docker run -it --rm cdaprod/dev-shell:latest

# 📁 Test with mounted workspace
echo "📁 Running with mounted workspace..."
docker run -it --rm -v $(pwd):/home/appuser/workspace cdaprod/dev-shell:latest
```

-----

## 🏗️ **Architecture**

This image uses **multi-stage builds** for optimization:

1. **Base Stage** → Essential system packages & Python
1. **DevShell Stage** → Zsh, Oh My Zsh, plugins, and CLI tools
1. **Runtime Ready** → Clean, optimized final image

```dockerfile
# Simplified view of the magic
FROM python:3.11-slim-bookworm AS base
# Install system essentials...

FROM base AS devshell  
# Setup zsh, plugins, and dev tools...

# Result: A lean, mean, development machine! 🚀
```

-----

## 🎨 **Customization Examples**

### **Add Your Own Tools**

```dockerfile
FROM cdaprod/dev-shell:latest
USER root
RUN apt-get update && apt-get install -y your-favorite-tool
USER appuser
```

### **Custom Aliases**

```bash
# Add to your ~/.zshrc after running the container
echo 'alias deploy="docker-compose up -d"' >> ~/.zshrc
echo 'alias logs="docker-compose logs -f"' >> ~/.zshrc
```

### **Project-Specific Setup**

```bash
# Create a project-specific wrapper
echo '#!/bin/bash
docker run -it --rm \
  -v $(pwd):/home/appuser/workspace \
  -v ~/.aws:/home/appuser/.aws:ro \
  -p 3000:3000 -p 8080:8080 \
  cdaprod/dev-shell:latest' > dev-shell.sh
chmod +x dev-shell.sh
```

-----

## 🔥 **Pro Tips**

### **Shell Integration**

```bash
# Add this to your ~/.bashrc or ~/.zshrc
alias dev='docker run -it --rm -v $(pwd):/home/appuser/workspace cdaprod/dev-shell:latest'
```

### **Docker Compose Integration**

```yaml
version: '3.8'
services:
  dev:
    image: cdaprod/dev-shell:latest
    volumes:
      - .:/home/appuser/workspace
      - ~/.ssh:/home/appuser/.ssh:ro
    stdin_open: true
    tty: true
```

### **CI/CD Base Image**

```dockerfile
FROM cdaprod/dev-shell:latest
# Your CI/CD commands here
RUN your-build-commands
```

-----

## 🤝 **Contributing**

Found a bug? Want to add a cool feature? **Contributions are welcome!**

1. Fork the repo
1. Create a feature branch
1. Make your changes
1. Submit a PR with a good description

-----

## 📜 **License**

This project is open source and available under the [MIT License](LICENSE).

-----

<div align="center">

### 🌟 **If this saved you time, give it a star!** ⭐

**Built with ❤️ by [Cdaprod](https://github.com/Cdaprod)**

*Making development environments great again, one container at a time* 🐳

</div>
