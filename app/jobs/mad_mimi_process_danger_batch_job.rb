# frozen_string_literal: true

# Processes all panelists who are nearing deactivation.
class MadMimiProcessDangerBatchJob < ApplicationJob
  queue_as :background

  def perform
    Panelist.process_endangered_panelists
  end
end
