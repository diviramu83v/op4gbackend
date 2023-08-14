# frozen_string_literal: true

# A gate survey records basic data from panelists in order to find out a little more about them for possible use in later projects.
class GateSurvey < ApplicationRecord
  belongs_to :onboarding, inverse_of: :gate_survey
  has_one :survey, through: :onboarding, inverse_of: :gate_survey

  ETHNICITIES = [
    'American Indian', 'Asian Indian', 'Black', 'Chinese', 'Filipino',
    'Guaminian', 'Native Hawaiian', 'Hispanic', 'Japanese', 'Korean', 'Other',
    'Other Asian', 'Other Pacific Islander', 'Samoan', 'Vietnamese', 'White'
  ].freeze

  GENDERS = %w[
    Male Female
  ].freeze

  INCOMES = [
    'under 16,000', '16,000 to 49,999', '50,000 to 99,999',
    '100,000 to 499,999', '500,000 to 999,999', '1 million to 4.9 million',
    '5 million to 9.9 million', '10 million to 19.9 million',
    '20 million or more'
  ].freeze

  # rubocop:disable Metrics/MethodLength
  def self.to_csv(options = {})
    CSV.generate(**options) do |csv|
      csv << ['UID', 'Encoded UID', 'State', 'Zip', 'Birthdate', 'Age', 'Gender', 'Income', 'Ethnicity']
      all.find_each do |gate_survey|
        values = [
          gate_survey.onboarding.uid,
          gate_survey.onboarding.token,
          gate_survey.state,
          gate_survey.zip,
          gate_survey.birthdate,
          gate_survey.age,
          gate_survey.gender,
          gate_survey.income,
          gate_survey.ethnicity
        ]

        csv << values
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
end
