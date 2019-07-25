FROM ubuntu:18.04

LABEL maintainer="//SEIBERT/MEDIA GmbH  <docker@seibert-media.net>"

ARG FRAPPE_VERSION=v11.1.43
ARG ERPNEXT_VERSION=v11.1.48
ARG BENCH_VERSION=master

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends \
	apt-transport-https \
	build-essential \
	ca-certificates \
	cron \
	curl \
	fontconfig \
	git \
	gpg-agent \
	iputils-ping \
	language-pack-en \
	libffi-dev \
	libfreetype6-dev \
	libjpeg8-dev \
	liblcms2-dev \
	libldap2-dev \
	libmysqlclient-dev \
	libsasl2-dev \
	libssl1.0-dev \
	libtiff5-dev \
	libwebp-dev \
	libxext6 \
	libxrender1 \
	locales \
	mariadb-client \
	mariadb-common \
	nodejs \
	npm \
	python-dev \
	python-pip \
	python-setuptools \
	python-wheel \
	python3-distutils \
	redis-tools \
	redis-server \
	rlwrap \
	software-properties-common \
	ssh \
	tcl8.6-dev \
	tk8.6-dev \
	wkhtmltopdf \
	xfonts-75dpi \
	xfonts-base \
	zlib1g-dev \
	supervisor \
	nginx \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

ENV PYTHONIOENCODING=utf-8
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8

RUN groupadd -g 500 frappe
RUN useradd -ms /bin/bash -u 500 -g 500 frappe

RUN curl --connect-timeout 10 --max-time 120 -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb > wkhtmltopdf.deb \
	&& dpkg -i wkhtmltopdf.deb \
	&& rm wkhtmltopdf.deb

RUN pip install virtualenv
RUN npm install -g yarn

RUN git clone -b ${BENCH_VERSION} https://github.com/frappe/bench.git bench-repo
RUN pip install -e bench-repo

USER frappe
WORKDIR /home/frappe
ENV PATH=/home/frappe/.local/bin:$PATH

RUN bench init frappe-bench --skip-redis-config-generation
WORKDIR /home/frappe/frappe-bench
RUN bench get-app erpnext https://github.com/frappe/erpnext
RUN bench setup supervisor
RUN bench setup nginx
COPY new-site.sh /new-site.sh

USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/sites-available/default

COPY entrypoint.sh /entrypoint.sh
# RUN /home/frappe/bench-repo/env/bin/pip install html5lib uwsgi

ENTRYPOINT ["/entrypoint.sh"]
