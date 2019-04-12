#!/bin/bash
source secrets.sh
ROOMID=$(./getGitterRoomID.sh |jq .id)
curl -s -o MISP.out -H "Accept: application/json" -H "Authorization: Bearer $GITTER_ACCESS_TOKEN" "https://stream.gitter.im/v1/rooms/$ROOMID/chatMessages" &
