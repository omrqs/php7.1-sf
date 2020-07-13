FROM php:7.4-alpine

RUN apk add --virtual --update --no-cache $PHPIZE_DEPS \
    openssl \
    git \
    tzdata \
    unzip \
    gnupg \
    icu-dev \
    libpng-dev \
    jpeg-dev \
    libmcrypt-dev \
    libzip-dev \
    zlib-dev \
    logrotate \
    ca-certificates \
    supervisor \
    && rm -rf /var/cache/apk/* /var/lib/apk/* or /etc/apk/cache/*

RUN pecl install xdebug-2.9.0

RUN update-ca-certificates

RUN docker-php-ext-install opcache pdo_mysql intl json gd zip bcmath pcntl
RUN docker-php-ext-enable xdebug opcache

# Install Composer, symfony installer and global deps
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require hirak/prestissimo friendsofphp/php-cs-fixer
RUN export PATH="$PATH:$HOME/.composer/vendor/bin"
RUN curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony && \
    chmod a+x /usr/local/bin/symfony

# Set timezone and cleanup apk cache
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

WORKDIR /var/www
