# Use Ruby 3.2.5 official image
FROM ruby:3.2.5

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile and Gemfile.lock (if exists)
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy application code
COPY . .

CMD ["bundle", "exec", "ruby", "main.rb"]
