source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem "resque-status"
gem 'rails', '~> 4.2.0'
gem 'responders'

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "ejs"
  gem 'poltergeist'
  gem "konacha"
  gem "konacha-chai-matchers"
  gem "sinon-chai-rails"
end
