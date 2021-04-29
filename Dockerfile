FROM elixir:1.11.4-slim

RUN echo 'deb http://deb.debian.org/debian testing main' >> /etc/apt/sources.list && \
    apt-get -y -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install --no-install-recommends \
      build-essential ca-certificates curl git imagemagick nodejs npm \
      libcairo2 libcairo2-dev \
      libpango-1.0-0 libpango1.0-dev && \
    \
    # Install Firebase CLI.
    npm -g install firebase-tools && \
    npm cache clean --force && \
    apt-get clean && \
    \
    # Install Dart Sass.
    curl -L https://github.com/sass/dart-sass/releases/download/1.29.0/dart-sass-1.29.0-linux-x64.tar.gz > dart-sass.tar.gz && \
    tar zxf dart-sass.tar.gz && \
    rm -f dart-sass.tar.gz

COPY discord_webhook /discord_webhook

RUN cd /discord_webhook && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix do deps.get, deps.compile, escript.build && \
    cp -v discord_webhook /webhook.escript && \
    rm -rf _build deps

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
