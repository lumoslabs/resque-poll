ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../spec/dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'fakeredis/rspec'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter = :documentation
  config.order = 'random'
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
