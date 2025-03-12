FROM docker.io/library/alpine:3.20 AS builder

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

# Dependencies for core.sr.ht
# TODO: Could be optimized by splitting packages into
# separate build stages
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-mistletoe
RUN sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-celery
RUN sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-infinity
RUN sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-intervals
RUN sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-orderedmultidict
RUN sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-furl
RUN sudo -u builder abuild -r -K

# core.sr.ht requires npm to build
RUN apk add npm
# All the sr.ht components require core.sr.ht, so this image is used as
# a base for all the components
WORKDIR /sr.ht-apkbuilds/sr.ht/core.sr.ht
# Change the package version
ADD base_version.txt /
RUN sed -i '/pkgver=/c\pkgver=$(cat /base_version.txt)' APKBUILD
RUN sudo -u builder abuild checksum
RUN sudo -u builder abuild -r -K


FROM docker.io/library/alpine:3.20 AS final
# The final image contains all the python dependencies
# and can be used as a base for building the component images
COPY --from=builder /home/builder/packages /home/builder/packages
COPY --from=builder /etc/apk/keys/builder* /etc/apk/keys/
RUN apk add --repository /home/builder/packages/sr.ht core.sr.ht
