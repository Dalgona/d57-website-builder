#!/bin/sh

/webhook.escript push &&
/webhook.escript build_start &&

mix local.hex --force &&
mix local.rebar --force &&

(mix do deps.get, deps.compile, serum.build &&
/webhook.escript build_success ||
(/webhook.escript build_failed; exit 1)) &&

(/webhook.escript deploy_start &&
firebase deploy --only hosting &&
/webhook.escript deploy_success ||
(/webhook.escript build_failed; exit 1)) &&

/webhook.escript all_done
