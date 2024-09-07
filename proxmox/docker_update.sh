#!/bin/bash

(yes | paru) && for d in ./*/; do (cd "$d"; sudo docker compose stop && sudo docker compose rm -f && sudo docker compose pull && sudo docker compose up -d --force-recreate); done; sudo docker system prune -af
