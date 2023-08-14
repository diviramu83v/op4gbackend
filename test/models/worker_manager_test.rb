# frozen_string_literal: true

require 'test_helper'

class WorkerManagerTest < ActiveSupport::TestCase
  describe '#scale' do
    describe 'worker scaling' do
      describe 'busy workers' do
        describe 'needs scaling up' do
          setup do
            SidekiqManager.any_instance.expects(:job_count).returns(5000)
            HerokuManager.any_instance.expects(:worker_count).returns(1)
            WorkerCalculator.any_instance.expects(:worker_count).returns(5)
          end

          it 'tells heroku to scale' do
            skip_in_ci
            HerokuManager.any_instance.expects(:scale_workers).once
            WorkerManager.new.scale
          end
        end

        describe 'needs scaling down' do
          setup do
            SidekiqManager.any_instance.stubs(:busy_workers?).returns(true)

            SidekiqManager.any_instance.expects(:job_count).returns(0)
            HerokuManager.any_instance.expects(:worker_count).returns(3)
            WorkerCalculator.any_instance.expects(:worker_count).returns(1)
          end

          it 'does not tell heroku to scale' do
            skip_in_ci
            HerokuManager.any_instance.expects(:scale_workers).never
            WorkerManager.new.scale
          end
        end

        describe 'needs no scaling' do
          setup do
            SidekiqManager.any_instance.expects(:job_count).returns(300)
            HerokuManager.any_instance.expects(:worker_count).returns(3)
            WorkerCalculator.any_instance.expects(:worker_count).returns(3)
          end

          it 'does not tell heroku to scale' do
            skip_in_ci
            HerokuManager.any_instance.expects(:scale_workers).never
            WorkerManager.new.scale
          end
        end
      end

      describe 'no busy workers' do
        describe 'needs scaling up' do
          setup do
            SidekiqManager.any_instance.expects(:job_count).returns(5000)
            HerokuManager.any_instance.expects(:worker_count).returns(2)
            WorkerCalculator.any_instance.expects(:worker_count).returns(5)
          end

          it 'tells heroku to scale' do
            skip_in_ci
            HerokuManager.any_instance.expects(:scale_workers).once
            WorkerManager.new.scale
          end
        end

        describe 'needs scaling down' do
          setup do
            SidekiqManager.any_instance.stubs(:busy_workers?).returns(false)

            SidekiqManager.any_instance.expects(:job_count).returns(0)
            HerokuManager.any_instance.expects(:worker_count).returns(3)
            WorkerCalculator.any_instance.expects(:worker_count).returns(1)
          end

          it 'tells heroku to scale' do
            skip_in_ci
            HerokuManager.any_instance.expects(:scale_workers).once
            WorkerManager.new.scale
          end
        end

        describe 'needs no scaling' do
          setup do
            SidekiqManager.any_instance.expects(:job_count).returns(300)
            HerokuManager.any_instance.expects(:worker_count).returns(3)
            WorkerCalculator.any_instance.expects(:worker_count).returns(3)
          end

          it 'does not tell heroku to scale' do
            skip_in_ci
            HerokuManager.any_instance.expects(:scale_workers).never
            WorkerManager.new.scale
          end
        end
      end
    end
  end
end
