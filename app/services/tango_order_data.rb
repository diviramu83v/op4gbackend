# frozen_string_literal: true

# a service for creating the order hash for tango
class TangoOrderData
  def initialize(incentive_recipient)
    @incentive_recipient = incentive_recipient
  end

  # rubocop:disable Metrics/MethodLength
  def order_body
    {
      accountIdentifier: 'A85728620',
      amount: @incentive_recipient.incentive_batch.reward.to_f,
      campaign: '',
      customerIdentifier: 'G96553171',
      emailSubject: 'Your gift card from Op4G',
      externalRefID: '',
      message: message,
      recipient: {
        email: @incentive_recipient.email_address,
        firstName: @incentive_recipient.first_name,
        lastName: @incentive_recipient.last_name
      },
      rewardName: 'string',
      sendEmail: true,
      sender: {
        email: 'support@op4g.com',
        firstName: '',
        lastName: ''
      },
      utid: 'U561593'
    }
  end
  # rubocop:enable Metrics/MethodLength

  def message
    "Thank you again for participating in our #{@incentive_recipient.incentive_batch.survey_name} survey. Your help is greatly appreciated.
    As promised, here is your #{@incentive_recipient.incentive_batch.reward.format} gift card. We hope you will work with us again in the future."
  end
end
