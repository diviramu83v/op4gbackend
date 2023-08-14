# frozen_string_literal: true

# A system event is any user action that we record. For now, that just means
#   URLs that they visit.
class SystemEvent < ApplicationRecord
  after_create :broadcast

  belongs_to :api_token, optional: true
  belongs_to :employee, optional: true

  scope :in_last_hour, -> { where('created_at > ?', Time.now.utc - 1.hour) }
  scope :from_api_token, ->(token) { where(api_token: token) }

  def self.format_description(url:, subdomain:, controller:, action:)
    "URL: #{url}\nAction: #{subdomain}.#{controller}##{action}\n"
  end

  def self.summarize_and_delete_old_data(before_day:)
    before_time = before_day.beginning_of_day

    grouped_records = group_records(cutoff: before_time)
    import_failures = save_summary_records(records: grouped_records)
    delete_summarized_data(cutoff: before_time, failed_saves: import_failures)
  end

  private

  # TODO: Move this to an events queue job.
  def broadcast
    # row_partial = ApplicationController.render(
    #   partial: 'admin/events/row',
    #   locals: { event: self }
    # )

    # data = { table_row: row_partial }

    # EventsChannel.broadcast_to('all', data)
  end

  # rubocop:disable Metrics/MethodLength
  private_class_method def self.group_records(cutoff:)
    sql = <<-SQL
      SELECT
        date_trunc('day', happened_at) AS day_happened_at,
        REPLACE(SPLIT_PART(description, 'Action: ', 2), '\n', '') AS action,
        count(*) AS count
      FROM
        system_events
      WHERE
        happened_at < #{ActiveRecord::Base.connection.quote(cutoff)}
      GROUP BY
        day_happened_at,
        action
      ORDER BY
        day_happened_at,
        action
    SQL
    ActiveRecord::Base.connection.exec_query(sql)
  end
  # rubocop:enable Metrics/MethodLength

  private_class_method def self.save_summary_records(records:)
    summary_imports = SystemEventSummary.import(records.to_a)
    summary_import_failures = summary_imports.failed_instances
    summary_import_failures
  end

  private_class_method def self.delete_summarized_data(cutoff:, failed_saves:)
    events = SystemEvent.where('happened_at < ?', cutoff)
    failed_saves.each do |failed_save|
      failed_event = events.find { |event| event.id == failed_save.id }
      failed_event&.delete
    end
    count = events.count
    events.delete_all
  end
end
