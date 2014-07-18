require 'spec_helper'
require 'support/does_nothing_job'

describe ResquePoll::Job do
  let(:job) { ResquePoll::Job.new(DoesNothingJob, args) }
  let(:args) { {foo: 'bar'} }

  describe '#create' do
    subject { job.create }

    it 'creates the resque job' do
      DoesNothingJob.should_receive(:create).with(args)
      subject
    end

    it 'returns self' do
      subject.should == job
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
      before { job.stub(job_id: 'some-job-id') }

      it 'has a poll attribute' do
        expect(subject[:poll]).to be_present
      end
    end
  end
end
