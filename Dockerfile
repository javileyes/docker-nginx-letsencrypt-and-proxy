FROM nginx

RUN apt-get -y update
RUN apt-get -y install certbot python-certbot-nginx cron vim

RUN crontab /etc/cron.d/certbot

#COPY ./conf.d/default.conf /etc/nginx/conf.d/default.conf

COPY launcher.sh /usr/local/bin/launcher.sh
RUN chmod +x /usr/local/bin/launcher.sh

CMD ["/usr/local/bin/launcher.sh"]

#CMD ["nginx", "-g", "daemon off;"]

