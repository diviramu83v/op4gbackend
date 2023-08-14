# frozen_string_literal: true

Panelist.scorable.find_each do |panelist|
  PanelistScoreCalculator.new(panelist: panelist).calculate!
end
