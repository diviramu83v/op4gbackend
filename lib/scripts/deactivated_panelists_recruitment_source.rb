# frozen_string_literal: true

# Usage: rails runner lib/scripts/deactivated_panelists_recruitment_source.rb <name/type>
# i.e rails runner lib/scripts/deactivated_panelists_recruitment_source.rb name

start_time = Time.now.utc

@report_type = ARGV[0] || 'name'
@report_type = 'type' if @report_type.downcase == 't'

number_of_weeks = 8 # this param is editable for reports

deactivated_panelists = Panelist
                        .where(status: 'deactivated')
                        .where('deactivated_at <= ?', number_of_weeks.weeks.ago)

previous_deactivated_panelists = Panelist
                                 .where(status: 'deactivated')
                                 .where('deactivated_at BETWEEN ? AND ?', (number_of_weeks * 2).weeks.ago, number_of_weeks.weeks.ago)

def group_and_count(deactivated_panelists)
  deactivated_panelists.each_with_object(Hash.new(0)) do |panelist, hash|
    if @report_type == 'name'
      hash[panelist.recruiting_source_name] += 1
    else
      hash[panelist.recruiting_source_type] += 1
    end
  end
end

deactivated_panelists_grouped =
  if @report_type == 'name'
    group_and_count(deactivated_panelists).sort_by do |_name, count|
      count
    end.reverse
  else
    group_and_count(deactivated_panelists).sort_by do |_type, count|
      count
    end.reverse
  end

previous_deactivated_panelists_grouped = group_and_count(previous_deactivated_panelists)

puts
puts '---------------------------------------------------------------------------------------------------------------'
puts "Deactivated Panelists Recruitment Source Report for last #{number_of_weeks} weeks          Total: #{deactivated_panelists.count}"
puts '---------------------------------------------------------------------------------------------------------------'
puts
puts "Recruitment Source #{@report_type.to_s.capitalize}                                                  Count    Ct Diff      Share   Sh Diff"
puts '---------------------------------------------------------------------------------------------------------------'

if @report_type == 'name'
  deactivated_panelists_grouped.each do |name, count|
    deactivated_panelists_percentages = (count.to_f / deactivated_panelists.count) * 100
    previous_deactivated_panelists_percentages = (previous_deactivated_panelists_grouped[name].to_f / previous_deactivated_panelists.count) * 100
    count_difference_percentages = (count.to_f - previous_deactivated_panelists_grouped[name].to_f) / count * 100

    puts "#{format('%-70.70s', name.nil? ? 'No recruitment source' : name)}: " \
         "#{format('%5.5s', count)} " \
         "#{format('%+10.2f', count_difference_percentages)}%" \
         "#{format('%10.2f', deactivated_panelists_percentages)}% " \
         "#{format('%+7.2f', previous_deactivated_panelists_percentages - deactivated_panelists_percentages)}%"
  end
else
  deactivated_panelists_grouped.each do |type, count|
    deactivated_panelists_percentages = (count.to_f / deactivated_panelists.count) * 100
    previous_deactivated_panelists_percentages = (previous_deactivated_panelists_grouped[type].to_f / previous_deactivated_panelists.count) * 100
    count_difference_percentages = (count.to_f - previous_deactivated_panelists_grouped[type].to_f) / count * 100

    puts "#{format('%-70.70s', type.nil? ? 'No recruitment source' : type)}: " \
         "#{format('%5.5s', count)} " \
         "#{format('%+10.2f', count_difference_percentages)}%" \
         "#{format('%10.2f', deactivated_panelists_percentages)}% " \
         "#{format('%+7.2f', previous_deactivated_panelists_percentages - deactivated_panelists_percentages)}%"
  end
end

puts
puts "Completed in: #{Time.now.utc - start_time}"
