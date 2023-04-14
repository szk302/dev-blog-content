FROM debian:bullseye-20230411-slim
ARG DEFAULT_TERRAFROM_VERSION=1.4.4
ARG TFENV_VERSION=v3.0.0
ARG TFLINT_VERSION=v0.45.0
ARG TFDOCS_VERSION=v0.16.0
ARG TFSEC_VERSION=v1.28.1
ARG CHECKOV_VERSION=2.3.160

RUN apt-get update -y && \
    # 日本語化
    apt-get install -y locales && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen && \
    apt-get install -y curl git unzip
    # tfenvインストール
ENV TFENV_HOME=/usr/local/tfenv
ENV TFENV_TAR_URL=https://github.com/tfutils/tfenv/archive/refs/tags/${TFENV_VERSION}.tar.gz
ENV PATH=$PATH:${TFENV_HOME}/bin
RUN mkdir -p "${TFENV_HOME}" && \
    curl -fSL "${TFENV_TAR_URL}" | tar zxvf - --strip-components=1 -C "${TFENV_HOME}"
    # デフォルトのterraformインストール
RUN tfenv install "${DEFAULT_TERRAFROM_VERSION}"
    # tflintインストール
ENV TFLINT_VERSION="${TFLINT_VERSION}"
RUN curl -fSL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
    # tfdocインストール
ENV TFDOCS_HOME=/usr/local/tfdocs
ENV PATH=$PATH:${TFDOCS_HOME}/bin
ENV TFDOCS_TAR_URL=https://github.com/terraform-docs/terraform-docs/releases/download/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION}-Linux-amd64.tar.gz
RUN mkdir -p "${TFDOCS_HOME}/bin" && \
    curl -fSL "${TFDOCS_TAR_URL}" | tar zxvf - -C "${TFDOCS_HOME}" && \
    chmod +x "${TFDOCS_HOME}/terraform-docs" && \
    mv "${TFDOCS_HOME}/terraform-docs" "${TFDOCS_HOME}/bin/"
    # tfsecインストール
ENV TFSEC_VERSION="${TFSEC_VERSION}"
RUN curl -fSL https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash
    # checkovインストール
RUN apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    python3 -m pip install -U checkov==2.2.5