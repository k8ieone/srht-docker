#!/bin/bash
set -e

metasrht-initdb

# meta.sr.ht
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/meta.sr.ht/meta.sr.ht.initd
/usr/bin/gunicorn metasrht.app:app \
    -b 127.0.0.1:5000 \
    -c /etc/sr.ht/meta.sr.ht.gunicorn.conf.py \
    -D

# meta.sr.ht-api
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/meta.sr.ht/meta.sr.ht-api.initd
/usr/bin/metasrht-api \
    -b 127.0.0.1:5100 &

# meta.sr.ht-webhooks
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/meta.sr.ht/meta.sr.ht-webhooks.initd
/usr/bin/celery \
    -A metasrht.webhooks worker \
    --loglevel=info &

nginx &

tail -f /dev/null
