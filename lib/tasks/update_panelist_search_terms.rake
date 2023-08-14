# frozen_string_literal: true

task update_panelist_search_terms: :environment do
  puts "Updating search term field for #{Panelist.count} panelists..."

  Panelist.find_each.map(&:update_search_terms)

  puts 'All panelist search terms updated.'
end
