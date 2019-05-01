source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem 'responders'
gem "resque-status"
gem 'rails', '~> 4.2.0'
gem 'responders'
gem 'sqlite3', '~> 1.3.6'

group :test do
  gem "ejs"
end
