# frozen_string_literal: true

# Usage: rails runner lib/scripts/deleted_panelists_recruitment_source.rb <name/type>
# i.e rails runner lib/scripts/deleted_panelists_recruitment_source.rb name

start_time = Time.now.utc

@report_type = ARGV[0] || 'name'
@report_type = 'type' if @report_type.downcase == 't'

number_of_weeks = 8 # this param is editable for reports

deleted_panelists = Panelist
                    .where(status: 'deleted')
                    .where('deleted_at <= ?', number_of_weeks.weeks.ago)

previous_deleted_panelists = Panelist
                             .where(status: 'deleted')
                             .where('deleted_at BETWEEN ? AND ?', (number_of_weeks * 2).weeks.ago, number_of_weeks.weeks.ago)

def group_and_count(deleted_panelists)
  deleted_panelists.each_with_object(Hash.new(0)) do |panelist, hash|
    if @report_type == 'name'
      hash[panelist.recruiting_source_name] += 1
    else
      hash[panelist.recruiting_source_type] += 1
    end
  end
end

deleted_panelists_grouped =
  if @report_type == 'name'
    group_and_count(deleted_panelists).sort_by do |_name, count|
      count
    end.reverse
  else
    group_and_count(deleted_panelists).sort_by do |_type, count|
      count
    end.reverse
  end

previous_deleted_panelists_grouped = group_and_count(previous_deleted_panelists)

puts
puts '---------------------------------------------------------------------------------------------------------------'
puts "Deleted Panelists Recruitment Source Report for last #{number_of_weeks} weeks          Total: #{deleted_panelists.count}"
puts '---------------------------------------------------------------------------------------------------------------'
puts
puts "Recruitment Source #{@report_type.to_s.capitalize}                                                  Count    Ct Diff      Share   Sh Diff"
puts '---------------------------------------------------------------------------------------------------------------'

if @report_type == 'name'
  deleted_panelists_grouped.each do |name, count|
    deleted_panelists_percentages = (count.to_f / deleted_panelists.count) * 100
    previous_deleted_panelists_percentages = (previous_deleted_panelists_grouped[name].to_f / previous_deleted_panelists.count) * 100
    count_difference_percentages = (count.to_f - previous_deleted_panelists_grouped[name].to_f) / count * 100

    puts "#{format('%-70.70s', name.nil? ? 'No recruitment source' : name)}: " \
         "#{format('%5.5s', count)} " \
         "#{format('%+10.2f', count_difference_percentages)}% " \
         "#{format('%10.2f', deleted_panelists_percentages)}% " \
         "#{format('%+7.2f', previous_deleted_panelists_percentages - deleted_panelists_percentages)}%"
  end
else
  deleted_panelists_grouped.each do |type, count|
    deleted_panelists_percentages = (count.to_f / deleted_panelists.count) * 100
    previous_deleted_panelists_percentages = (previous_deleted_panelists_grouped[type].to_f / previous_deleted_panelists.count) * 100
    count_difference_percentages = (count.to_f - previous_deleted_panelists_grouped[type].to_f) / count * 100

    puts "#{format('%-70.70s', type.nil? ? 'No recruitment source' : type)}: " \
         "#{format('%5.5s', count)} " \
         "#{format('%+10.2f', count_difference_percentages)}% " \
         "#{format('%10.2f', deleted_panelists_percentages)}% " \
         "#{format('%+7.2f', previous_deleted_panelists_percentages - deleted_panelists_percentages)}%"
  end
end

puts
puts "Completed in: #{Time.now.utc - start_time}"
