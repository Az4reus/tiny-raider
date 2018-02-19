FROM alpine

COPY src                /usr/app/src
COPY credentials.secret /usr/app
COPY Gemfile            /usr/app

WORKDIR /usr/app/

RUN apk --update add --no-cache --virtual build-deps build-base libffi-dev ruby-dev \
    && apk --update add --no-cache ruby ruby-bundler \
    && bundle install \
    && apk del build-deps

ENTRYPOINT bundle exec ruby src/bot.rb $(cat credentials.secret)
