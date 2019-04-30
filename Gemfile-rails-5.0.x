source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem "resque-status"
gem 'rails', '~> 5.0.0'
gem 'responders'
gem 'rspec-rails', '~> 3.5.0'
gem 'sqlite3', '~> 1.3.6'

group :test do
  gem "ejs"
end
