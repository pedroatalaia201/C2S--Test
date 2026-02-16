FROM ruby:2.7.7

RUN apt-get update -q && apt-get install -y \
  postgresql-client \
  build-essential \
  libpq-dev \
  libffi-dev

WORKDIR /app

RUN gem install bundler:2.4.22
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Each of the services will expose a different port due the docker-compose.yml
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
