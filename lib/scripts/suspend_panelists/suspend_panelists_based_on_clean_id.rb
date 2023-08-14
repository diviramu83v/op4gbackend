# frozen_string_literal: true

panelists_without_clean_id_data_count = 0
suspended_count = 0

Panelist.active.where.not(clean_id_data: nil).find_each do |panelist|
  if panelist.clean_id_data.class.instance_of?(String) || panelist.clean_id_data.blank?
    panelists_without_clean_id_data_count += 1
  elsif panelist.clean_id_failed?
    begin
      panelist.suspend_based_on_clean_id
    rescue ActiveRecord::RecordInvalid
      # rubocop:disable Rails/SkipsModelValidations
      panelist.update_columns(
        suspended_at: Time.now.utc,
        status: Panelist.statuses[:suspended],
        in_danger_at: nil
      )
      # rubocop:enable Rails/SkipsModelValidations
    end

    suspended_count += 1
  end
end

puts "Suspended count: #{suspended_count}"
puts "Panelists without clean_id_data count: #{panelists_without_clean_id_data_count}"
