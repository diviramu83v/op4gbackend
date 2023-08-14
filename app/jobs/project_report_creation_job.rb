# frozen_string_literal: true

# The job that creates a fresh project report for caching
class ProjectReportCreationJob < ApplicationJob
  queue_as :ui

  def perform
    ProjectReport.create
  rescue Seahorse::Client::NetworkingError
    # do nothing
  end
end
