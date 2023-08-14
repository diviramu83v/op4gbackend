# frozen_string_literal: true

# An IP address from a generic request
class IpAddress < ApplicationRecord
  CATEGORIES = %w[allow deny-manual deny-auto].freeze

  enum status: {
    allowed: 'allowed',
    flagged: 'flagged',
    blocked: 'blocked'
  }

  enum block_category: {
    manual: 'manual',
    auto: 'auto'
  }

  has_many :events, class_name: 'IpEvent', dependent: :destroy, inverse_of: :ip
  has_many :onboardings, dependent: :restrict_with_exception
  has_many :panelist_ip_histories, dependent: :restrict_with_exception
  has_many :panelists, through: :panelist_ip_histories

  validates :status, presence: true
  validates :category, presence: true
  validate :category_in_categories_list
  validate :category_matches_block_date

  scope :blocked_automatically, -> { not_allowed.where(category: 'deny-auto') }
  scope :blocked_manually, -> { not_allowed.where(category: 'deny-manual') }

  # rubocop:disable Metrics/MethodLength
  def auto_block(reason: nil)
    return unless FeatureManager.ip_auto_blocking?
    return if blocked?

    update!(
      category: 'deny-auto',
      blocked_at: Time.now.utc,
      status: 'flagged',
      block_category: 'auto',
      blocked_reason: reason
    )

    Rails.logger.info "IP automatically blocked: #{address}"
  end
  # rubocop:enable Metrics/MethodLength

  def manually_block(reason: nil)
    return if blocked?

    update!(
      category: 'deny-manual',
      blocked_at: Time.now.utc,
      status: 'flagged',
      block_category: 'manual',
      blocked_reason: reason
    )

    Rails.logger.info "IP manually blocked: #{address}"
  end

  def unblock
    return unless blocked?

    update!(
      category: 'allow',
      blocked_at: nil,
      status: 'allowed',
      block_category: nil,
      blocked_reason: nil
    )

    Rails.logger.info "IP unblocked: #{address}"
  end

  def blocked?
    blocked_at.present?
  end

  def record_suspicious_event!(message:)
    events.create!(message: message)
  end

  def self.find_or_create(address:)
    IpAddress.find_or_create_by(address: address)
  rescue ActiveRecord::RecordNotUnique
    IpAddress.find_by(address: address)
  end

  def self.auto_block(address:, reason:)
    IpAddress.find_or_create(address: address).auto_block(reason: reason)
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.sort_by_context(context)
    if context == 'onboarding'
      IpAddress.joins(:onboardings)
               .where('ip_addresses.category': 'allow')
               .where('onboardings.created_at > ?', Time.now.utc - 90.days)
               .select('ip_addresses.id', 'ip_addresses.address', 'count(*) AS cnt')
               .group('ip_addresses.id', 'ip_addresses.address')
               .order('cnt desc')
    else
      IpAddress.joins(:panelist_ip_histories)
               .where('panelist_ip_histories.created_at > ?', Time.now.utc - 90.days)
               .select('ip_addresses.id', 'ip_addresses.address', 'count(*) AS cnt')
               .group('ip_addresses.id', 'ip_addresses.address')
               .order('cnt desc')
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def self.block_suspicious_ips
    query = <<~SQL.squish
      SELECT
        ip_addresses.*, event_count
      FROM
      	ip_addresses
      	JOIN (
      		SELECT
      			ip_address_id,
      			count(*) AS event_count
      		FROM
      			ip_events
      		WHERE
      			created_at > :cutoff
      		GROUP BY
      			ip_address_id
      		HAVING
      			count(*) >= 10) AS bad_ips ON ip_addresses.id = bad_ips.ip_address_id
      WHERE
      	category = 'allow'
      ORDER BY
      	event_count DESC;
    SQL

    ips = IpAddress.find_by_sql [query, { cutoff: 2.weeks.ago }]
    ips.each { |ip| ip.auto_block(reason: 'suspicous ip') }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def category_in_categories_list
    return if category.blank?

    errors.add(:category, 'must be in the category list') unless CATEGORIES.include?(category)
  end

  def category_matches_block_date
    return if category.blank?

    errors.add(:blocked_at, 'is not allowed with this category') if category == 'allow' && blocked_at.present?
    errors.add(:blocked_at, 'is required with this category') if category != 'allow' && blocked_at.nil?
  end
end
