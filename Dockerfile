FROM sentry:9.0

WORKDIR /usr/src/sentry

ENV PYTHONPATH /usr/src/sentry

RUN sed -i 's@deb.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list \
    && sed -i 's@security.debian.org@mirrors.aliyun.com@g' /etc/apt/sources.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y libxslt1-dev libxml2-dev libpq-dev libldap2-dev libsasl2-dev libssl-dev

COPY . /usr/src/sentry

RUN if [ -s requirements.txt ]; then pip install -r requirements.txt; fi

RUN if [ -s setup.py ]; then pip install -e .; fi

RUN if [ -s sentry.conf.py ]; then cp sentry.conf.py $SENTRY_CONF/; fi \
	&& if [ -s config.yml ]; then cp config.yml $SENTRY_CONF/; fi

RUN apt-get remove -y -q libxslt1-dev libxml2-dev libpq-dev libldap2-dev libsasl2-dev libssl-dev
RUN rm -rf /var/lib/apt/lists/*
