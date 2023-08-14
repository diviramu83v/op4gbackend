# frozen_string_literal: true

# deletes file created for vendor close out download
class DeleteVendorCloseOutDownloadFileJob < ApplicationJob
  queue_as :default

  # rubocop:disable Lint/NonAtomicFileOperation
  def perform(file_name)
    sleep(1.minute)
    File.delete(file_name) if File.exist?(file_name)
  end
  # rubocop:enable Lint/NonAtomicFileOperation
end
