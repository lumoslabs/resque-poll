class ResquePoll::JobsController < ResquePoll::ApplicationController
  respond_to :json

  before_filter :require_authentication

  ssl_allowed :show

  def show
    status = Resque::Plugins::Status::Hash.get(params.require(:id))
    if status.nil?
      head :not_found
    else
      render json: status, status: :ok
    end
  end

  private

  def require_authentication
    auth_method = ResquePoll::Engine.config.authentication_method
    send(auth_method) if auth_method && defined?(auth_method)
  end
end
