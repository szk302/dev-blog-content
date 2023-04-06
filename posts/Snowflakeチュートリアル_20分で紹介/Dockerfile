FROM debian:bullseye-20230320-slim
ARG SNOW_SQL_FILE_URL=https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.24-linux_x86_64.bash
ARG SNOW_SQL_FILE_SIG_URL=https://sfc-repo.snowflakecomputing.com/snowsql/bootstrap/1.2/linux_x86_64/snowsql-1.2.24-linux_x86_64.bash.sig
ARG GPG_RECV_KEYS=630D9F3CAB551AF3

ENV SNOWSQL_DEST=/usr/local/bin
ENV SNOWSQL_LOGIN_SHELL=/root/.profile
ENV LANG=ja_JP.UTF-8

RUN apt update -y && \
    # 日本語化
    apt install -y locales && \
    sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
    locale-gen && \
    # SNOW SQLのインストール
    apt install -y curl gpg unzip && \
    curl -LO "${SNOW_SQL_FILE_URL}" && \
    curl -LO "${SNOW_SQL_FILE_SIG_URL}" && \
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "${GPG_RECV_KEYS}" && \
    gpg --verify "${SNOW_SQL_FILE_SIG_URL##*/}" "${SNOW_SQL_FILE_URL##*/}" && \
    gpg --batch --yes --delete-key "Snowflake Computing" && \
    bash "${SNOW_SQL_FILE_URL##*/}"
