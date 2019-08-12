#!/bin/bash

curl -d "client_id=${ID}&client_secret=${SECRET}&grant_type=client_credentials" "https://account.kkbox.com/oauth2/token" > MyKKPlaylist/accessToken.json