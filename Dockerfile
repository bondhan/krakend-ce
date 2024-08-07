ARG GOLANG_VERSION
ARG ALPINE_VERSION
FROM golang:${GOLANG_VERSION}-alpine${ALPINE_VERSION} as builder

RUN apk --no-cache --virtual .build-deps add make gcc musl-dev binutils-gold

COPY . /app
WORKDIR /app

RUN make build


FROM alpine:${ALPINE_VERSION}

LABEL maintainer="community@krakend.io"

RUN apk update && apk upgrade --no-cache --no-interactive && apk add --no-cache ca-certificates tzdata

RUN adduser -D -g 'krakend' krakend
USER krakend

COPY --chown=krakend:krakend --from=builder /app/krakend /usr/bin/krakend

VOLUME [ "/etc/krakend" ]
ENTRYPOINT [ "/usr/bin/krakend" ]

EXPOSE 8000 8090
