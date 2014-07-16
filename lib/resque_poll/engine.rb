module ResquePoll
  class Engine < ::Rails::Engine
    isolate_namespace ResquePoll

    config.authentication_method = nil
  end
end
