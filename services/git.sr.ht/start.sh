#!/bin/bash
set -e

gitsrht-initdb

# git.sr.ht
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/git.sr.ht/git.sr.ht.initd
/usr/bin/gunicorn gitsrht.app:app \
    -b 127.0.0.1:5001 \
    -c /etc/sr.ht/git.sr.ht.gunicorn.conf.py \
    -D

# git.sr.ht-api
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/git.sr.ht/git.sr.ht-api.initd
/usr/bin/gitsrht-api \
    -b 127.0.0.1:5101 &

/usr/bin/celery \
    -A gitsrht.webhooks worker \
    --loglevel=info &

/usr/bin/fcgiwrap \
    -s unix:/run/fcgiwrap/fcgiwrap.sock &
nginx &

sshd &

tail -f /dev/null
