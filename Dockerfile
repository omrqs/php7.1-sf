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
    bash \
    && rm -rf /var/cache/apk/* /var/lib/apk/* or /etc/apk/cache/*

RUN pecl install xdebug-2.9.0 mongodb

RUN update-ca-certificates

RUN docker-php-ext-install opcache pdo_mysql intl json gd zip bcmath pcntl
RUN docker-php-ext-enable xdebug opcache mongodb

# Install composer, symfony installer and global deps.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    export PATH="$PATH:$HOME/.composer/vendor/bin"

RUN composer global require hirak/prestissimo friendsofphp/php-cs-fixer

RUN curl -LsS https://get.symfony.com/cli/installer -o /usr/local/bin/symfony && \
    chmod a+x /usr/local/bin/symfony && \
    symfony && \
    export PATH="$HOME/.symfony/bin:$PATH"

# Set timezone and cleanup apk cache
RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime

WORKDIR /var/www
