# frozen_string_literal: true

recent_completes = Onboarding.complete.where('onboardings.created_at > ?', 30.days.ago)

fraudulent_completes = recent_completes.where(client_status: :fraudulent)

# accepted_completes = recent_completes.where(client_status: :accepted)
# rejected_completes = recent_completes.where(client_status: :rejected)
# pending_completes = recent_completes.where(client_status: nil)

def pre_survey_clean_id_step(onboarding)
  onboarding.traffic_steps
            .where(when: 'pre', category: 'clean_id')
            .order(:id)
            .first || nil
end

def post_survey_clean_id_step(onboarding)
  onboarding.traffic_steps
            .where(when: 'post', category: 'clean_id')
            .order(:id)
            .first || nil
end

def clean_id_check(traffic_step)
  return if traffic_step.nil?

  traffic_step.traffic_checks.where(controller_action: 'show').order(:id).first
end

def clean_id_data(traffic_check)
  return if traffic_check.nil?

  traffic_check.data_collected
end

def device_code(clean_id_data)
  clean_id_data.dig('forensic', 'deviceId')
rescue NoMethodError
  nil
end

def pre_survey_device_code(complete)
  device_code(
    clean_id_data(
      clean_id_check(
        pre_survey_clean_id_step(
          complete
        )
      )
    )
  )
end

def post_survey_device_code(complete)
  device_code(
    clean_id_data(
      clean_id_check(
        post_survey_clean_id_step(
          complete
        )
      )
    )
  )
end

# puts "recent completes: #{recent_completes.count}"
# puts "accepted completes: #{accepted_completes.count}"
# puts "fraudulent completes: #{fraudulent_completes.count}"
# puts "rejected completes: #{rejected_completes.count}"
# puts "pending completes: #{pending_completes.count}"

fraudulent_device_codes = []
fraudulent_completes.find_each do |complete|
  pre_survey = pre_survey_device_code(complete)
  post_survey = post_survey_device_code(complete)

  fraudulent_device_codes << pre_survey unless pre_survey.nil?
  fraudulent_device_codes << post_survey unless post_survey.nil?
end

puts fraudulent_device_codes.uniq
                            .index_with { |x| fraudulent_device_codes.count(x) }
                            .select { |_k, v| v > 2 }
                            .sort_by(&:last)
                            .to_h
