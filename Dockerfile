FROM elixir:1.10.4-slim

RUN apt-get update && \
    apt-get -y install curl imagemagick sassc && \
    (curl -sL https://deb.nodesource.com/setup_15.x | bash -) && \
    apt-get update && \
    apt-get -y install nodejs && \
    npm -g install firebase-tools && \
    apt-get clean

COPY discord_webhook /discord_webhook

RUN cd /discord_webhook && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix do deps.get, deps.compile, escript.build && \
    cp -v discord_webhook /webhook.escript && \
    rm -rf _build deps

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
