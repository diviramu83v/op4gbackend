# frozen_string_literal: true

# A key is sent when starting a client survey as a security measure.
class ReturnKey < ApplicationRecord
  has_secure_token
  belongs_to :survey

  has_many :return_key_onboardings, dependent: :destroy

  def used!
    return if used_at.present?

    update!(used_at: Time.now.utc)
  end

  def self.generate_keys(survey, quantity)
    quantity.times do
      survey.return_keys.create
    end
  end
end
