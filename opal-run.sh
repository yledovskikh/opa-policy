#!/usr/bin/env bash

podname="opal"
version="0.0.1"
#publish_ip="10.88.0.1"

podman pod rm -f ${podname}

podman pod create \
  --name ${podname} --hostname ${podname} \
  -p 7002:7002 -p 7000:7000 -p 8181:8181

podman run -d --name  ${podname}-broadcast_channel --pod ${podname} \
  -e POSTGRES_DB=postgres -e POSTGRES_USER=postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password \
  postgres:alpine

podman run -d --name  ${podname}-opal_server --pod ${podname} --expose 7002 \
  -e OPAL_BROADCAST_URI=postgres://postgres:postgres@127.0.0.1:5432/postgres \
  -e OPAL_LOG_FORMAT_INCLUDE_PID=true \
  -e OPAL_POLICY_REPO_POLLING_INTERVAL=30 \
  -e OPAL_POLICY_REPO_URL=https://github.com/yledovskikh/opa-policy \
  -e UVICORN_NUM_WORKERS=4 \
  -e OPAL_DATA_CONFIG_SOURCES='{"config":{"entries":[{"url":"postgres://postgres@192.168.104.55:15432/postgres","config":{"fetcher":"PostgresFetchProvider","query":"SELECT * from city;","connection_params":{"password":"password"}},"topics":["policy_data"],"dst_path":"cities"}]}}' \
  permitio/opal-server:latest

#  -e OPAL_DATA_CONFIG_SOURCES='{"config":{"entries":[{"url":"http://127.0.0.1:7002/policy-data","topics":["policy_data"],"dst_path":"/static"}]}} '\
#
podman run -d --name  ${podname}-opal_client --pod ${podname} --expose 7000 --expose 8181 \
       -e OPAL_SERVER_URL=http://127.0.0.1:7002 \
       -e OPAL_FETCH_PROVIDER_MODULES=opal_common.fetcher.providers,opal_fetcher_postgres.provider \
       -e OPAL_LOG_FORMAT_INCLUDE_PID=true \
       -e OPAL_INLINE_OPA_LOG_FORMAT=http \
       opal-fetch-postgree:latest \
       sh -c "./wait-for.sh 127.0.0.1:7002 --timeout=20 -- ./start.sh"


#  opal_client:
#    # by default we run opal-client from latest official image
#    image: permitio/opal-client:latest
#    environment:
#      - OPAL_SERVER_URL=http://opal_server:7002
#      - OPAL_LOG_FORMAT_INCLUDE_PID=true
#      - OPAL_INLINE_OPA_LOG_FORMAT=http
#    ports:
#      # exposes opal client on the host machine, you can access the client at: http://localhost:7000
#      - "7000:7000"
#      # exposes the OPA agent (being run by OPAL) on the host machine
#      # you can access the OPA api that you know and love at: http://localhost:8181
#      # OPA api docs are at: https://www.openpolicyagent.org/docs/latest/rest-api/
#      - "8181:8181"
#    depends_on:
#      - opal_server
#    # this command is not necessary when deploying OPAL for real, it is simply a trick for dev environments
#    # to make sure that opal-server is already up before starting the client.
#    command: sh -c "./wait-for.sh opal_server:7002 --timeout=20 -- ./start.sh"
