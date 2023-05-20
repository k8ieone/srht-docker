FROM docker.io/alpine:3.17 AS builder

RUN adduser -D builder
RUN apk add git alpine-sdk sudo
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && chmod 0440 /etc/sudoers.d/builder
RUN sudo -u builder abuild-keygen -a -i -n
RUN addgroup builder abuild

RUN git clone https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds
RUN chown -R builder:builder /sr.ht-apkbuilds

RUN mkdir /packages

WORKDIR /sr.ht-apkbuilds/sr.ht/py3-case
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-vine
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-mistletoe
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-atpublic
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-aiosmtpd
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-amqp
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-billiard
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-click-repl
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-click-didyoumean
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-kombu
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-celery
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-pgpy
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-infinity
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-intervals
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-colour
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-orderedmultidict
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-furl
RUN pwd && sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-sqlalchemy-utils
RUN pwd && sudo -u builder abuild -r

# py3-srht is required by all components,
# we can use that and make py3-srht the base for all other images
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-srht
RUN pwd && sudo -u builder abuild -r

COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf

RUN echo "0	2	*	*	*  /usr/bin/metasrht-daily" >>/etc/crontab

USER nginx
CMD ["/bin/sh", "start.sh"]
