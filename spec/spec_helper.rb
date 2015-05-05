ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/its'
require 'fakeredis/rspec'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.order = 'random'
  config.run_all_when_everything_filtered = true
end
