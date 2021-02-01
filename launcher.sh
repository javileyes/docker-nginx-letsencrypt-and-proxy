#!/usr/bin/env bash

service cron start

if [ ! -e /etc/letsencrypt/live/$(hostname -f)/privkey.pem ]; then
	echo "No certificate found for $(hostname -f)"
 	if [ -n "$LETS_ENCRYPT_DOMAINS" ]; then 
                	LETS_ENCRYPT_ADDITIONAL_DOMAINS="--domains $LETS_ENCRYPT_DOMAINS"
        fi

        certbot certonly \
		--nginx \
                --non-interactive \
                --no-self-upgrade \
                --agree-tos \
                --email $LETS_ENCRYPT_EMAIL \
                --domain $(hostname -f) \
                $LETS_ENCRYPT_ADDITIONAL_DOMAINS

else
	echo "Certificate found for $(hostname -f)"
	certbot renew --no-self-upgrade
fi
#ESTE ÚLTIMO COMANDO QUITA EL DEMONIO EN SEGUNDO PLANO Y POR TANTO SE QUEDA EJECUTANDO NGINX EN PRIMER PLANO PARA QUE EL DOCKER SIGA EJECUTÁNDOSE
#nginx -g "daemon off;"  

