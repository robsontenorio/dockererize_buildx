FROM ubuntu:24.04

LABEL maintainer="Robson Tenório"
LABEL site="https://github.com/robsontenorio/laravel-docker"

ENV TZ=UTC
ENV LANG="C.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive
ARG CONTAINER_ROLE=APP
ENV CONTAINER_ROLE=${CONTAINER_ROLE}

WORKDIR /var/www/app

RUN apt update \
  # Add PHP 8.4 repository
  && apt install -y software-properties-common && add-apt-repository ppa:ondrej/php \
  # PHP extensions
  && apt install -y \
  php8.4-cli \
  # Extra
  curl \  
  unzip 

# Composer
RUN curl -sS https://getcomposer.org/installer  | php -- --install-dir=/usr/bin --filename=composer

# Node, NPM, Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt install -y nodejs && npm -g install yarn --unsafe-perm

# Create user/group with id/uid (1000/1000)
RUN userdel ubuntu
RUN groupadd -f -g 1000 appuser
RUN useradd -u 1000 -m -d /home/appuser -g appuser appuser


# Switch to non-root user
USER appuser

# Laravel Installer
RUN composer global require laravel/installer && composer clear-cache


# Start services through "supervisor" based on "CONTAINER_ROLE". See "start.sh".
CMD ["/usr/local/bin/start"]
