FROM docker.io/alpine:3.17 AS builder

RUN adduser -D builder
RUN apk add git alpine-sdk sudo
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && chmod 0440 /etc/sudoers.d/builder
RUN sudo -u builder abuild-keygen -a -i -n
RUN addgroup builder abuild

RUN git clone https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds
RUN chown -R builder:builder /sr.ht-apkbuilds

# Using a for loop is nice, but totally eliminates Docker caching
# WORKDIR /sr.ht-apkbuilds/sr.ht
# RUN for p in py3-case py3-vine py3-mistletoe; do cd $p && sudo -u builder abuild -r && cd ..; done

# Dependencies for py3-srht
# TODO: Could be optimized by splitting packages into
# separate build stages
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-case
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-vine
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-mistletoe
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-atpublic
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-aiosmtpd
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-amqp
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-billiard
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-click-repl
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-click-didyoumean
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-kombu
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-celery
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-pgpy
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-infinity
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-intervals
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-colour
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-orderedmultidict
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-furl
RUN sudo -u builder abuild -r
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-sqlalchemy-utils
RUN sudo -u builder abuild -r

# py3-srht requires npm to build
RUN apk add npm
# All the sr.ht components require py3-srht, so this image is used as
# a base for all the components
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-srht
RUN sudo -u builder abuild -r


FROM docker.io/alpine:3.17 AS final
# The final image contains all the python dependencies
# and can be used as a base for building the component images
COPY --from=builder /home/builder/packages /home/builder/packages
COPY --from=builder /etc/apk/keys/builder* /etc/apk/keys/
RUN apk add --repository /home/builder/packages/sr.ht py3-srht
