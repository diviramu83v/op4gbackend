# frozen_string_literal: true

namespace :sweepstakes do
  task generate: :environment do
    op4g = Panel.find_by(slug: 'op4g')

    panelists = []

    op4g.panelists.active.find_each do |panelist|
      recent_finished_traffic = panelist.onboardings.finished.where('created_at > ?', Time.now.utc - 30.days)

      panelists << panelist if panelist.contributing_to_nonprofit? && recent_finished_traffic.any?
    end

    panelists_with_random_number = panelists.map { |panelist| [panelist, rand(1_000_000)] }.sort! { |x, y| x[1] <=> y[1] }

    top_ten_panelists = panelists_with_random_number.first(10)

    puts %w[Name Email Nonprofit].join(',')

    top_ten_panelists.each do |panelist_data|
      panelist = panelist_data[0]

      puts [panelist.name.titleize, panelist.email, panelist.nonprofit.name].join(',')
    end
  end
end
