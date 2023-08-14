# frozen_string_literal: true

require 'test_helper'

class TrafficStepTest < ActiveSupport::TestCase
  setup do
    @step = traffic_steps(:pre_clean_id)
  end

  describe '#security_service_survey_id' do
    test 'hashes survey/step/onramp values' do
      key = "#{@step.survey.id}|#{@step.when}|#{@step.onramp.relevant_id_level}"
      hash = Digest::SHA2.hexdigest(key)

      assert_equal hash, @step.security_service_survey_id
    end

    test 'survey ID affects hash' do
      original_hash = @step.security_service_survey_id

      Survey.any_instance.expects(:id).returns(123)
      new_hash = @step.security_service_survey_id

      assert_not_equal original_hash, new_hash
    end

    test 'step "when" affects hash' do
      original_hash = @step.security_service_survey_id

      TrafficStep.any_instance.expects(:when).returns('post')
      new_hash = @step.security_service_survey_id

      assert_not_equal original_hash, new_hash
    end

    test 'onramp relevant_id_level affects hash' do
      original_hash = @step.security_service_survey_id

      Onramp.any_instance.expects(:relevant_id_level).returns('project')
      new_hash = @step.security_service_survey_id

      assert_not_equal original_hash, new_hash
    end
  end

  describe '#complete_step' do
    setup do
      @traffic_step = traffic_steps(:pre_clean_id)
      @traffic_step.update!(status: 'incomplete')
    end

    it 'should set the status to complete' do
      assert_equal @traffic_step.status, 'incomplete'
      @traffic_step.complete_step
      assert_equal @traffic_step.status, 'complete'
    end
  end
end
