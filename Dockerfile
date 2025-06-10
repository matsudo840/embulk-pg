# ref. https://qiita.com/fjunya/items/91305f20d6891beadb16

# EmBulkの実行にはJavaが必要なため、Javaが含まれているベースイメージを使用します
FROM openjdk:8-jre-slim

# 作業ディレクトリを設定します
WORKDIR /usr/src/app

# install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# install jruby
RUN curl --create-dirs -o "./jruby-complete-9.4.5.0.jar" -L "https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.4.5.0/jruby-complete-9.4.5.0.jar"
RUN chmod +x ./jruby-complete-9.4.5.0.jar

# Embulkをダウンロードして .jar として保存
RUN curl --create-dirs -o ./embulk.jar -L "https://github.com/embulk/embulk/releases/download/v0.11.5/embulk-0.11.5.jar"

# install Ruby gems
COPY ./embulk.properties /root/.embulk/embulk.properties
RUN java -jar ./embulk.jar gem install embulk -v 0.11.1
RUN java -jar ./embulk.jar gem install msgpack -v 1.7.2

# Embulkのプラグインをインストール
RUN java -jar ./embulk.jar gem install embulk-input-postgresql && \
    java -jar ./embulk.jar gem install embulk-output-bigquery

# Embulkの実行コマンドを設定します
ENTRYPOINT ["java", "-jar", "./embulk.jar", "run", "./config/config.yml"]
