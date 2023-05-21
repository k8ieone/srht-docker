#!/bin/bash
set -e

gitsrht-initdb

# git.sr.ht
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/git.sr.ht/git.sr.ht.initd
/usr/bin/gunicorn hgsrht.app:app \
    -b 127.0.0.1:5010 \
    -c /etc/sr.ht/hg.sr.ht.gunicorn.conf.py &

# git.sr.ht-api
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/git.sr.ht/git.sr.ht-api.initd
/usr/bin/hgsrht-api \
    -b 127.0.0.1:5110 &

/usr/bin/celery \
    -A hgsrht.webhooks worker \
    --loglevel=info &

nginx &

tail -f /dev/null
