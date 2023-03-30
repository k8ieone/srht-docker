#!/usr/bin/env -S docker build . -t sr.ht-base --file
#
FROM alpine:3.17

COPY repositories /etc/apk

RUN wget -q -O /etc/apk/keys/alpine@sr.ht.rsa.pub https://mirror.sr.ht/alpine/alpine@sr.ht.rsa.pub

RUN apk update
RUN apk add py3-srht
