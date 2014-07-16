$:.push File.expand_path("../lib", __FILE__)

require "resque_poll/version"

Gem::Specification.new do |s|
  s.name        = "resque-poll"
  s.version     = ResquePoll::VERSION
  s.authors     = ["Anthony Zacharakis"]
  s.email       = ["anthony@lumoslabs.com"]
  s.homepage    = "https://www.lumosity.com"
  s.summary     = "A resque-based web poller"
  s.description = "A resque-based web poller"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "bartt-ssl_requirement", '~> 1.4.2'
  s.add_dependency "rails"
  s.add_dependency "resque-status"
  s.add_dependency "strong_parameters"

  s.add_development_dependency "fakeredis"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec-rails", "~> 2.14"
  s.add_development_dependency "sqlite3"
end
