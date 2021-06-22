#FROM ruby:latest
FROM 264326320119.dkr.ecr.us-east-2.amazonaws.com/ruby:latest
RUN bundle config --global frozen 1

WORKDIR /usr/src/myapp

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.2.16 puma foreman 
RUN bundle install

COPY . .

CMD ["bundle", "exec", "foreman", "start"]