# frozen_string_literal: true

# Adds vendors to multiple surveys at one time.
class ProjectVendor
  include ActiveModel::Model
  include VendorRedirectFormatting

  attr_accessor :project_id, :vendor_id, :incentive, :quoted_completes, :requested_completes, :complete_url, :terminate_url, :overquota_url, :security_url

  validates :project_id, :vendor_id, :incentive, presence: true
  validates :project_id, :vendor_id, numericality: { only_integer: true }
  validates :incentive, numericality: { greater_than: 0 }
  validate :completes_entered
  validate :urls_formatted_correctly
  validate :redirects_present_if_required

  def save
    VendorBatch.transaction { create_vendor_batches } if valid?
  end

  private

  def completes_entered
    return if vendor_id == '1' || vendor_id == '120'

    errors.add(:quoted_completes, 'must not be blank') if quoted_completes.blank?
    errors.add(:requested_completes, 'must not be blank') if requested_completes.blank?
  end

  def redirects_present_if_required
    return unless urls_required?

    errors.add(:complete_url, 'must not be blank') if complete_url_redirect.blank?
    errors.add(:terminate_url, 'must not be blank') if terminate_url_redirect.blank?
    errors.add(:overquota_url, 'must not be blank') if overquota_url_redirect.blank?
  end

  def project
    @project ||= Project.find_by(id: project_id)
  end

  def vendor
    @vendor ||= Vendor.find_by(id: vendor_id)
  end

  def urls_required?
    return if vendor.blank?

    using_redirects?
  end

  def using_redirects?
    return if vendor.blank?

    !vendor.disable_redirects?
  end

  def complete_url_redirect
    complete_url.presence || vendor.try(:complete_url)
  end

  def terminate_url_redirect
    terminate_url.presence || vendor.try(:terminate_url)
  end

  def overquota_url_redirect
    overquota_url.presence || vendor.try(:overquota_url)
  end

  def security_url_redirect
    security_url.presence || vendor.try(:security_url)
  end

  def create_vendor_batches # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    project.surveys.each do |survey|
      vendor_batch = VendorBatch.find_or_initialize_by(vendor_id: vendor_id, survey_id: survey.id)

      next if vendor_batch.persisted?

      vendor_batch.incentive = incentive
      vendor_batch.quoted_completes = quoted_completes
      vendor_batch.requested_completes = requested_completes
      vendor_batch.complete_url = complete_url_redirect
      vendor_batch.terminate_url = terminate_url_redirect
      vendor_batch.overquota_url = overquota_url_redirect
      vendor_batch.security_url = security_url_redirect
      vendor_batch.save!
    end
  end
end
