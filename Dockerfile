FROM ruby:3.0.0 AS auth_app

# Default directory
WORKDIR /app

COPY Gemfile Gemfile.lock ./

# Install the required gems
RUN bundle install

# Copy the rest of the application code to the container
COPY . .

ENV RAILS_ENV=development

ENV POSTGRES_HOST=auth_development
ENV POSTGRES_PORT=5432

EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
