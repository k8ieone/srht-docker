#!/bin/bash
set -e

sr.ht-migrate meta.sr.ht upgrade head
meta.sr.ht-migrate upgrade head

# meta.sr.ht
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/meta.sr.ht/meta.sr.ht.initd
mkdir /run/meta.sr.ht
chown -R srht:srht /run/meta.sr.ht
chmod 775 /run/meta.sr.ht
sudo -u srht prometheus_multiproc_dir=/run/meta.sr.ht /usr/bin/gunicorn metasrht.app:app \
    -b 0.0.0.0:5000 \
    -c /etc/sr.ht/meta.sr.ht.gunicorn.conf.py &

# meta.sr.ht-api
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/meta.sr.ht/meta.sr.ht-api.initd
sudo -u srht /usr/bin/meta.sr.ht-api \
    -b 0.0.0.0:5100 &

# meta.sr.ht-webhooks
# https://git.sr.ht/~sircmpwn/sr.ht-apkbuilds/tree/master/item/sr.ht/meta.sr.ht/meta.sr.ht-webhooks.initd
sudo -u srht /usr/bin/celery \
    -A metasrht.webhooks worker \
    --loglevel=info &

nginx &

tail -f /dev/null
