FROM ruby:2.6.8-alpine3.13 AS base

# Author's information
LABEL maintainer="jean.toure@ngser.com"

# Install dependances
ENV BUNDLER_VERSION=2.0.2

RUN apk add --update --no-cache \
  binutils-gold \
  build-base \
  curl \
  file \
  g++ \
  gcc \
  git \
  less \
  libstdc++ \
  libffi-dev \
  libc-dev \
  linux-headers \
  libxml2-dev \
  libxslt-dev \
  libgcrypt-dev \
  make \
  netcat-openbsd \
  openssl \
  pkgconfig \
  postgresql-dev \
  python3 \
  nodejs \
  yarn \
  tzdata \
  openssh-client

# This stage will be responsible for installing gems
# Set the working directory of everything to the directory we just made.
WORKDIR /app
ADD . .
RUN rm -rf Gemfile.lock

RUN cp /app/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Copy the gemfile and gemfile.lock so we can run bundle on it
# Install and run bundle to get the app ready
RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle config set without 'test' && \
    bundle check || bundle install --jobs=3 --retry=3

#generation de credentials
RUN rm -rf /app/config/credentials.yml.enc
RUN rails credentials:edit

# Add a script to be executed every time the container starts.
ENTRYPOINT ["sh", "entrypoint.sh"]

# Expose port 3000 on the container
EXPOSE 3000

# Run the application on port 3000
CMD ["rails", "server", "-p", "3000", "-b", "0.0.0.0"]
