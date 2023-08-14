# frozen_string_literal: true

# This lists the top and bottom scoring panelists
# and prints their score, name, and email

# To get the most up to date scores first run:
# rails runner lib/scripts/calculate_active_panelists_score.rb

# Then run this script with:
# rails runner lib/scripts/panelists_top_and_bottom_scores.rb

all_panelists = []
top_half = []
bottom_half = []

positive_score_panelists = Panelist.active.where('score > ?', 0)

positive_score_panelists.each do |panelist|
  all_panelists << {
    name: panelist.first_name,
    email: panelist.email,
    score: panelist.score
  }
end

sorted_panelists = all_panelists.sort_by { |panelist| panelist[:score] }

sorted_panelists.each_with_index do |panelist, index|
  if index < sorted_panelists.length / 2
    bottom_half << panelist
  else
    top_half << panelist
  end
end

puts '
********** START BOTTOM HALF **********

'

bottom_half.each do |p|
  puts "Score: #{p[:score]}, Name: #{p[:name]}, Email: #{p[:email]}"
end

puts '



********** START TOP HALF **********



'

top_half.each do |p|
  puts "Score: #{p[:score]}, Name: #{p[:name]}, Email: #{p[:email]}"
end

puts '
***** STATS *****

'

bottom_half_low_score = bottom_half.first[:score]
bottom_half_high_score = bottom_half.last[:score]

top_half_low_score = top_half.first[:score]
top_half_high_score = top_half.last[:score]

puts "Bottom half total panelists: #{bottom_half.count}"
puts "Bottom half score range: #{bottom_half_low_score} - #{bottom_half_high_score}"
puts "Top half total panelists: #{top_half.count}"
puts "Top half score range: #{top_half_low_score} - #{top_half_high_score}"
