# frozen_string_literal: true

recent_completes = Onboarding.complete.where('onboardings.created_at > ?', 30.days.ago)

accepted_completes = recent_completes.where(client_status: :accepted)
fraudulent_completes = recent_completes.where(client_status: :fraudulent)
rejected_completes = recent_completes.where(client_status: :rejected)
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

def print_batch_data(completes, label)
  changed = 0
  matched = 0

  completes.find_each do |complete|
    pre_survey = pre_survey_device_code(complete)
    post_survey = post_survey_device_code(complete)

    # puts "#{pre_survey} => #{post_survey}"

    if complete.onramp.requires_no_security_checks?
      # do nothing
    elsif pre_survey == post_survey
      matched += 1
    else
      changed += 1
    end
  end

  cleared = matched + changed
  total = completes.count

  puts label.upcase
  puts "matched: #{matched}"
  puts "changed: #{changed}"
  puts "cleared: #{cleared}"
  puts "total: #{total}"

  changed_cleared_percentage = (changed.to_f / cleared * 100).round(2)
  changed_total_percentage = (changed.to_f / total * 100).round(2)

  puts "#{label} changed / cleared: #{changed_cleared_percentage}%"
  puts "#{label} changed / total: #{changed_total_percentage}%"
end

print_batch_data(accepted_completes, 'accepted')
puts
print_batch_data(rejected_completes, 'rejected')
puts
print_batch_data(fraudulent_completes, 'fraudulent')
