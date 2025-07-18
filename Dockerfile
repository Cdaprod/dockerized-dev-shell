##############################################################################
# Dockerfile – Developer workspace shell image 🐳
# Creates: cdaprod/workspace-shell:latest
##############################################################################

############################
# Stage 1 – Base OS image  #
############################
FROM python:3.11-slim-bookworm AS base
LABEL maintainer="cdaprod.dev" \
      org.opencontainers.image.version="0.1.0" \
      org.opencontainers.image.title="CDA Prod Workspace Shell" \
      org.opencontainers.image.description="Developer workspace with zsh, nvim, and modern CLI tools"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    TERM=xterm-256color \
    SHELL=/bin/zsh

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential git curl wget ca-certificates \
        ffmpeg libgl1 libglib2.0-0 \
        bash bash-completion zsh locales tmux \
        neovim htop less tree ripgrep fd-find fzf \
        bat exa jq unzip gnupg sqlite3 \
        software-properties-common apt-transport-https \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

###############################
# Stage 2 – Dev shell goodies #
###############################
FROM base AS devshell

# 1. non-root user
RUN useradd -ms /bin/zsh appuser
USER appuser
WORKDIR /home/appuser

# 2. Oh My Zsh (unattended)
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 3. zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions      ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/zsh-users/zsh-completions          ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# 4. full .zshrc tweaks
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc && \
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions docker docker-compose python pip fzf tmux)/' ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# Enhanced zsh configuration' >> ~/.zshrc && \
    echo 'export HISTSIZE=10000' >> ~/.zshrc && \
    echo 'export HISTFILESIZE=20000' >> ~/.zshrc && \
    echo 'export SAVEHIST=10000' >> ~/.zshrc && \
    echo 'setopt HIST_IGNORE_DUPS' >> ~/.zshrc && \
    echo 'setopt HIST_IGNORE_ALL_DUPS' >> ~/.zshrc && \
    echo 'setopt HIST_FIND_NO_DUPS' >> ~/.zshrc && \
    echo 'setopt HIST_SAVE_NO_DUPS' >> ~/.zshrc && \
    echo 'setopt SHARE_HISTORY' >> ~/.zshrc && \
    echo 'setopt APPEND_HISTORY' >> ~/.zshrc && \
    echo 'setopt INC_APPEND_HISTORY' >> ~/.zshrc && \
    echo 'export EDITOR=nvim' >> ~/.zshrc && \
    echo 'export VISUAL=nvim' >> ~/.zshrc && \
    echo 'alias ll="ls -alF"' >> ~/.zshrc && \
    echo 'alias la="ls -A"' >> ~/.zshrc && \
    echo 'alias l="ls -CF"' >> ~/.zshrc && \
    echo 'alias vim=nvim' >> ~/.zshrc && \
    echo 'alias vi=nvim' >> ~/.zshrc && \
    echo 'alias cat=bat' >> ~/.zshrc && \
    echo 'alias find=fd' >> ~/.zshrc && \
    echo 'alias grep=rg' >> ~/.zshrc && \
    echo 'alias top=htop' >> ~/.zshrc && \
    echo 'alias cls=clear' >> ~/.zshrc && \
    echo 'alias ..="cd .."' >> ~/.zshrc && \
    echo 'alias ...="cd ../.."' >> ~/.zshrc && \
    echo 'alias ....="cd ../../.."' >> ~/.zshrc && \
    echo 'alias ~="cd ~"' >> ~/.zshrc && \
    echo 'alias reload="source ~/.zshrc"' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# FZF configuration' >> ~/.zshrc && \
    echo 'export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"' >> ~/.zshrc && \
    echo 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"' >> ~/.zshrc && \
    echo 'export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"' >> ~/.zshrc && \
    echo '' >> ~/.zshrc && \
    echo '# Auto-completion for zsh-completions' >> ~/.zshrc && \
    echo 'autoload -U compinit && compinit' >> ~/.zshrc

# 5. bash fallback tweaks
RUN echo '# Enhanced bash configuration' >> ~/.bashrc && \
    echo 'export HISTSIZE=10000' >> ~/.bashrc && \
    echo 'export HISTFILESIZE=20000' >> ~/.bashrc && \
    echo 'export HISTCONTROL=ignoredups:erasedups' >> ~/.bashrc && \
    echo 'shopt -s histappend' >> ~/.bashrc && \
    echo 'shopt -s checkwinsize' >> ~/.bashrc && \
    echo 'shopt -s cdspell' >> ~/.bashrc && \
    echo 'bind "set completion-ignore-case on"' >> ~/.bashrc && \
    echo 'bind "set show-all-if-ambiguous on"' >> ~/.bashrc && \
    echo 'export EDITOR=nvim' >> ~/.bashrc && \
    echo 'export VISUAL=nvim' >> ~/.bashrc && \
    echo 'alias ll="ls -alF"' >> ~/.bashrc && \
    echo 'alias la="ls -A"' >> ~/.bashrc && \
    echo 'alias l="ls -CF"' >> ~/.bashrc && \
    echo 'alias vim=nvim' >> ~/.bashrc && \
    echo 'alias vi=nvim' >> ~/.bashrc && \
    echo 'if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi' >> ~/.bashrc

USER root
# 6. minimal nvim config
RUN mkdir -p /home/appuser/.config/nvim && \
    echo 'set number relativenumber'             >  /home/appuser/.config/nvim/init.vim && \
    echo 'set expandtab tabstop=4 shiftwidth=4' >> /home/appuser/.config/nvim/init.vim && \
    echo 'syntax on'                            >> /home/appuser/.config/nvim/init.vim
RUN chown -R appuser:appuser /home/appuser

# Switch back to appuser for the final image
USER appuser
WORKDIR /home/appuser

# Set default shell and create a workspace directory
RUN mkdir -p /home/appuser/workspace

# Default command launches zsh
CMD ["/bin/zsh"]