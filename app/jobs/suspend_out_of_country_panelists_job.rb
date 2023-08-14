# frozen_string_literal: true

# This job suspends panelists based on their signup or traffic clean_id country not matching the panel's country
class SuspendOutOfCountryPanelistsJob < ApplicationJob
  queue_as :default

  def perform
    suspend_panelists_based_on_traffic_cleanid_country
  end

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def suspend_panelists_based_on_traffic_cleanid_country
    traffic_checks = TrafficCheck.where.not(data_collected: nil)
                                 .where(controller_action: 'show')
                                 .where('updated_at BETWEEN ? AND ?', 2.days.ago, Time.now.utc)

    traffic_checks.find_each do |traffic|
      onboarding = traffic.onboarding

      next if onboarding.blank? || onboarding.panelist.blank? || onboarding.panelist.primary_panel.blank?

      panelist = onboarding.panelist

      next unless panelist.active?

      clean_id_data = onboarding.clean_id_full_set

      country = clean_id_data.dig('result', 'IpData', 'IpCountryCode')

      next if country.blank? || country.downcase == panelist.primary_panel.country.slug.downcase
      next if country == 'GB' && panelist.primary_panel.country.slug.downcase == 'uk'

      panelist.update!(suspended_at: Time.now.utc, status: Panelist.statuses[:suspended])
      panelist.notes.create!(employee_id: 0, body: "Automatically suspended: CleanID country doesn't match the panel's country.")

    rescue ActiveRecord::RecordInvalid
      # rubocop:disable Rails/SkipsModelValidations
      panelist.update_columns(suspended_at: Time.now.utc, status: Panelist.statuses[:suspended])
      # rubocop:enable Rails/SkipsModelValidations
      panelist.notes.create!(employee_id: 0, body: "Automatically suspended: CleanID country doesn't match the panel's country.")
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
end
