# frozen_string_literal: true

# ApiToken represents a token used to access the API
class ApiToken < ApplicationRecord
  enum status: {
    active: 'active',
    blocked: 'blocked',
    sandbox: 'sandbox'
  }

  has_secure_token
  belongs_to :vendor
  has_many :system_events, dependent: :nullify

  validates :status, :description, presence: true

  after_commit :add_api_onramps, on: [:create, :update]

  def limited?
    system_events.in_last_hour.count > self.class.rate_limit_per_hour
  end

  def self.rate_limit_per_hour
    ENV.fetch('API_RATE_LIMIT', 60).to_i
  end

  def self.active_vendors
    active.map(&:vendor).uniq
  end

  def self.sandbox_vendors
    sandbox.map(&:vendor).uniq
  end

  private

  def add_api_onramps
    if active?
      Survey.live.available_on_api.find_each do |survey|
        survey.survey_api_target.add_onramp_for_vendor(vendor)
      end
    elsif sandbox?
      Survey.live.available_on_api_sandbox.find_each do |survey|
        survey.survey_api_target.add_onramp_for_vendor(vendor)
      end
    end
  end
end
