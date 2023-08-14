# frozen_string_literal: true

Panelist.active.find_each do |panelist|
  PanelistScoreCalculator.new(panelist: panelist).calculate!
end
