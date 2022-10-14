#!/usr/bin/env bash

podname="opal"
version="0.0.1"
publish_ip="10.88.0.1"

podman pod rm -f ${podname} podman pod create --name ${podname} --hostname ${podname} -p ${publish_ip}:7002:7002

podman run -d --name  ${podname}-broadcast_channel --hostname ${podname}-broadcast_channel \
  -e POSTGRES_DB=postgres -e POSTGRES_USER=postgres -e POSTGRES_USER=postgres \
  postgres:alpine

podman run -d --name  ${podname}-opal_server --expose 7002 --hostname ${podname}-opal_server \
  -e  OPAL_BROADCAST_URI=postgres://postgres:postgres@broadcast_channel:5432/postgres \
  -e OPAL_LOG_FORMAT_INCLUDE_PID=true \
  -e OPAL_DATA_CONFIG_SOURCES={"config":{"entries":[{"url":"http://opal_server:7002/policy-data","topics":["policy_data"],"dst_path":"/static"}]}} \
  -e OPAL_POLICY_REPO_POLLING_INTERVAL=30 \
  -e OPAL_POLICY_REPO_URL=https://github.com/permitio/opal-example-policy-repo \
  -e UVICORN_NUM_WORKERS=4 \
  permitio/opal-server:latest

