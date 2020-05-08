FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN set -xe \
    && apt-get update \
    && apt install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        locales \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

# Опциональные зависимости Linux (см. ИТС)
# Разработка и администрирование - 1С:Предприятие <версия> документация
# Руководство администратора - Требования к аппаратуре и программному обеспечению - Прочие требования - Для ОС Linux
# Руководство пользователя - Глава 2. Установка и обновление системы -  Особенности установки системы в ОС Linux
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagickwand-6.q16-3 \
        libfreetype6 \
        libwebkitgtk-3.0-0 \
        unixodbc \
        libfontconfig1 \
        libgsf-1-114 \
        libglib2.0-0 \
        libodbc1 \
        libkrb5-3 \
        libgssapi-krb5-2

# Установка шритов MS из репо Debian.
# Родные из Ubuntu Multiverse сломаны в текущей версии
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends cabextract xfonts-utils  libmspack0 xfonts-encodings \
    && wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.7_all.deb -O ttf-mscorefonts-installer.deb \
    && echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
    && dpkg -i ttf-mscorefonts-installer.deb \
    && rm ttf-mscorefonts-installer.deb \
    && cp -R /usr/share/fonts/truetype/msttcorefonts/ /usr/share/fonts/truetype/msttcorefonts_/ \
    && apt-get autoremove -y --purge \
        cabextract \
        xfonts-utils \
        libmspack0 \
        xfonts-encodings \
    && mv /usr/share/fonts/truetype/msttcorefonts_/ /usr/share/fonts/truetype/msttcorefonts/ \
    && rm -rf /var/lib/apt/lists/* \
    && fc-cache –fv 

# Установим поддержку русского языка
RUN apt-get update \
 && apt-get install -y language-pack-ru

ENV LANGUAGE ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

ARG onec_uid="1000"
ARG onec_gid="1000"

RUN groupadd -r grp1cv8 --gid=$onec_gid \
  && useradd -r -g grp1cv8 --uid=$onec_uid --home-dir=/home/usr1cv8 --shell=/bin/bash usr1cv8 \
  && mkdir -p /var/log/1C /home/usr1cv8/.1cv8/1C/1cv8/conf \
  && chown -R usr1cv8:grp1cv8 /var/log/1C /home/usr1cv8

ARG gosu_ver=1.11

ADD https://github.com/tianon/gosu/releases/download/$gosu_ver/gosu-amd64 /bin/gosu

RUN chmod +x /bin/gosu

