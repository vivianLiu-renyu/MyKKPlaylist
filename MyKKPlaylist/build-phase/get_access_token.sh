#!/bin/bash

curl -d "client_id=f83d449bf6233c25b73330413dcb313b&client_secret=bbe1d1310eb22e2d6c4517c4a5907e09&grant_type=client_credentials" "https://account.kkbox.com/oauth2/token" > MyKKPlaylist/accessToken.json