# frozen_string_literal: true

# A vendor batch is a collection of panelists that are provided to us by an
#   outside vendor. They are directed to our system and then we direct them
#   on to the appropriate survey, after tagging them appropriately.
class VendorBatch < ApplicationRecord
  include VendorRedirectFormatting

  FILE_TYPES = %w[image javascript].freeze

  belongs_to :survey, optional: true
  belongs_to :vendor

  has_one :onramp, dependent: :destroy
  has_one :project, through: :survey, inverse_of: :project

  before_validation :add_vendor_redirects

  validates :incentive, numericality: { greater_than: 0 }
  validates :incentive, presence: true
  validates :complete_url, :terminate_url, :overquota_url, presence: true, if: :urls_required?
  validate :completes_entered
  validate :urls_formatted_correctly,
           :primary_urls_must_all_be_present_if_overriding

  after_create :add_onramp
  after_update :check_requested_completes

  scope :for_vendor, ->(vendor) { where(vendor: vendor) }
  scope :by_first_created, -> { order('created_at') }

  delegate :draft?, :live?, :on_hold?, to: :survey
  delegate :name, to: :vendor, prefix: true
  delegate :disable_redirects?, :send_complete_webhook?, to: :vendor
  delegate :deletable?, to: :onramp

  monetize :incentive_cents, allow_nil: true

  def editable?
    draft? || live? || on_hold?
  end

  def using_redirects?
    !vendor.disable_redirects?
  end

  def complete_url
    self[:complete_url].presence || vendor.try(:complete_url)
  end

  def terminate_url
    self[:terminate_url].presence || vendor.try(:terminate_url)
  end

  # TODO: change "overquota" to "quotafull" throughout the application.
  def overquota_url
    self[:overquota_url].presence || vendor.try(:overquota_url)
  end

  def security_url
    self[:security_url].presence || vendor.try(:security_url)
  end

  def base_redirect_url(response)
    return unless using_redirects?

    case response.slug
    when 'complete' then complete_url
    when 'terminate' then terminate_url
    when 'quotafull' then overquota_url
    end
  end

  def base_security_redirect_url
    return unless using_redirects?

    security_url
  end

  def base_webhook_url
    vendor.complete_webhook_url
  end

  def cloneable_fields
    {
      vendor_id: vendor_id,
      incentive_cents: incentive_cents,
      complete_url: complete_url,
      terminate_url: terminate_url,
      overquota_url: overquota_url,
      security_url: security_url,
      quoted_completes: quoted_completes,
      requested_completes: requested_completes
    }
  end

  private

  def completes_entered
    return unless vendor
    return if vendor.id == 1 || vendor.id == 120

    errors.add(:quoted_completes, 'must not be blank') if self[:quoted_completes].blank?
    errors.add(:requested_completes, 'must not be blank') if self[:requested_completes].blank?
  end

  def urls_required?
    return if vendor.blank?

    live? && using_redirects?
  end

  def primary_urls_must_all_be_present_if_overriding
    return unless any_url_present?

    errors.add(:complete_url, 'must not be blank') if self[:complete_url].blank?
    errors.add(:terminate_url, 'must not be blank') if self[:terminate_url].blank?
    errors.add(:overquota_url, 'must not be blank') if self[:overquota_url].blank?
  end

  def any_url_present?
    self[:complete_url].present? ||
      self[:terminate_url].present? ||
      self[:overquota_url].present? ||
      self[:security_url].present?
  end

  def add_onramp
    create_onramp(
      survey: survey,
      category: Onramp.categories[:vendor],
      check_clean_id: vendor.security_check_default,
      check_recaptcha: vendor.security_check_default,
      ignore_security_flags: vendor.security_disabled_by_default,
      check_gate_survey: vendor.gate_survey_on_by_default
    )
  end

  # rubocop:disable Metrics/AbcSize
  def add_vendor_redirects
    self.complete_url = vendor.try(:complete_url) if complete_url.blank?
    self.terminate_url = vendor.try(:terminate_url) if terminate_url.blank?
    self.overquota_url = vendor.try(:overquota_url) if overquota_url.blank?
    self.security_url = vendor.try(:security_url) if security_url.blank?
  end
  # rubocop:enable Metrics/AbcSize

  def check_requested_completes
    return unless saved_change_to_requested_completes?
    return unless requested_completes > onramp.complete_count

    onramp.enable!
  end
end
