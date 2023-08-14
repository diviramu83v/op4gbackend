# frozen_string_literal: true

# return key onboardings track return keys used by onboardings
class ReturnKeyOnboarding < ApplicationRecord
  belongs_to :onboarding
  belongs_to :return_key
end
