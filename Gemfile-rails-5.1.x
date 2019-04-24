source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem "resque-status"
gem 'rails', '~> 5.1.0'
gem 'responders'
gem 'rspec-rails', '~> 3.5.0'

group :test do
  gem "ejs"
  gem 'jasmine'
  gem "sinon-chai-rails"
end
