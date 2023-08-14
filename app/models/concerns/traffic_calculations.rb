# frozen_string_literal: true

# Handles calculating traffic stats.
# rubocop:disable Metrics/ModuleLength
module TrafficCalculations
  include ActiveSupport::Concern

  def started_count
    traffic_records.count
  end

  def onboarding_count
    traffic_records.initialized.count
  end

  def blocked_count
    traffic_records.blocked.count
  end

  def blocked_post_survey_count
    traffic_records.where.not(marked_fraud_at: nil).count
  end

  def flagged_post_survey_complete_count
    completed_traffic.where.not(marked_fraud_at: nil).count
  end

  def blocked_post_survey_term_count
    terminate_traffic.where.not(marked_fraud_at: nil).count
  end

  def failed_post_survey_count
    traffic_records.where.not(marked_post_survey_failed_at: nil).count
  end

  def blocked_post_survey_quotafull_count
    quotafull_traffic.where.not(marked_fraud_at: nil).count
  end

  def screened_count
    traffic_records.screened.count
  end

  def in_survey_count(loi)
    traffic_records.in_survey(loi).count
  end

  def abandoned_count(loi)
    traffic_records.abandoned(loi).count
  end

  def finished_count
    traffic_records.survey_finished.count
  end

  def complete_count
    completed_traffic.count
  end

  def adjusted_complete_count
    complete_count - (traffic_records.complete.rejected.count + traffic_records.complete.fraudulent.count)
  end

  def completed_recent_count
    completed_traffic.finished_recently.count
  end

  def terminate_count
    terminate_traffic.count
  end

  def terminate_recent_count
    terminate_traffic.finished_recently.count
  end

  def quotafull_count
    quotafull_traffic.count
  end

  def quotafull_recent_count
    quotafull_traffic.finished_recently.count
  end

  def average_loi
    traffic_records.complete.average('EXTRACT(EPOCH FROM (survey_finished_at - survey_started_at))')
  end

  # rubocop:disable Metrics/MethodLength
  def median_loi
    lois = traffic_records.complete.pluck(Arel.sql('EXTRACT(EPOCH FROM (survey_finished_at - survey_started_at))'))

    sorted = lois.sort
    size = sorted.size
    center = size / 2

    if size.zero?
      nil
    elsif size.even?
      (sorted[center - 1] + sorted[center]) / 2.0
    else
      sorted[center]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def incidence_rate
    denominator = complete_count + terminate_count
    return 0.0 if denominator.zero?

    (complete_count.to_f / denominator * 100).round(2)
  end

  def incidence_rate_with_screened
    denominator = screened_count + complete_count + terminate_count
    return if denominator.zero?

    complete_count.to_f / denominator * 100
  end

  def incidence_plus_quotafull_rate
    denominator = complete_count + terminate_count + quotafull_count
    return if denominator.zero?

    complete_count.to_f / denominator * 100
  end

  def incidence_plus_quotafull_rate_with_screened
    denominator = screened_count + complete_count + terminate_count + quotafull_count
    return if denominator.zero?

    complete_count.to_f / denominator * 100
  end

  def blocked_rate
    denominator = traffic_records.size
    return if denominator.zero?

    blocked_count.to_f / denominator * 100
  end

  def conversion_rate_calculation
    denominator = traffic_records.where(status: %w[survey_started survey_finished]).count
    return if denominator.zero?

    complete_count.to_f / denominator * 100
  end

  # rubocop:disable Metrics/AbcSize
  def completion_rate
    denominator = complete_count + terminate_count + quotafull_count + abandoned_count(loi)
    return if denominator.zero?

    numerator = complete_count + terminate_count + quotafull_count
    numerator.to_f / denominator * 100
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def completion_rate_with_screened
    denominator = screened_count + complete_count + terminate_count + quotafull_count + abandoned_count(loi)
    return if denominator.zero?

    numerator = complete_count + terminate_count + quotafull_count
    numerator.to_f / denominator * 100
  end
  # rubocop:enable Metrics/AbcSize

  def pass_fail_rate
    denominator = traffic_records.count
    return if denominator.blank? || denominator.zero?

    numerator = complete_count
    numerator.to_f / denominator * 100
  end

  private

  def traffic_records
    draft? ? onboardings : onboardings.live
  end

  def completed_traffic
    traffic_records.complete
  end

  def quotafull_traffic
    traffic_records.quotafull
  end

  def terminate_traffic
    traffic_records.terminate
  end
end
# rubocop:enable Metrics/ModuleLength
