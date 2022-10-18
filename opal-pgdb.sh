#!/usr/bin/env bash

podname=pgdb

podman pod rm -f ${podname}

podman pod create \
  --name ${podname} --hostname ${podname} \
  -p 15432:5432

podman run -d --name  ${podname}-db --pod ${podname} \
  -e POSTGRES_DB=postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres  \
  --expose 5432 \
  postgres:latest
