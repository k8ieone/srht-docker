FROM base as builder
RUN apk add git alpine-sdk sudo nodejs
RUN adduser -D builder
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && chmod 0440 /etc/sudoers.d/builder
RUN sudo -u builder abuild-keygen -a -i -n
RUN addgroup builder abuild
RUN git clone https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds
RUN chown -R builder:builder /sr.ht-apkbuilds

WORKDIR /sr.ht-apkbuilds/sr.ht/meta.sr.ht
# Currently there is one file which fails the checksum check
ADD version.txt /
RUN sed -i '/pkgver=/c\pkgver=$(cat /version.txt)' APKBUILD
RUN sudo -u builder abuild checksum
RUN sudo -u builder abuild -r
# Copy the packages into a cache
RUN --mount=type=cache,target=/packages/ cp -r /home/builder/packages/ /


FROM docker.io/alpine:3.17 as runner
COPY --from=builder /etc/apk/keys/builder* /etc/apk/keys/

RUN --mount=type=cache,target=/packages/ \
apk add --repository /packages/sr.ht meta.sr.ht
RUN apk add nginx
COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf

RUN echo "0	2	*	*	*  /usr/bin/metasrht-daily" >>/etc/crontab

USER nginx
CMD ["/bin/sh", "start.sh"]
