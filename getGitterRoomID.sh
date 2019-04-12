#!/bin/bash
source secrets.sh
http GET https://api.gitter.im/v1/rooms/ \
  "Authorization: Bearer $GITTER_ACCESS_TOKEN" q==$QUERY |jq '.[] | select(.name=="MISP/MISP")'
