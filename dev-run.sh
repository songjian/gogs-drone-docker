#!/bin/bash
export PUID=$(id git -u)
export PGID=$(id git -g)
docker-compose up -d