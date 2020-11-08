FROM elixir:1.10.4-slim

RUN apt-get -y -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install --no-install-recommends ca-certificates curl imagemagick && \
    \
    # Install Node.js, which is required by Firebase CLI.
    (curl -sL https://deb.nodesource.com/setup_15.x | bash -) && \
    apt-get -y -q update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y -q install --no-install-recommends nodejs && \
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
