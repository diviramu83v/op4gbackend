# frozen_string_literal: true

# This prints the number of each panelist for each score

# To get the most up to date scores run:
# rails runner lib/scripts/calculate_active_panelists_score.rb
# to update all the panelists' scores

# Then run this script with:
# rails runner lib/scripts/panelists_score_count_values.rb

all_scores = Panelist.active.pluck(:score)

unique_scores = all_scores.uniq
unique_scores.sort!

unique_scores.each do |score|
  puts "Score: #{score}, Count: #{all_scores.count(score)}"
end
