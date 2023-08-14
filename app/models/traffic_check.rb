# frozen_string_literal: true

# traffic checks record what happened on a traffic step
class TrafficCheck < ApplicationRecord
  belongs_to :traffic_step
  belongs_to :ip_address

  has_one :onboarding, through: :traffic_step
  has_one :survey, through: :traffic_step
  has_many :traffic_events, dependent: :restrict_with_exception
  delegate :category, to: :traffic_step

  after_create :create_traffic_event

  def failed?
    return false if controller_action == 'new'

    case category
    when 'clean_id'
      clean_id_failed?
    when 'recaptcha'
      recaptcha_step_failed?
    else
      false
    end
  end

  private

  def create_traffic_event
    TrafficEvent.create!(onboarding: onboarding, category: 'info', message: traffic_event_message, traffic_check: self)
  end

  def clean_id_failed?
    return false unless onboarding.onramp.check_clean_id

    verification = CleanIdDataVerification.new(
      data: data_collected,
      onboarding: onboarding
    )

    verification.fails_any_checks?
  end

  def recaptcha_step_failed?
    return false if data_collected['recaptcha_token_valid'] == true

    onboarding.add_error('Recaptcha: check failed')
    true
  end

  def traffic_event_message
    if controller_action == 'new' && !traffic_step.single_check?
      "#{category}: started"
    else
      "#{category}: #{failed? ? 'failed' : 'passed'}"
    end
  end
end
