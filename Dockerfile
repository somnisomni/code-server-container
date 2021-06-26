### [ somnisomni/docker-code-server ]
### code-server Dockerfile

## Dockerfile referenced from https://github.com/monostream/code-server
#################################################################################
## BIND
# (required)    [host project folder]     -> /home/coder/projects
# (recommended) [host vscode conf folder] -> /home/coder/.local/share/code-server
#################################################################################

# Use latest Ubuntu LTS image as base
FROM ubuntu:latest

LABEL org.opencontainers.image.authors="me@somni.one"
LABEL maintainer="me@somni.one"
LABEL description="Customized code-server Docker image for somni"

##### INSTALLATION OF REQUIRED PACKAGES #####
# Workaround: pre-setup `tzdata` to prevent stuck during package installation
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone

# Install Microsoft .NET repository package
RUN apt-get update -y; \
    apt-get install --no-install-recommends -y apt-utils ca-certificates dpkg lsb-release wget; \
    \
    wget "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb \
    && dpkg -i /tmp/packages-microsoft-prod.deb \
    && rm -f /tmp/packages-microsoft-prod.deb

# Update package manifests & upgrade existing packages
RUN apt-get update -y; \
    apt-get install -f -y; \
    apt-get upgrade -y

# Install common packages
RUN apt-get install --no-install-recommends -y \
    apt-transport-https \
    apt-utils \
    bash \
    ca-certificates \
    curl \
    dumb-init \
    git \
    gpg \
    gpg-agent \
    locales \
    lsb-release \
    nano \
    openssh-client \
    openssl \
    software-properties-common \
    sudo \
    tar \
    tzdata \
    util-linux \
    wget

# Install essential packages for building sources / Install DPKG-dev
RUN apt-get install --no-install-recommends -y \
    build-essential \
    gcc-10 \
    cpp-10 \
    g++-10 \
    dpkg-dev \
    make \
    patch \
    pkg-config

# Install Python 3
RUN apt-get install --no-install-recommends -y \
    python3 \
    python3-pip

# Install .NET SDK 5.0
RUN apt-get install --no-install-recommends -y \
    dotnet-sdk-5.0

# Register en-US / ko-KR locales
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; \
    localedef -i ko_KR -c -f UTF-8 -A /usr/share/locale/locale.alias ko_KR.UTF-8


##### CODE-SERVER INSTALLATION #####
# Install code-server
RUN CODE_VERSION=$(curl -sL https://api.github.com/repos/cdr/code-server/releases/latest | grep '"name"' | head -1 | awk -F '[:]' '{print $2}' | sed -e 's/"//g' | sed -e 's/,//g' | sed -e 's/ //g' | sed -e 's/\r//g') \
    && CODE_VERSION_WITHOUT_V=$(echo $CODE_VERSION | sed -e 's/v//g') \
    && curl -fsL "https://github.com/cdr/code-server/releases/download/${CODE_VERSION}/code-server-${CODE_VERSION_WITHOUT_V}-linux-amd64.tar.gz" | tar -zx -C /usr/local/bin \
    && mv /usr/local/bin/code-server-${CODE_VERSION_WITHOUT_V}-linux-amd64 /usr/local/bin/code-server \
    && ln -s /usr/local/bin/code-server/bin/code-server /usr/bin/code-server

# code-server custom branding
COPY branding.sh /tmp/branding.sh
RUN chmod +x /tmp/branding.sh \
    && . /tmp/branding.sh \
    && rm -f /tmp/branding.sh

# Install fixuid
RUN \
    FIXUID_VERSION=$(curl -sL https://api.github.com/repos/boxboat/fixuid/releases/latest | grep '"name"' | head -1 | awk -F '[:]' '{print $2}' | sed -e 's/"//g' | sed -e 's/,//g' | sed -e 's/ //g' | sed -e 's/\r//g') \
    && FIXUID_VERSION_WITHOUT_V=$(echo $FIXUID_VERSION | sed -e 's/v//g') \
    && USER=coder \
    && GROUP=coder \
    && curl -fsL "https://github.com/boxboat/fixuid/releases/download/${FIXUID_VERSION}/fixuid-${FIXUID_VERSION_WITHOUT_V}-linux-amd64.tar.gz" | tar -zx -C /usr/local/bin \
    && chown root:root /usr/local/bin/fixuid \
    && chmod 4755 /usr/local/bin/fixuid \
    && ln -s /usr/local/bin/fixuid /usr/bin/fixuid \
    && mkdir -p /etc/fixuid \
    && printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

# Install entrypoint.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh


##### SETUP CONTAINER ENVIRONMENT #####
# User & group (`coder`) setup
RUN addgroup --gid 1000 coder \
    && adduser --uid 1000 --ingroup coder --home /home/coder --shell /bin/bash --disabled-password --gecos "" coder \
    && usermod -aG sudo coder \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd
USER coder:coder
WORKDIR /home/coder

# Set language envvar to Korean UTF-8
ENV LANG=ko_KR.utf8

# .NET envvars
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DISABLE_TELEMETRY=true \
    PATH="${PATH}:/usr/share/dotnet"

# VSCode envvars
ENV CODE_DATA="${HOME}/.local/share/code-server" \
    CODE_USER="${CODE_DATA}/User" \
    CODE_EXTENSIONS="${CODE_DATA}/extensions"

# Create project folder & VSCode data folder
RUN mkdir -p ~/projects; \
    mkdir -p ${CODE_USER}

# Copy initial VSCode settings.json (will be ignored when binding host's VSCode data folder)
COPY --chown=coder:coder settings.json ${CODE_USER}/


##### NON-ROOT PACKAGE INSTALLATION #####
# Install Node.js LTS using NVM
RUN curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh" | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install --lts --latest-npm


##### CLEANUP & FINALIZE #####
# APT cleanup
RUN sudo apt-get clean -y && sudo rm -rf /var/lib/apt/lists/*

# /tmp cleanup
RUN sudo rm -rf /tmp/*

# Take ownership of home folder
RUN sudo chown -R coder:coder /home/coder


##### DOCKER CONTAINER CONFIGURATIONS #####
# Expose: code-server app itself
EXPOSE 8080

# Expose: development servers
EXPOSE 30000-30002

# Entrypoint
ENTRYPOINT ["/usr/bin/entrypoint.sh",        \
                "/home/coder/projects",      \
                "--bind-addr=0.0.0.0:8080",  \
                "--disable-telemetry",       \
                "--user-data-dir={0}",       \
                "--extensions-dir={1}"]
#       {0] will be replaced to $CODE_DATA
#       {1} will be replaced to $CODE_EXTENSIONS
