FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="Kyle Mathews <mathews.kyle@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install --yes --no-install-recommends ansible ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

COPY . /opt/config
WORKDIR /opt/config

RUN ansible-galaxy collection install --requirements-file requirements.yml \
    && ansible-playbook --inventory localhost, --connection local dev.yml

CMD ["zsh"]
