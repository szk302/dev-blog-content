FROM node:bullseye-slim
## 1. 準備
RUN apt update -y && \
    apt install -y curl gpg && \
    mkdir -p /usr/local/share/keyrings/
## 2. インストール
    # リポジトリキーを取得し一旦インポート
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --no-default-keyring --keyring /tmp/temp-keyring.gpg --import && \
    # リポジトリキーをバイナリ形式でエクスポート
    gpg --no-default-keyring --keyring /tmp/temp-keyring.gpg --export --output /usr/local/share/keyrings/chrome.gpg && \
    # リトじポリキーを指定してリポジトリを登録
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/local/share/keyrings/chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    # インストール
    apt update -y && \
    apt install -y google-chrome-stable