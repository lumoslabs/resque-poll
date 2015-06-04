class ResquePoll::JobsController < ResquePoll::ApplicationController
  respond_to :json

  def show
    status = Resque::Plugins::Status::Hash.get(params.require(:id))
    if status.nil?
      head :not_found
    else
      render json: status, status: :ok
    end
  end
end
