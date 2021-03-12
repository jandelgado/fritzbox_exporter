FROM golang:1.15-alpine as builder

WORKDIR /app
COPY . /app

RUN apk add git && go get -d ./... && go build -o main

FROM alpine:3.7

WORKDIR /app
COPY metrics.json /app/
COPY metrics-lua.json /app/

COPY --from=builder /app/main /app
USER nobody

ENV GATEWAY_URL="https://fritz.box:49000"
ENV GATEWAY_LUAURL="https://fritz.box"
ENV LISTENURL="0.0.0.0:9133"
ENV USERNAME=""
ENV PASSWORD=""
ENV OPTS=""

ENTRYPOINT exec ./main \
                -gateway-url "$GATEWAY_URL" \
                -gateway-luaurl "$GATEWAY_LUAURL" \
                -listen-address "$LISTENURL" \
                -username "$USERNAME"  \
                -metrics-file=/app/metrics.json \
                -lua-metrics-file=/app/metrics-lua.json \
                $OPTS
