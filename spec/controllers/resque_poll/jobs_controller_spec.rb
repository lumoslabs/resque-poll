require 'spec_helper'
require 'support/does_nothing_job'

describe ResquePoll::JobsController, type: :controller do
  routes { ResquePoll::Engine.routes }

  describe 'GET show' do
    subject do
      if Rails::VERSION::MAJOR >= 5
        get :show, params: { id: job_id, format: :json }
      else
        get :show, { id: job_id, format: :json }
      end
      response
    end

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

      before { allow(Resque).to receive_messages(inline?: true) }

      its(:status) { should eql(200) }

      it 'contains the job information in the response' do
        body = JSON.parse(subject.body)
        expect(body['status']).to eql('completed')
        expect(body['stuff_i_did']).to eql('foo')
      end
    end
  end
end
