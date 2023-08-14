# frozen_string_literal: true

require 'test_helper'

class WorkerCalculatorTest < ActiveSupport::TestCase
  subject { WorkerCalculator.new }

  describe 'methods' do
    it 'responds' do
      assert_respond_to subject, :worker_count
    end
  end

  describe '#worker_count' do
    it 'returns the appropriate number of workers for a given number of jobs' do
      assert_equal 1, subject.worker_count(job_count: 0)
      assert_equal 1, subject.worker_count(job_count: 275)
      assert_equal 5, subject.worker_count(job_count: 500)
      assert_equal 10, subject.worker_count(job_count: 2000)
    end
  end
end
