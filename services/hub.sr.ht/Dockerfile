#!/usr/bin/env -S docker build . -t hub.sr.ht --file

FROM sr.ht-base

RUN apk add hub.sr.ht py3-yaml
RUN apk add nginx

COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf

USER nginx
CMD ["/bin/sh", "start.sh"]
