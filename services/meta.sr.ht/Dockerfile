#!/usr/bin/env -S docker build . -t meta.sr.ht --file

FROM sr.ht-base

RUN apk add meta.sr.ht
RUN apk add nginx

COPY ./start.sh /
COPY ./nginx.conf /etc/nginx/http.d/default.conf

RUN echo "0	2	*	*	*  /usr/bin/metasrht-daily" >>/etc/crontab

USER nginx
CMD ["/bin/sh", "start.sh"]
