# frozen_string_literal: true

# methods shared by the decoding and completes_decorder models
module SharedDecoders # rubocop:disable Metrics/ModuleLength
  include ActiveSupport::Concern

  def decoded?
    decoded_at.present?
  end

  def panel_traffic_uids
    decoded_uids.matched.panel
  end

  def first_panel
    panel_traffic_uids.first.onboarding.panel
  end

  def unique_projects
    projects.select('projects.*').distinct
  end

  def unique_sources_for_survey(survey)
    decoded_uids.for_survey(survey).map(&:source).uniq
  end

  def multiple_projects?
    unique_projects.size > 1
  end

  def unmatched_uids
    decoded_uids.unmatched
  end

  def errors?
    unmatched_uids.any?
  end

  def matched_uids
    decoded_uids.matched
  end

  # rubocop:disable Layout/LineLength
  def matched_uids_for_vendor(vendor)
    # TODO: Figure out why this isn't working. Chaining the scopes works fine
    #   until the last link in the chain. Possibly a bug in ActiveRecord?
    # decoded_uids.for_batch_vendor(vendor)

    decoded_uids
      .joins('inner join onboardings on decoded_uids.onboarding_id = onboardings.id inner join onramps on onboardings.onramp_id = onramps.id inner join vendor_batches on onramps.vendor_batch_id = vendor_batches.id')
      .where(vendor_batches: { vendor_id: vendor.id })
  end
  # rubocop:enable Layout/LineLength

  def matched_uids_for_survey(survey)
    decoded_uids.for_survey(survey)
  end

  def decoded_uids_for_panel(panel)
    panel_traffic_uids.joins(:onboarding).where(onboardings: { panel_id: panel.id }).order('onboardings.created_at')
  end

  def matched_uids_for_disqo(disqo_quota)
    decoded_uids.matched.joins(:onboarding).where(onboardings: { onramp_id: disqo_quota.onramp.id }).order('onboardings.created_at')
  end

  def matched_uids_for_cint(cint_survey)
    decoded_uids.matched.joins(:onboarding).where(onboardings: { onramp_id: cint_survey.onramp.id }).order('onboardings.created_at')
  end

  def matched_uids_for_survey_and_source(survey, traffic_source)
    matched_uids_for_survey(survey).select { |uid| uid.source == traffic_source }
  end

  def filename(uids:, source_object:) # rubocop:disable Metrics/AbcSize
    case source_object
    when Vendor
      "#{projects.first.id}_#{vendor_abbreviation(source_object)}_N=#{uids.count}_#{vendor_incentive(uids)}.csv"
    when Panel
      "#{projects.first.id}_#{panel_client_name}_#{project_name}_N=#{uids.count}_#{panel_incentive(uids)}.csv"
    when DisqoQuota
      "#{projects.first.id}_disqo-#{source_object.quota_id}_#{project_name}_N=#{uids.count}_$#{source_object.cpi}.csv"
    when CintSurvey
      "#{projects.first.id}_cint-#{source_object.name}_#{project_name}_N=#{uids.count}_$#{source_object.cpi}.csv"
    end
  end

  def update_onboardings_status(status)
    onboardings.find_each do |onboarding|
      onboarding.update!(client_status: status)
    end
  end

  def suspend_panelists_and_block_ips
    onboardings.find_each do |onboarding|
      panelist = Panelist.find_by(id: onboarding.panelist_id)
      next if panelist.blank?
      next unless panelist.suspend

      panelist.notes.create(employee_id: employee_id,
                            body: "Automatically suspended when UID was uploaded as a fraudulent complete for project #{onboarding.project.id}.")
      panelist.block_ips("Automatically suspended when UID was uploaded as a fraudulent complete for project #{onboarding.project.id}.")
    end
  end

  def unsuspend_panelists_and_unblock_ips
    onboardings.find_each do |onboarding|
      panelist = Panelist.find_by(id: onboarding.panelist_id)
      next if panelist.blank?
      next unless panelist.unsuspend

      panelist.unblock_ips
    end
  end

  def decoded_uids_belong_to_this_project?(project)
    return false if multiple_projects?

    projects.first == project
  end

  def alert_message
    return 'No matches were found. Make sure to use encoded UIDs' if onboardings.blank?

    'Batch contains UIDs not from this project'
  end

  private

  def project_name
    projects.first&.name&.parameterize
  end

  def panel_client_name
    projects.first&.client&.name&.parameterize
  end

  def vendor_incentive(uids)
    ApplicationController.helpers.format_currency(uids.find do |uid|
                                                    uid&.onboarding&.present?
                                                  end&.onboarding&.vendor_batch&.incentive)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def panel_incentive(uids)
    ApplicationController.helpers.format_currency(uids.find do |uid|
                                                    uid&.onboarding&.present?
                                                  end&.onboarding&.invitation&.batch&.incentive)
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def vendor_abbreviation(source_object)
    source_object.abbreviation.parameterize
  end

  def record_completion
    update!(decoded_at: Time.now.utc)
  end
end
