FROM base AS builder
RUN apk add git alpine-sdk sudo nodejs
RUN adduser -D builder
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && chmod 0440 /etc/sudoers.d/builder
RUN sudo -u builder abuild-keygen -a -i -n
RUN addgroup builder abuild
RUN git clone https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds
RUN chown -R builder:builder /sr.ht-apkbuilds

WORKDIR /sr.ht-apkbuilds/sr.ht/hub.sr.ht
ADD version.txt /
RUN sed -i '/pkgver=/c\pkgver=$(cat /version.txt)' APKBUILD
RUN sudo -u builder abuild checksum
RUN sudo -u builder abuild -r -K
# Copy the packages into a cache
RUN --mount=type=cache,target=/packages/ cp -r /home/builder/packages/ /


FROM docker.io/library/alpine:3.20 AS runner
COPY --from=builder /etc/apk/keys/builder* /etc/apk/keys/

RUN --mount=type=cache,target=/packages/ \
apk add --repository /packages/sr.ht hub.sr.ht py3-yaml
RUN apk add nginx
COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf

CMD ["/bin/sh", "start.sh"]
