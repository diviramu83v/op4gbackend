# frozen_string_literal: true

# Builds a report of summarized api survey data
class ApiSurveysCsvBuilder
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def self.build_api_surveys_csv(vendor, date: nil, completes: true)
    CSV.generate do |csv|
      csv << ['Op4G Project ID', 'WO Number', 'Project Manager', 'Vendor Project ID', 'Finish Time', 'UID', 'Payout']
      onboardings = if completes == true
                      vendor.api_onboardings.complete.includes(:project).order('projects.id, survey_finished_at')
                    else
                      date_range = date.to_datetime.all_month

                      vendor.api_onboardings.rejected.where(created_at: date_range).or(
                        vendor.api_onboardings.fraudulent.where(created_at: date_range)
                      )
                    end

      onboardings.each do |onboarding|
        output = []

        project = onboarding.project
        manager = project.manager
        onramp = onboarding.survey.onramps.api.for_api_vendor(vendor).first

        output << project.id
        output << project.work_order
        output << manager.name
        output << onramp.token
        output << onboarding.survey_finished_at
        output << onboarding.uid
        output << onboarding.payout

        csv << output
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
