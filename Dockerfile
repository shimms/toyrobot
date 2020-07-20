FROM ruby:2.7.1-alpine3.12

WORKDIR /toyrobot

COPY . .

RUN bundle config set without 'development'
RUN bundle install

CMD ["bin/toyrobot"]
