require 'spec_helper'
require 'support/does_nothing_job'

describe ResquePoll::Job do
  let(:job) { ResquePoll::Job.new(DoesNothingJob, args) }
  let(:args) { {foo: 'bar'} }

  describe '#create' do
    subject { job.create }

    it 'creates the resque job' do
      expect(DoesNothingJob).to receive(:create).with(args)
      subject
    end

    it 'returns self' do
      expect(subject).to eq(job)
    end
  end

  describe '#as_json' do
    subject { job.as_json }

    context 'without a job id' do
      it 'does not have a poll attribute' do
        expect(subject[:poll]).to be_nil
      end
    end

    context 'with a job id' do
      before { allow(job).to receive_messages(job_id: 'some-job-id') }

      it 'has a poll attribute' do
        expect(subject[:poll]).to be_present
      end
    end
  end
end
