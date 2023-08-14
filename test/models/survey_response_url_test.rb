# frozen_string_literal: true

require 'test_helper'

class SurveyResponseUrlTest < ActiveSupport::TestCase
  describe '#name' do
    test 'humanize slug' do
      survey_response_url = survey_response_urls(:quotafull)

      assert survey_response_url.slug == 'quotafull'
      assert survey_response_url.name == 'Quotafull'
    end
  end
end
