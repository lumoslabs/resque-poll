source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem "resque-status"
gem 'rails', '~> 4.1.0'

group :test di
  gem "ejs"
  gem 'jasmine'
  gem "sinon-chai-rails"
end
