source "https://rubygems.org"

gemspec

gem "coffee-rails"
gem "jquery-rails"
gem "resque-status"
gem 'rails', '~> 5.0.0'
gem 'responders'
gem 'rspec-rails', '~> 3.5.0'

group :test do
  gem "capybara"
  gem "capybara-webkit"
  gem "ejs"
  gem 'poltergeist'
  gem "konacha" # PR for rails 5 https://github.com/jfirebaugh/konacha/pull/233
  gem "konacha-chai-matchers"
  gem "sinon-chai-rails"
end
