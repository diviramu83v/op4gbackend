# frozen_string_literal: true

require 'test_helper'

class TrafficAnalyzerTest < ActiveSupport::TestCase
  setup do
    @onboarding = onboardings(:standard)
    @onboarding.onramp.update!(check_clean_id: true)
  end

  describe '#failed_pre_survey?' do
    describe 'test mode on' do
      setup do
        @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: true, request: ActionDispatch::Request.new('test'))
      end

      describe 'all analysis passing' do
        setup do
          TrafficStep.any_instance.expects(:failed?).never
        end

        test 'returns false' do
          assert_not @analyzer.failed_pre_survey?
        end
      end

      describe 'step failure' do
        setup do
          TrafficStep.any_instance.expects(:failed?).never
        end

        test 'returns true' do
          assert_not @analyzer.failed_pre_survey?
        end
      end

      describe 'ip inconsistency' do
        setup do
          @step = @onboarding.traffic_steps.first
          create_ip_inconsistency(@step)
        end

        test 'returns true' do
          assert_not @analyzer.failed_pre_survey?
        end
      end

      describe 'ip blocked' do
        setup do
          ip_address = @onboarding.traffic_checks.first.ip_address
          ip_address.manually_block
        end

        it 'should return true' do
          assert_not @analyzer.failed_pre_survey?
        end
      end

      describe 'some steps incomplete' do
        setup do
          @step = @onboarding.traffic_steps.first
          @step.update!(status: 'incomplete')
        end

        it 'should return true' do
          assert_not @analyzer.failed_pre_survey?
        end
      end
    end

    describe 'onramp security off' do
      setup do
        @onboarding.onramp.update!(ignore_security_flags: true)
        @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: false, request: ActionDispatch::Request.new('test'))
      end

      test 'returns false' do
        assert_not @analyzer.failed_pre_survey?
      end
    end

    describe 'test mode off' do
      setup do
        @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: false, request: ActionDispatch::Request.new('test'))
      end

      describe 'all analysis passing' do
        setup do
          TrafficStep.any_instance.expects(:failed?).returns(false).at_least_once
          ActionDispatch::Request.any_instance.stubs(:is_crawler?).returns(false)
        end

        test 'returns false' do
          assert_not @analyzer.failed_pre_survey?
        end
      end

      describe 'step failure' do
        setup do
          TrafficStep.any_instance.expects(:failed?).returns(true).at_least_once
          ActionDispatch::Request.any_instance.stubs(:is_crawler?).returns(false)
          stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
            .to_return(status: 200,
                       body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                       headers: { 'Content-Type' => 'application/json' })
        end

        test 'returns true' do
          assert @analyzer.failed_pre_survey?
        end
      end

      describe 'ip inconsistency' do
        setup do
          @step = @onboarding.traffic_steps.first
          create_ip_inconsistency(@step)
          ActionDispatch::Request.any_instance.stubs(:is_crawler?).returns(false)
        end

        test 'returns true' do
          assert @analyzer.failed_pre_survey?
        end
      end

      describe 'ip aleady used' do
        setup do
          ActionDispatch::Request.any_instance.stubs(:is_crawler?).returns(false)
          create_duplicate_ip_address
          stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
            .to_return(status: 200,
                       body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                       headers: { 'Content-Type' => 'application/json' })
        end

        it 'returns true' do
          assert @analyzer.failed_pre_survey?
        end
      end

      describe 'ip blocked' do
        setup do
          ip_address = @onboarding.traffic_checks.first.ip_address
          ip_address.manually_block
          ActionDispatch::Request.any_instance.stubs(:is_crawler?).returns(false)
          stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
            .to_return(status: 200,
                       body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                       headers: { 'Content-Type' => 'application/json' })
        end

        it 'should return true' do
          assert @analyzer.failed_pre_survey?
        end
      end
    end
  end

  describe '#failed_post_survey?' do
    describe 'test mode on' do
      setup do
        @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: true, request: ActionDispatch::Request.new('test'))
      end

      describe 'all analysis passing' do
        setup do
          TrafficStep.any_instance.expects(:failed?).never
        end

        test 'returns false' do
          assert_not @analyzer.failed_post_survey?
        end
      end

      describe 'step failure' do
        setup do
          TrafficStep.any_instance.expects(:failed?).never
        end

        test 'returns true' do
          assert_not @analyzer.failed_post_survey?
        end
      end

      describe 'ip inconsistency' do
        setup do
          @step = @onboarding.traffic_steps.first
          create_ip_inconsistency(@step)
        end

        test 'returns true' do
          assert_not @analyzer.failed_post_survey?
        end
      end
    end

    describe 'onramp security off' do
      setup do
        @onboarding.onramp.update!(ignore_security_flags: true)
        @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: false, request: ActionDispatch::Request.new('test'))
      end

      test 'returns false' do
        assert_not @analyzer.failed_post_survey?
      end
    end

    describe 'test mode off' do
      setup do
        @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: false, request: ActionDispatch::Request.new('test'))
      end

      describe 'all analysis passing' do
        setup do
          @onboarding.update!(survey_response_url: survey_response_urls(:complete))
          Survey.any_instance.expects(:uses_return_keys?).returns(false)
          stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
            .to_return(status: 200,
                       body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                       headers: { 'Content-Type' => 'application/json' })
        end

        test 'returns false' do
          assert_not @analyzer.failed_post_survey?
        end
      end

      describe 'step failure' do
        setup do
          @onboarding.update!(survey_response_url: survey_response_urls(:complete))
          stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
            .to_return(status: 200,
                       body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                       headers: { 'Content-Type' => 'application/json' })
        end

        test 'returns true' do
          assert @analyzer.failed_post_survey?
        end
      end

      describe 'ip inconsistency' do
        setup do
          @step = @onboarding.traffic_steps.first
          create_ip_inconsistency(@step)
          @onboarding.update!(survey_response_url: survey_response_urls(:complete))
          stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
            .to_return(status: 200,
                       body: '{"result": { "Score": 0, "ORScore": 0.45, "Duplicate": false}}',
                       headers: { 'Content-Type' => 'application/json' })
        end

        test 'returns true' do
          assert @analyzer.failed_post_survey?
        end
      end
    end
  end

  describe '#failed_prescreener?' do
    setup do
      @analyzer = TrafficAnalyzer.new(onboarding: @onboarding, test_mode: true, request: ActionDispatch::Request.new('test'))
    end

    it 'should pass because prescreener is disabled on the onramp' do
      assert_not @analyzer.failed_prescreener?
    end

    it 'should fail the prescreener' do
      PrescreenerQuestion.any_instance.expects(:question_failed?).returns(true).at_least_once
      @onboarding.onramp.update(check_prescreener: true)
      @onboarding.prescreener_questions.first.complete!
      assert @analyzer.failed_prescreener?
    end
  end

  private

  def create_ip_inconsistency(traffic_step)
    traffic_step.traffic_checks.create!(
      [
        { controller_action: 'new', ip_address: IpAddress.first, status: 'N/A' },
        { controller_action: 'create', ip_address: IpAddress.last, status: 'N/A' }
      ]
    )
  end

  def create_duplicate_ip_address
    @onboarding.survey.onboardings.each do |onboarding|
      onboarding.update!(ip_address: @onboarding.ip_address)
    end
  end
end
