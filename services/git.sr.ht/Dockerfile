FROM base as builder
RUN apk add git alpine-sdk sudo nodejs
RUN adduser -D builder
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && chmod 0440 /etc/sudoers.d/builder
RUN sudo -u builder abuild-keygen -a -i -n
RUN addgroup builder abuild
RUN git clone https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds
RUN chown -R builder:builder /sr.ht-apkbuilds

# Some more dependencies for git.sr.ht
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-minio
RUN ulimit -n 1024000 && sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-ansi2html
RUN ulimit -n 1024000 && sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/builds.sr.ht
RUN sudo -u builder abuild checksum
RUN ulimit -n 1024000 && sudo -u builder abuild -r -K
WORKDIR /sr.ht-apkbuilds/sr.ht/py3-scmsrht
RUN ulimit -n 1024000 && sudo -u builder abuild -r -K

WORKDIR /sr.ht-apkbuilds/sr.ht/git.sr.ht
ADD version.txt /
RUN sed -i '/pkgver=/c\pkgver=$(cat /version.txt)' APKBUILD
RUN sudo -u builder abuild checksum
RUN ulimit -n 1024000 && sudo -u builder abuild -r -K
# Copy the packages into a cache
RUN --mount=type=cache,target=/packages/ cp -r /home/builder/packages/ /


FROM docker.io/alpine:3.17 as runner
COPY --from=builder /etc/apk/keys/builder* /etc/apk/keys/

RUN --mount=type=cache,target=/packages/ \
apk add --repository /packages/sr.ht git.sr.ht
RUN apk add nginx fcgiwrap git git-daemon
COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf
COPY ./sshd_config /etc/sshd/sshd_config

RUN echo "*/20 * * * *  /usr/bin/gitsrht-periodic" >> /etc/crontab

CMD ["/bin/sh", "start.sh"]
