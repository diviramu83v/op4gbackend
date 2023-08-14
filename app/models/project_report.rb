# frozen_string_literal: true

# ProjectReports are generated on by the Projects index.
# The reports list the currently active projects and may either be cached or built on the fly.
class ProjectReport < ApplicationRecord
  has_attached_file :report, Rails.configuration.paperclip_project_reports

  before_validation :add_spreadsheet
  after_create :broadcast

  validates_attachment :report, presence: true, content_type: {
    content_type: [
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    ]
  }

  def filename
    "project-report-#{report_updated_at.in_time_zone('Central Time (US & Canada)').strftime('%Y-%m-%d')}.xlsx"
  end

  private

  def add_spreadsheet
    self.report = generate_spreadsheet_file
  end

  def broadcast
    html = ApplicationController.render(
      partial: 'employee/projects/report_buttons',
      locals: { report: self }
    )

    ProjectReportsChannel.broadcast_to('all', html)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def generate_spreadsheet_file
    p = Axlsx::Package.new
    wb = p.workbook

    number_format = '#,##0'
    money_format = '$#,##0.00'

    color_gray = 'eeeeee'
    color_green = '7cd6a9'
    color_blue = '69c0ef'
    color_red = 'e2737b'

    header = wb.styles.add_style(
      bg_color: color_gray,
      alignment: { horizontal: :center }
    )

    number = wb.styles.add_style(
      alignment: { horizontal: :right },
      format_code: number_format
    )

    money = wb.styles.add_style(
      alignment: { horizontal: :right },
      format_code: money_format
    )

    green = wb.styles.add_style(
      bg_color: color_green
    )

    green_number = wb.styles.add_style(
      bg_color: color_green,
      alignment: { horizontal: :right },
      format_code: number_format
    )

    green_money = wb.styles.add_style(
      bg_color: color_green,
      alignment: { horizontal: :right },
      format_code: money_format
    )

    blue = wb.styles.add_style(
      bg_color: color_blue
    )

    blue_number = wb.styles.add_style(
      bg_color: color_blue,
      alignment: { horizontal: :right },
      format_code: number_format
    )

    blue_money = wb.styles.add_style(
      bg_color: color_blue,
      alignment: { horizontal: :right },
      format_code: money_format
    )

    red = wb.styles.add_style(
      bg_color: color_red
    )

    red_number = wb.styles.add_style(
      bg_color: color_red,
      alignment: { horizontal: :right },
      format_code: number_format
    )

    red_money = wb.styles.add_style(
      bg_color: color_red,
      alignment: { horizontal: :right },
      format_code: money_format
    )

    header_row = [
      header, header, header, header, header, header, header, header, header,
      header, header, header, header, header, header, header, header
    ]

    draft_row = [
      nil, nil, nil, nil, nil, nil, nil, nil, nil, number, money, number,
      number, money, money, nil, nil
    ]

    live_row = [
      blue, blue, blue, blue, blue, blue, blue, blue, blue, blue_number,
      blue_money, blue_number, blue_number, blue_money, blue_money, blue, blue
    ]

    hold_row = [
      red, red, red, red, red, red, red, red, red, red_number, red_money,
      red_number, red_number, red_money, red_money, red, red
    ]

    finished_row = [
      green, green, green, green, green, green, green, green, green,
      green_number, green_money, green_number, green_number, green_money,
      green_money, green, green
    ]

    # rubocop:disable Metrics/BlockLength
    wb.add_worksheet(name: 'Projects') do |sheet|
      sheet.add_row [
        'ID', 'WO', 'Status', 'Client', 'Project', 'Survey', 'Type',
        'Manager', 'Salesperson', 'Created', 'CPI', 'Original Quota',
        'Current Progress', 'Original Value', 'Current Value', 'Started',
        'Ended'
      ],
                    style: header_row

      # Get the array of survey ids into memory, and use that as the full indexed order
      Survey.reportable_and_finished_within_90_days.ordered_by_id.pluck(:id).each do |survey_id|
        survey = Survey.find(survey_id)
        style = case survey.status
                when 'draft' then draft_row
                when 'live' then live_row
                when 'hold' then hold_row
                when 'finished' then finished_row
                else []
                end
        survey_row = [
          survey.project.id,
          value_or_question_mark(survey.project.work_order),
          survey.status,
          value_or_question_mark(survey.project.client.try(:name)),
          survey.project.name,
          survey.name,
          value_or_question_mark(survey.project.product_name),
          survey.project.manager.name,
          value_or_question_mark(survey.project.salesperson.try(:name)),
          format_excel_date(survey.project.created_at),
          value_or_question_mark(survey.cpi),
          value_or_question_mark(survey.target),
          value_or_question_mark(survey.adjusted_complete_count),
          value_or_question_mark(survey.value),
          format_excel_date(survey.project.started_at),
          format_excel_date(survey.project.finished_at)
        ]

        sheet.add_row survey_row, style: style
      end
    end
    # rubocop:enable Metrics/BlockLength

    p.to_stream
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def value_or_question_mark(value)
    value.presence || '?'
  end

  def format_excel_date(date)
    return if date.blank?

    date.strftime('%-m/%-d/%Y')
  end
end
