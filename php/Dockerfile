FROM php:8.2-fpm

RUN apt update
RUN apt install -y zip libzip-dev libpng-dev libicu-dev libxml2-dev cron systemctl vim
RUN docker-php-ext-install mysqli pdo pdo_mysql gd zip intl xml

RUN echo "*/5 * * * * root /usr/local/bin/php /phpScripts/import_eic.php > /proc/1/fd/1 2>/proc/1/fd/2" >> /etc/crontab

CMD ["cron","-f"]


