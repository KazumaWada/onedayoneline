# # ベースイメージとして公式のRubyイメージを使用
# FROM ruby:3.2.6

# # 必要なパッケージをインストール
# RUN apt-get update -qq && \
#     apt-get install -y build-essential libpq-dev postgresql-client && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

# # Bundler をインストール
# RUN gem install bundler --no-document

# #import mapsを使うので、yarnとnodeが不要になる。

# # 作業ディレクトリを指定
# WORKDIR /app

# # GemfileとGemfile.lockを先にコピーして依存関係をインストール
# COPY Gemfile /app/Gemfile
# COPY Gemfile.lock /app/Gemfile.lock
# #gemのインストールをx86_64-linuxにも対応させる
# RUN RUN bundle lock --add-platform x86_64-linux \
# && bundle install

# # アプリケーションコードをコピー
# COPY . /app

# # ポート3000を公開
# EXPOSE 3000

# # アプリケーションを起動
# CMD ["rails", "server", "-b", "0.0.0.0"]



# ベースイメージとして公式のRubyイメージを使用
FROM ruby:3.2.6

# 必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Bundler をインストール
RUN gem install bundler --no-document

# 作業ディレクトリを指定
WORKDIR /app

# 依存関係のインストールを効率化するため、GemfileとGemfile.lockを先にコピー
COPY Gemfile Gemfile.lock ./

# プラットフォームを指定してBundlerをインストール
RUN bundle lock --add-platform x86_64-linux && \
    bundle install --jobs=4 --retry=3

# アプリケーションコードをコピー
COPY . .

# キャッシュを活用しやすくするため、最後にコードを追加
# これにより、Gemfileが変更されない限り、`bundle install` のキャッシュが再利用されます。

# ポート3000を公開
EXPOSE 3000

# アプリケーションを起動
CMD ["rails", "server", "-b", "0.0.0.0"]
