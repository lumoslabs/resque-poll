Rails.application.routes.draw do
  mount ResquePoll::Engine => "/resque_poll"
end
