# frozen_string_literal: true

require 'test_helper'

class RecruitingCampaignTest < ActiveSupport::TestCase
  describe 'validations' do
    subject { RecruitingCampaign.new(campaignable: nonprofits(:one)) }

    should validate_presence_of(:code)
    should validate_uniqueness_of(:code)
  end
end
