# syntax=docker/dockerfile:1

FROM python:3.9-alpine3.13
LABEL maintainer="Lakshmi"
WORKDIR /app
ENV PYTHONUNBUFFER 1
EXPOSE 8000

ARG DEV=false
# COPY requirements.txt /temp/requirements.txt
# COPY requirements.dev.txt /temp/requirements.dev.txt

RUN --mount=type=bind,src=requirements.txt,target=requirements.txt --mount=type=bind,src=requirements.dev.txt,target=requirements.dev.txt \
--mount=type=cache,target=/usr/lib/python3.9/site-packages \
python -m venv /py \
&& apk add --update --no-cache postgresql-client \
&& apk add --update --no-cache --virtual .tmp_build_deps \
    build-base postgresql-dev musl-dev \
&& /py/bin/pip install --upgrade pip \
&& /py/bin/pip install -r requirements.txt \
&& if [ $DEV ]; \
	then /py/bin/pip install -r requirements.dev.txt; \
fi \
# && rm -rf temp \
&& apk del .tmp_build_deps \
&& adduser -DH django-user

ENV PATH="/py/bin:$PATH"

USER django-user
