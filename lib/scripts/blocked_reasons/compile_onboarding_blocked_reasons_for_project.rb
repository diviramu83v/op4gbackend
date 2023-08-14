# frozen_string_literal: true

# 1 argument: Project ID
# Usage: rails runner lib/scripts/compile_onboarding_blocked_reasons_for_project.rb project_id

start_script = Time.zone.now
project_id = ARGV[0].to_i

project = Project.find_by(id: project_id)

# rubocop:disable Lint/TopLevelReturnWithArgument
return puts 'Project not found' if project.blank?

# rubocop:enable Lint/TopLevelReturnWithArgument

ultimate_hash = project.onramps.each_with_object({}) do |onramp, outer_hash|
  next if onramp.testing?

  onboardings = onramp.onboardings.blocked
  new_hash = onboardings.each_with_object(Hash.new(0)) do |onboarding, hash|
    hash[onboarding.error_message] += 1
  end
  outer_hash[onramp] = new_hash.sort_by { |_k, v| -v }.to_h
end

ultimate_hash.each do |onramp, reasons_hash|
  puts "************* onramp id: #{onramp.id}, #{onramp.category}: #{onramp.source_model_name} *************"
  puts 'No blocks recorded' if reasons_hash.blank?
  reasons_hash.each do |key, value|
    if key.blank?
      printf "%-5<value>s %<reason>s\n", value: value, reason: 'No reason returned'
    else
      printf "%-5<value>s %<key>s\n", value: value, key: key
    end
  end
  puts "\n"
end

end_script = Time.zone.now
puts "Run time: #{(end_script - start_script).to_i} seconds"
