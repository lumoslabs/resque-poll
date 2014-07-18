require 'spec_helper'

describe ResquePoll::JobsController do
  routes { ResquePoll::Engine.routes }

  class DoesNothingJob
    include Resque::Plugins::Status

    def perform
      completed('stuff_i_did' => 'foo')
    end
  end

  describe 'GET show' do
    subject { get :show, {id: job_id, format: :json}; response }

    context 'with a non-existent job ID' do
      let(:job_id) { 'non-existent' }

      its(:status) { should eql(404) }
    end

    context 'with a queued job' do
      let(:job_id) { DoesNothingJob.create }

      its(:status) { should eql(200) }

      it 'contains the job information in the response' do
        body = JSON.parse(subject.body)
        expect(body['status']).to eql('queued')
      end
    end

    context 'with a completed job' do
      let(:job_id) { DoesNothingJob.create }

      before { Resque.stub(inline?: true) }

      its(:status) { should eql(200) }

      it 'contains the job information in the response' do
        body = JSON.parse(subject.body)
        expect(body['status']).to eql('completed')
        expect(body['stuff_i_did']).to eql('foo')
      end
    end
  end
end
