# frozen_string_literal: true

# rails runner lib/scripts/score_active_and_suspended_panelists.rb

panelists = Panelist.scorable

panelists.find_each do |panelist|
  PanelistScoreCalculator.new(panelist: panelist).calculate!
end
