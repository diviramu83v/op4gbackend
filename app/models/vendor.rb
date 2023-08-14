# frozen_string_literal: true

# A vendor provides us with additional panelists to take our client's surveys
#   when we don't have enough of our own panelists to complete a project.
class Vendor < ApplicationRecord
  include VendorRedirectFormatting
  include PgSearch::Model

  pg_search_scope :search_by_name, against: {
                                    name: 'A'
                                  },
                                  using: {
                                    tsearch: { prefix: true, any_word: true }
                                  }

  nilify_blanks


  has_many :vendor_batches, dependent: :destroy
  has_many :surveys, through: :vendor_batches, inverse_of: :vendors
  has_many :earnings, through: :surveys, inverse_of: :vendor
  has_many :projects, through: :surveys, inverse_of: :vendors
  has_many :onramps, through: :vendor_batches, inverse_of: :vendor
  has_many :onboardings, through: :onramps

  has_many :api_onramps, dependent: :destroy, class_name: 'Onramp', foreign_key: :api_vendor_id, inverse_of: :api_vendor
  has_many :api_onboardings, through: :api_onramps, source: :onboardings, inverse_of: :api_vendor
  has_many :survey_api_targets, through: :surveys, inverse_of: :vendor
  has_many :api_projects, through: :api_onramps, source: :project
  has_many :api_surveys, through: :api_onramps, source: :survey
  has_many :api_tokens, dependent: :destroy, inverse_of: :vendor
  has_many :rfp_vendors, dependent: :destroy
  has_many :rfps, -> { distinct }, through: :rfp_vendors, foreign_key: "tblRFP_id"

  validates :name, presence: true
  validates :complete_url, :terminate_url, :overquota_url, presence: true, if: :any_url_present?
  validate :urls_formatted_correctly

  scope :active, -> { where(active: true) }

  # rubocop:disable Layout/LineLength
  scope :present_urls_or_disabled_redirects, -> { where('(complete_url IS NOT NULL AND terminate_url IS NOT NULL AND overquota_url IS NOT NULL) OR disable_redirects = true') }
  # rubocop:enable Layout/LineLength

  scope :with_active_projects, -> { joins(:projects).merge(Project.active).uniq }

  scope :by_name, -> { order(:name) }

  WEBHOOK_METHODS = %w[post get].freeze

  VENDOR_PAGINATE = 10

  def abbreviation
    self[:abbreviation].presence || name
  end

  def name_and_abbreviation
    return name if abbreviation == name

    "#{name} (#{abbreviation})"
  end

  def uid_param
    self[:uid_parameter].presence || ''
  end

  def project_count
    projects.count
  end

  def any_url_present?
    complete_url.present? || terminate_url.present? || overquota_url.present? || security_url.present?
  end

  def security_check_default
    !security_disabled_by_default
  end

  def self.inactive
    active - with_active_projects
  end

  def use_override_email?
    follow_up_wording.present?
  end

  def redirect_url(response)
    case response.slug
    when 'complete' then complete_url.presence
    when 'terminate' then terminate_url.presence
    when 'quotafull' then overquota_url.presence
    end
  end

  def complete_webhook
    return unless send_complete_webhook?

    complete_webhook_url
  end

  def secondary_webhook
    return unless send_secondary_webhook?

    secondary_webhook_url
  end

  def api_token_name
    "#{id} - #{name}"
  end

  def total_api_payout
    api_payout_cents / 100
  end

  def average_api_payout
    return 0 unless api_onboardings.complete.count.positive?

    total_api_payout / api_onboardings.complete.count
  end

  def total_api_revenue
    api_onboardings.complete.sum { |o| o.survey.cpi_cents } / 100
  end

  def total_onboardings_past_year
    return if onboardings.nil?

    onboardings.created_in_past_year.count
  end

  def total_blocked_onboardings_past_year
    return if onboardings.nil?

    onboardings.blocked.created_in_past_year.count
  end

  def block_rate_percentage_past_year
    all_onboardings = total_onboardings_past_year
    return if all_onboardings.zero?

    blocked_onboardings = total_blocked_onboardings_past_year

    (blocked_onboardings / all_onboardings.to_f) * 100
  end

  private

  def api_payout_cents
    api_onboardings.complete.sum do |o|
      o.survey_api_target&.payout_cents || 0
    end
  end
end
