#!/usr/bin/env -S docker build . -t hub.sr.ht --file

FROM sr.ht-base

RUN apk add git.sr.ht
RUN apk add nginx fcgiwrap
RUN apk add git git-daemon

COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf
COPY ./sshd_config /etc/sshd/sshd_config

RUN echo "*/20 * * * *  /usr/bin/gitsrht-periodic" >> /etc/crontab

RUN mkdir -p /run/fcgiwrap/
RUN chown -R nginx /run/fcgiwrap/

USER nginx
CMD ["/bin/sh", "start.sh"]
