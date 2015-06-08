$:.push File.expand_path('../lib', __FILE__)

require 'resque_poll/version'

Gem::Specification.new do |s|
  s.name        = 'resque-poll'
  s.version     = ResquePoll::VERSION
  s.authors     = ['Anthony Zacharakis']
  s.email       = ['anthony@lumoslabs.com']
  s.homepage    = 'https://www.lumosity.com'
  s.summary     = 'A resque-based web poller'
  s.description = 'A resque-based web poller'

  s.files = Dir["{app,config,db,lib}/**/*"] + ['MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '4.0.0'
  s.add_dependency 'resque-status', '~> 0.5'

  s.add_development_dependency 'fakeredis'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec-its', '~> 1.1.0'
  s.add_development_dependency 'rspec-rails', '~> 3.2.1'
  s.add_development_dependency 'sqlite3'
end
