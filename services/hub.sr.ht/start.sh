#!/bin/bash
set -e

hubsrht-initdb

# hub.sr.ht-web
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/hub.sr.ht/hub.sr.ht.initd
/usr/bin/gunicorn hubsrht.app:app \
    -c /etc/sr.ht/hub.sr.ht.gunicorn.conf.py \
    -b 0.0.0.0:5014 &

# hub.sr.ht-api
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/hub.sr.ht/hub.sr.ht-api.initd
/usr/bin/hubsrht-api \
    -b 0.0.0.0:5114 &

nginx &

tail -f /dev/null
