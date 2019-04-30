source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem 'responders'
gem "resque-status"
gem 'rails', '~> 4.1.0'
gem 'sqlite3', '~> 1.3.6'

group :test do
  gem "ejs"
end
