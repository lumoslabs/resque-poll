class DoesNothingJob
  include Resque::Plugins::Status

  def perform
    completed('stuff_i_did' => 'foo')
  end
end
