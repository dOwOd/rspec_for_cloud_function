FROM ruby:2.6
WORKDIR /app
COPY Gemfile /app/Gemfile
RUN gem install rspec \
    && bundle install