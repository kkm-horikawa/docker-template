FROM debian:bookworm-slim

# 環境変数の設定
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR=/root/.nvm
ENV NVM_VERSION=v0.39.7
ENV NODE_VERSION=22.12.0
ENV NPM_VERSION=10.9.0
ENV TERRAFORM_VERSION=1.9.2
ENV TERRAFORM_DOCS_VERSION=0.16.0
ENV TERRAFORMER_VERSION=0.8.24
ENV PYTHON_VERSION=3.11
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PATH="/root/.local/bin:$PATH"
ENV PIP_NO_CACHE_DIR=1

# 基本的なパッケージのインストール
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    postgresql-client \
    git \
    ca-certificates \
    gnupg \
    unzip \
    vim \
    zsh \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-venv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Pythonの設定
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python${PYTHON_VERSION} 1 \
    && python3 -m venv /root/.venv

# venvのアクティベーションを.zshrcと.bashrcに追加
RUN echo 'source /root/.venv/bin/activate' >> /root/.zshrc \
    && echo 'source /root/.venv/bin/activate' >> /root/.bashrc

# nvm のインストール
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default \
    && npm install -g npm@${NPM_VERSION}

# シェルの初期化時にnvmを読み込むための設定
RUN echo '. $NVM_DIR/nvm.sh' >> /root/.bashrc

# AWS CLI のインストール
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws \
    && aws --version

# AWS EB CLI のインストール
RUN . /root/.venv/bin/activate && pip install --no-cache-dir awsebcli

# uv のインストール
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# tfenv のインストール
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv \
    && echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> /root/.bashrc \
    && ln -s /root/.tfenv/bin/* /usr/local/bin \
    && tfenv install ${TERRAFORM_VERSION} \
    && tfenv use ${TERRAFORM_VERSION}

# terraform-docs のインストール
RUN curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-amd64.tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/ \
    && rm terraform-docs.tar.gz

# terraformer のインストール
RUN curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/${TERRAFORMER_VERSION}/terraformer-all-linux-amd64 \
    && chmod +x terraformer-all-linux-amd64 \
    && mv terraformer-all-linux-amd64 /usr/local/bin/terraformer

# Docker in Docker のセットアップ
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Google Cloud SDK のインストール
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update && apt-get install -y google-cloud-sdk \
    && mkdir -p /root/.config/gcloud

# neofetch のインストール
RUN apt-get update && apt-get install -y neofetch \
    && rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定
WORKDIR /workspace

# キャッシュをクリアしてイメージサイズを削減
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Node.jsとnpmのバージョンを確認
RUN . $NVM_DIR/nvm.sh && node -v && npm -v

# zsh関連の設定
RUN echo '# ZSH Configuration' >> /root/.bashrc && \
    echo '# if [ -x /usr/bin/zsh ]; then' >> /root/.bashrc && \
    echo '#     exec /usr/bin/zsh -l' >> /root/.bashrc && \
    echo '# fi' >> /root/.bashrc

# zshの設定をzshrcに追加
RUN echo '# ZSH specific settings' >> /root/.zshrc && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.zshrc && \
    echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> /root/.zshrc && \
    echo '# Set zsh options' >> /root/.zshrc && \
    echo '# setopt autocd' >> /root/.zshrc && \
    echo '# setopt extended_history' >> /root/.zshrc && \
    echo '# setopt share_history' >> /root/.zshrc && \
    echo '# setopt hist_ignore_dups' >> /root/.zshrc && \
    echo '# bindkey -e' >> /root/.zshrc

SHELL ["/usr/bin/zsh", "-c"]