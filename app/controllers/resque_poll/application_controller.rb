module ResquePoll
  class ApplicationController < ActionController::Base
    include ::SslRequirement
  end
end
