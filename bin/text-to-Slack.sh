#!/bin/sh

# text-to-Slack.sh

# First version: 2025-01-24(Fri) 13:32 JST / 2025-01-24(Fri) 04:32 UTC

SECRET="$HOME/.secret/text2Slack/text2Slack"

if [ ! -f "$SECRET" ]; then
  exit 1;
fi

XXX=$(grep -v ^# "$SECRET" | head -1)

curl \
-X POST \
-H 'Content-type: application/json' \
--data '{"text":"'"発信日時：$(ima -n)\n発信者名：$(whoami)\n$(cat)"'"}' \
"https://hooks.slack.com/services/$XXX"
