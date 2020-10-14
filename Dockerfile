FROM golang:1.15-alpine as builder

WORKDIR /app
COPY . /app

RUN apk add git && go get -d ./... && go build -o main

FROM alpine:3.7

WORKDIR /app
COPY metrics.json /app/
COPY --from=builder /app/main /app
USER nobody

ENV GATEWAYURL="https://fritz.box:49000"
ENV LISTENURL="0.0.0.0:9133"
ENV USERNAME=""

ENTRYPOINT exec ./main -gateway-url $GATEWAYURL -listen-address $LISTENURL -username $USERNAME 

