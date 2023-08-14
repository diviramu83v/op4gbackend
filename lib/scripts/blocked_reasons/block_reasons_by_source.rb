# frozen_string_literal: true

# 1 argument: # 1 argument: number_of_weeks
# Usage: rails runner lib/scripts/block_reasons_by_source.rb 1

### Helpers ###

def format_reason_name(reason)
  reason.sub!('failed: ', '')
  reason.sub!(/(Recaptcha: over allowed time).*/, '\1')
  reason.gsub!('_', ' ')

  reason
end

def build_hash(onboardings)
  onboardings.each_with_object({}) do |block, hash|
    if hash[block.source.name].is_a?(Array)
      hash[block.source.name].append(block)
    else
      hash[block.source.name] = [block]
    end
  end
end

### Script ###

start_script = Time.zone.now

number_of_weeks = ARGV[0].to_i

start_time = number_of_weeks.weeks.ago.beginning_of_week
end_time = Time.now.utc

previous_start_time = (number_of_weeks * 2).weeks.ago.beginning_of_week
previous_end_time = start_time

onboardings = Onboarding.blocked.where(created_at: start_time..end_time)
previous_onboardings = Onboarding.blocked.where(created_at: previous_start_time..previous_end_time)

puts '---------------------------------------------------------------------'
puts "Blocked Reasons by Source   Total: #{onboardings.count} records"
puts '---------------------------------------------------------------------'
puts

blocks_by_source = build_hash(onboardings)
previous_blocks_by_source = build_hash(previous_onboardings)

# rubocop:disable Metrics/BlockLength
blocks_by_source.each do |source_name, blocks|
  puts
  puts "#{source_name}   Total: #{blocks.length}"
  puts '-------------------------------------------------------------------'
  puts 'Count Reason                                    % Share   Change'
  puts '-------------------------------------------------------------------'

  count_hash = Hash.new(0)
  blocks.each do |block|
    next if block.error_message.blank?

    count_hash[format_reason_name(block.error_message)] += 1
  end
  count_hash = count_hash.sort_by { |_k, v| -v }.to_h

  previous_count_hash = Hash.new(0)
  previous_blocks = previous_blocks_by_source[source_name]
  previous_blocks = {} if previous_blocks.nil?

  previous_blocks.each do |block|
    next if block.error_message.blank?

    previous_count_hash[format_reason_name(block.error_message)] += 1
  end

  count_hash.each do |key, value|
    if key.blank?
      printf "%-5<value>s %<reason>s\n", value: value, reason: 'No reason found'
    else
      share = value.to_f / blocks.length

      previous_count = previous_count_hash[key] || 0
      previous_length = previous_blocks.length || 1

      old_share = previous_count.to_f / previous_length
      change_in_share = share - old_share

      # rubocop:disable Style/FormatStringToken
      printf "%-5s %-39.39s %8.2f%%  (%+.2f%%)\n", value, key.sub('failed: ', ''), share * 100, change_in_share * 100
      # rubocop:enable Style/FormatStringToken
    end
  end

  puts
  puts
end
# rubocop:enable Metrics/BlockLength

end_script = Time.zone.now
puts "Run time: #{(end_script - start_script).to_i} seconds"
