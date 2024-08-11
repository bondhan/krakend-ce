ARG GOLANG_VERSION
ARG ALPINE_VERSION

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk --no-cache --virtual .build-deps add make gcc musl-dev binutils-gold

COPY . /app
WORKDIR /app

RUN make build

FROM alpine:${ALPINE_VERSION}

RUN apk upgrade --no-cache --no-interactive && apk add --no-cache ca-certificates tzdata && \
    adduser -u 1000 -S -D -H krakend && \
    mkdir /etc/krakend

LABEL maintainer="community@krakend.io"

COPY --from=builder /app/krakend /usr/bin/krakend

USER 1000

VOLUME [ "/etc/krakend" ]
ENTRYPOINT [ "/usr/bin/krakend" ]

EXPOSE 8000 8090
