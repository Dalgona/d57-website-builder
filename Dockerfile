FROM elixir:1.10.4-slim

RUN apt-get update && \
    apt-get -y install imagemagick npm sassc

RUN npm -g install firebase-tools

COPY discord_webhook /discord_webhook

RUN cd /discord_webhook && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix do deps.get, deps.compile, escript.build && \
    cp -v discord_webhook /webhook.escript

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
