# ref. https://qiita.com/fjunya/items/91305f20d6891beadb16

# EmBulkの実行にはJavaが必要なため、Javaが含まれているベースイメージを使用します
FROM openjdk:8-jre-slim

# 作業ディレクトリを設定します
WORKDIR /usr/src/app
ENV EMBULK_HOME=/root/.embulk

# install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# install jruby
RUN mkdir -p /opt/jruby
RUN curl --create-dirs -o "/opt/jruby/jruby-complete-9.4.5.0.jar" -L "https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.4.5.0/jruby-complete-9.4.5.0.jar"

# Embulkをダウンロードして実行可能にする
RUN curl --create-dirs -o /usr/local/bin/embulk.jar -L "https://github.com/embulk/embulk/releases/download/v0.11.5/embulk-0.11.5.jar"
COPY embulk_wrapper.sh /usr/local/bin/embulk
RUN chmod +x /usr/local/bin/embulk

# Create Maven repository directory
RUN mkdir -p /root/.embulk/lib/m2/repository && chmod -R 777 /root/.embulk/lib/m2/repository

# install Ruby gems and plugins
COPY ./embulk.properties /root/.embulk/embulk.properties
RUN embulk gem install msgpack -v 1.7.2
RUN embulk gem install liquid -v 4.0.3
RUN embulk gem install embulk-input-postgresql embulk-output-bigquery

# Embulkの実行コマンドを設定します
# This entrypoint allows you to pass arguments to `embulk run` via `docker run`
ENTRYPOINT ["embulk"]
