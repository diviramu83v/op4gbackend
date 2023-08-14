# frozen_string_literal: true

# A decoded UID record keeps track of one record that is being decoded.
class DecodedUid < ApplicationRecord
  belongs_to :onboarding, optional: true
  belongs_to :decodable, polymorphic: true

  has_one :project, through: :onboarding
  has_one :onramp, through: :onboarding
  has_one :vendor, through: :onboarding, source: :batch_vendor, class_name: 'Vendor'
  has_one :api_vendor, through: :onboarding, source: :api_vendor, class_name: 'Vendor'
  has_many :vendor_batches, through: :onboarding

  validates :uid, presence: true

  after_create :look_up_traffic_record

  scope :unmatched, -> { where(onboarding: nil) }
  scope :matched, -> { where.not(onboarding: nil) }
  scope :testing, -> { joins(:onboarding).merge(Onboarding.testing) }
  scope :panel, -> { joins(:onboarding).merge(Onboarding.panel) }
  scope :router, -> { joins(:onboarding).merge(Onboarding.router) }
  scope :for_vendor, ->(vendor) { joins(:onboarding).merge(Onboarding.for_batch_vendor(vendor)) }
  scope :for_router, ->(router) { joins(:onboarding).merge(Onboarding.for_router(router)) }
  scope :for_survey, ->(survey) { joins(:onramp).where(onramps: { survey_id: survey.id }) }
  scope :for_disqo, -> { joins(:onboarding).merge(Onboarding.for_disqo) }
  scope :for_cint, -> { joins(:onboarding).merge(Onboarding.for_cint) }

  def source_name
    onboarding.try(:source_name)
  end

  def source
    onboarding.try(:source)
  end

  def self.to_combined_panel_csv # rubocop:disable Metrics/MethodLength
    CSV.generate do |csv|
      csv << %w[Vendor Surveys UID CPI]

      all.find_each do |decoding|
        csv << if decoding.project
                 [
                   decoding.source_name,
                   decoding.project.surveys.map(&:name).join(', '),
                   decoding.onboarding.uid,
                   decoding.onramp.survey.cpi
                 ]
               else
                 ['', '', 'ID not found', '']
               end
      end
    end
  end

  def self.to_source_csv # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    CSV.generate do |csv|
      csv << %w[Survey Source UID CPI]

      onboardings = all.map(&:onboarding).uniq

      onboardings.sort_by { |o| [o.survey.name, o.source.name] }.each do |onboarding|
        csv << [
          onboarding.survey.name,
          onboarding.source.name,
          onboarding.uid,
          onboarding.survey.cpi
        ]
      end
    end
  end

  def self.to_source_rejected_csv # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    CSV.generate do |csv|
      csv << %w[Survey Source UID Rejected_Reason CPI]

      onboardings = all.map(&:onboarding).uniq

      onboardings.sort_by { |o| [o.survey.name, o.source.name] }.each do |onboarding|
        csv << [
          onboarding.survey.name,
          onboarding.source.name,
          onboarding.uid,
          onboarding.rejected_reason || '',
          onboarding.survey.cpi
        ]
      end
    end
  end

  def self.to_errors_csv
    CSV.generate do |csv|
      csv << ['Encoded UID']

      all.find_each do |decoding|
        csv << [decoding.uid]
      end
    end
  end

  private

  def look_up_traffic_record
    update onboarding: Onboarding.find_by(token: uid)
  end
end
