FROM ruby:3.1.2

RUN apt-get update && apt-get install -y \
  curl \
  build-essential \
  libpq-dev \
  nodejs 

RUN gem install bundler --no-document
WORKDIR /usr/src/share_videos

COPY Gemfile* ./
RUN bundle config --global path /bundle/cache
RUN bundle install

COPY . ./
EXPOSE 3000