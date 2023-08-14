# frozen_string_literal: true

# PanelistStatus encapsulates the panelist methods involving Panelist status changes
module PanelistStatus # rubocop:disable Metrics/ModuleLength
  include ActiveSupport::Concern

  def inactive?
    !active?
  end

  def suspend
    MadMimiRemoveFromDangerListJob.perform_later(panelist: self) if on_danger_list?
    MadMimiSuppressEmailJob.perform_later(email: email) unless deleted?
    update!(suspended_at: Time.now.utc, status: Panelist.statuses[:suspended], in_danger_at: nil)
  end

  def block_ips(note)
    return if ip_histories.blank?

    ip_address_ids = ip_histories.distinct.pluck(:ip_address_id)
    ip_address_ids.each do |id|
      ip = IpAddress.find(id)

      ip.manually_block(reason: note)
    end
  end

  def unsuspend
    MadMimiRemoveFromDangerListJob.perform_later(panelist: self) if on_danger_list?
    update!(suspended_at: nil, status: Panelist.statuses[:active], in_danger_at: nil, suspend_and_pay_status: false)
  rescue ActiveRecord::RecordInvalid => e
    raise e unless too_young?

    # rubocop:disable Rails/SkipsModelValidations
    update_columns(suspended_at: nil, status: Panelist.statuses[:active], in_danger_at: nil)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def unblock_ips
    return if ip_histories.blank?

    ip_address_ids = ip_histories.distinct.pluck(:ip_address_id)
    ip_address_ids.each do |id|
      ip = IpAddress.find(id)

      ip.unblock
    end
  end

  def suspended?
    suspended_at.present?
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def soft_delete!
    MadMimiRemoveFromDangerListJob.perform_later(panelist: self) if on_danger_list?
    MadMimiSuppressEmailJob.perform_later(email: email) unless deleted?
    update!(deleted_at: Time.now.utc, status: Panelist.statuses[:deleted], in_danger_at: nil)

    update!(
      postal_code: nil,
      address: nil,
      address_line_two: nil,
      city: nil,
      state: nil,
      zip_code_id: nil,
      age: nil,
      update_age_at: nil,
      birthdate: nil
    )

    deletion_label = -> { "deleted: #{Time.now.utc.strftime('%Y-%m-%d %H:%M:%S:%N')}" }

    # rubocop:disable Rails/SkipsModelValidations
    update_column(:email, deletion_label.call)
    update_column(:first_name, '')
    update_column(:last_name, '')
    update_column(:country_id, nil)
    update_column(:encrypted_password, '')
    update_column(:locale, 'deleted')
    update_column(:legacy_earnings_cents, 0)
    update_column(:search_terms, nil)
    # rubocop:enable Rails/SkipsModelValidations

    answers.delete_all
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def record_activity
    return unless active? || deactivated?
    return if deactivated? && last_activity_over_a_year_ago?

    begin
      MadMimiRemoveFromDangerListJob.perform_later(panelist: self) if on_danger_list?

      update!(
        status: 'active',
        deactivated_at: nil,
        last_activity_at: Time.now.utc
      )
    rescue ActiveRecord::RecordInvalid => e
      raise e unless too_young? || email_invalid?

      # This is a temporary fix for young panelists who aren't in CA. We're not
      # allowing new signups under 17, but we don't want to lose everyone who is
      # already in that age bracket. Once all panelists are over 16, we can
      # remove this.

      # rubocop:disable Rails/SkipsModelValidations
      update_columns(status: Panelist.statuses[:active], last_activity_at: Time.now.utc)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def deactivate
    return unless signing_up? || active?

    MadMimiRemoveFromDangerListJob.perform_later(panelist: self) if on_danger_list?
    MadMimiSuppressEmailJob.perform_later(email: email)

    # rubocop:disable Rails/SkipsModelValidations
    if active?
      update_column('status', Panelist.statuses[:deactivated])
      update_column('deactivated_at', Time.now.utc)
    else # signing_up
      update_column('status', Panelist.statuses[:deactivated_signup])
      update_column('deactivated_at', Time.now.utc)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Lint/DuplicateBranch
  def deactivate_if_enough_recent_invitations
    # Ignore for any status besides active/signing up.
    if signing_up?
      deactivate
    elsif active? && enough_recent_invitations?
      deactivate
    end
  end
  # rubocop:enable Lint/DuplicateBranch

  private

  def last_activity_over_a_year_ago?
    return false if last_activity_at.nil?

    last_activity_at < 1.year.ago
  end

  def enough_recent_invitations?
    invitations.where('sent_at > ?', 6.months.ago).count >= 5
  end
end
