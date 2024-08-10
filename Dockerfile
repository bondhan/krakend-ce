ARG GOLANG_VERSION
ARG ALPINE_VERSION

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} AS builder

RUN apk --no-cache --virtual .build-deps add make gcc musl-dev binutils-gold

COPY . /app
WORKDIR /app

RUN make build

FROM debian:buster-slim

RUN apt-get update && \
	apt-get install -y ca-certificates && \
	update-ca-certificates && \
	rm -rf /var/lib/apt/lists/*

LABEL maintainer="community@krakend.io"

RUN useradd -r -c "KrakenD user" -U krakend
USER krakend

COPY --chown=krakend:krakend --from=builder /app/krakend /usr/bin/krakend

VOLUME [ "/etc/krakend" ]
ENTRYPOINT [ "/usr/bin/krakend" ]

EXPOSE 8000 8090
