# frozen_string_literal: true

require 'test_helper'

class SurveyPayloadTest < ActiveSupport::TestCase
  describe '#build' do
    describe 'onramp is nil' do
      let(:survey) { mock }
      let(:token) { mock }
      let(:onramps) { mock }

      setup do
        survey.stubs(onramps: onramps)
        token.stubs(vendor: mock)
        onramps.stubs(:api).returns(stub(for_api_vendor: [nil]))
      end

      test 'returns nil' do
        assert_nil SurveyPayload.build(survey, token)
      end
    end

    describe 'survey api target is nil' do
      let(:survey) { mock }
      let(:token) { mock }
      let(:onramps) { mock }
      let(:onramp) { mock }

      setup do
        survey.stubs(onramps: onramps, survey_api_target: nil)
        token.stubs(vendor: mock)
        onramps.stubs(:api).returns(stub(for_api_vendor: [onramp]))
        onramp.stubs(token: 'some_token')
      end

      test 'returns nil' do
        assert_nil SurveyPayload.build(survey, token)
      end
    end

    describe 'builds survey payload' do
      let(:survey) { mock }
      let(:token) { mock }
      let(:target) { mock }
      let(:onramp) { mock }
      let(:onramps) { mock }
      let(:project) { mock }

      setup do
        survey.stubs(
          onramps: onramps,
          survey_api_target: target,
          loi: 10,
          remaining_completes: 140,
          incidence_rate: 0.0
        )

        token.stubs(:vendor).returns(mock)
        onramps.stubs(:api).returns(stub(for_api_vendor: [onramp]))

        onramp.stubs(
          token: 'some_uuid',
          project: project,
          incidence_rate: 0.0
        )

        project.stubs(
          id: 100
        )

        target.stubs(
          countries: ['US'],
          states: ['CA'],
          education: ['vocational_associates'],
          employment: ['unemployed'],
          income: ['under_twenty_five_thousand'],
          genders: ['male'],
          race: ['asian_indian'],
          number_of_employees: %w[none one_hundred_to_under_two_hundred_fifty],
          job_title: %w[dentist salesperson],
          age_range: (18..100).to_a,
          payout: 1_000_000,
          decision_maker: %w[corporate_travel_self it_infrastructure_systems_integration],
          custom_option: 'custom question'
        )

        @payload_target = {
          country: ['US'],
          states: ['CA'],
          zip_codes: [],
          education: ['vocational_associates'],
          employment: ['unemployed'],
          income: ['under_twenty_five_thousand'],
          race: ['asian_indian'],
          number_of_employees: %w[none one_hundred_to_under_two_hundred_fifty],
          job_title: %w[dentist salesperson],
          gender: ['male'],
          age: (18..100).to_a,
          decision_maker: %w[corporate_travel_self it_infrastructure_systems_integration],
          custom_option: 'custom question'
        }
      end

      test 'builds survey payload' do
        payload = SurveyPayload.build(survey, token)

        assert_equal(
          payload.keys,
          [:uuid, :project_id, :url, :loi_minutes, :payout_dollars, :target,
           :remaining_completes, :survey_incidence_rate, :vendor_incidence_rate]
        )
        assert_equal(payload[:uuid], 'some_uuid')
        assert_equal(payload[:project_id], 100)
        assert_equal(payload[:url], "https://survey.op4g.com/onramps/#{onramp.token}?uid={{uid}}")
        assert_equal(payload[:loi_minutes], 10)
        assert_equal(payload[:payout_dollars], '1,000,000.00')
        assert_equal(payload[:target], @payload_target)
        assert_equal(payload[:remaining_completes], 140)
        assert_equal(payload[:survey_incidence_rate], 0.0)
        assert_equal(payload[:vendor_incidence_rate], 0.0)
      end
    end
  end
end
