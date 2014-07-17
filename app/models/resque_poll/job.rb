class ResquePoll::Job
  extend ActiveModel::Naming

  attr_reader :klass, :params, :job_id

  def initialize(klass, params)
    @klass  = klass
    @params = params
  end

  def self.create(*args)
    new(*args).create
  end

  def create
    @job_id = klass.create(params)
    self
  end

  def as_json(options = {})
    {poll: job_path}
  end

  private

  def job_path
    job_id ? ResquePoll::Engine.routes.url_helpers.job_path(id: job_id) : nil
  end
end
