FROM base AS builder
RUN apk add git alpine-sdk sudo nodejs
RUN adduser -D builder
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/builder && chmod 0440 /etc/sudoers.d/builder
RUN sudo -u builder abuild-keygen -a -i -n
RUN addgroup builder abuild
RUN git clone https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds
RUN chown -R builder:builder /sr.ht-apkbuilds

WORKDIR /sr.ht-apkbuilds/sr.ht/meta.sr.ht
ADD version.txt /
RUN sed -i '/pkgver=/c\pkgver=$(cat /version.txt)' APKBUILD
# Currently there is one file which fails the checksum check
RUN sudo -u builder abuild checksum
RUN sudo -u builder abuild -r -K
# Copy the packages into a cache
RUN --mount=type=cache,target=/packages/ cp -r /home/builder/packages/ /


FROM docker.io/library/alpine:3.20 AS runner
COPY --from=builder /etc/apk/keys/builder* /etc/apk/keys/

RUN --mount=type=cache,target=/packages/ \
apk add --repository /packages/sr.ht meta.sr.ht
RUN apk add nginx sudo
RUN adduser -D srht
COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf
RUN echo "0	2	*	*	*  /usr/bin/metasrht-daily" >>/etc/crontab

# Enable init.
#RUN apk add --update --no-cache openrc && \
#    sed -i 's/^\(tty\d\:\:\)/#\1/g' /etc/inittab && \
#    sed -i \
#      -e 's/#rc_sys=".*"/rc_sys="docker"/g' \
#      -e 's/#rc_env_allow=".*"/rc_env_allow="\*"/g' \
#      -e 's/#rc_crashed_stop=.*/rc_crashed_stop=NO/g' \
#      -e 's/#rc_crashed_start=.*/rc_crashed_start=YES/g' \
#      -e 's/#rc_provide=".*"/rc_provide="loopback net"/g' \
#      /etc/rc.conf && \
#    rm -f /etc/init.d/hwdrivers \
#      /etc/init.d/hwclock \
#      /etc/init.d/hwdrivers \
#      /etc/init.d/modules \
#      /etc/init.d/modules-load \
#      /etc/init.d/modloop && \
#    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
#    sed -i 's/VSERVER/DOCKER/Ig' /lib/rc/sh/init.sh

#RUN rc-update add nginx default

CMD ["/bin/sh", "start.sh"]
#VOLUME [ “/sys/fs/cgroup” ]
#RUN ["/sbin/init"]
