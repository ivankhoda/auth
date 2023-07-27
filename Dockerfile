FROM ruby:3.0.0 AS auth_app

RUN apt-get update && apt-get install -y curl build-essential gnupg postgresql-client

RUN gem install bundler --no-document -v '2.4.13'

# Default directory
WORKDIR /app
COPY . /app

# Install the required gems
RUN bundle check || bundle install
