# frozen_string_literal: true

# View helpers that are used throughout the entire application.
# rubocop:disable Metrics/ModuleLength
module ApplicationHelper
  include ActionView::Helpers::NumberHelper

  def active_employee_nav(nav_section, current_section)
    'active' if nav_section == current_section
  end

  def flash_class(level)
    case level
    when 'notice' then 'alert alert-info'
    when 'alert' then 'alert alert-danger'
    else 'alert'
    end
  end

  def activate_class(url, other_classes = '')
    return "#{other_classes} active" if request.original_url == url

    other_classes
  end

  def nav_link_class(url, exact: false)
    return 'nav-link active' if (request.original_url == url) && (exact == true)
    return 'nav-link active' if (request.original_url.include? url) && (exact == false)

    'nav-link'
  end

  def value_or_zero(value)
    value.presence || '0'
  end

  def value_or_question_mark(value)
    value.presence || '?'
  end

  def format_number(value)
    return '?' if value.blank?

    number_with_delimiter(value, delimiter: ',')
  end

  def format_date(date)
    return if date.nil?

    tag.span(date, data: { 'utc-time': date, 'timezone-converted': false })
  end

  def format_long_date(date)
    return if date.nil?

    tag.span(date, data: { 'utc-time': date, format: 'long', 'timezone-converted': false })
  end

  def format_stacked_date(date)
    return if date.nil?

    tag.span(date, data: { 'utc-time': date, format: 'stacked', 'timezone-converted': false })
  end

  def format_payment_date(date)
    l(date, format: "%B #{date.day.ordinalize}")
  end

  def format_payment_date_with_year(date)
    l(date, format: "%B #{date.day.ordinalize}, %Y")
  end

  def format_excel_date(date)
    return if date.blank?

    date.strftime('%-m/%-d/%Y')
  end

  def format_month_year_date(date)
    date.strftime('%B, %Y')
  end

  def format_percentage(value)
    return '?' if value.blank?

    number_to_percentage(value, precision: 2)
  end

  def format_percentage_with_no_zeroes(value)
    return '?' if value.blank?

    number_to_percentage(value, precision: 0)
  end

  def format_percentage_from_two_values(numerator:, denominator:)
    format_percentage(numerator / denominator.to_f * 100)
  end

  # def cents_to_dollars(cents)
  #   cents.to_f / 100
  # end

  def format_currency(value)
    return '?' if value.blank?

    number_to_currency(value).gsub(/\.00$/, '')
  end

  def format_currency_with_zeroes(value)
    return '?' if value.blank?

    number_to_currency(value)
  end

  def format_currency_with_zeroes_no_dollar_sign(value)
    return '?' if value.blank?

    number_to_currency(value).delete('$')
  end

  def format_bool_as_yes_no(value)
    if value
      tag.span('Yes', class: 'badge badge-success')
    else
      tag.span('No', class: 'badge badge-dark')
    end
  end

  def format_bool_as_on_off(value)
    value ? 'On' : 'Off'
  end

  def format_bool_as_colored_on_off(value, klass = nil)
    if value
      tag.span('On', class: "badge badge-success #{klass}")
    else
      tag.span('Off', class: "badge badge-dark #{klass}")
    end
  end

  def format_loi_as_whole_minutes(minutes)
    return if minutes.nil?

    pluralize(minutes.round, 'minute')
  end

  def format_loi_as_rounded_minutes(minutes)
    return if minutes.nil?

    pluralize(minutes.round(1), 'minute')
  end

  def format_loi_seconds(seconds)
    return if seconds.nil?
    return format_loi_as_rounded_minutes(seconds / 60) if seconds >= 60

    pluralize(seconds.round, 'second')
  end

  def convert_newlines_to_br_tags(content)
    return if content.nil?

    content.gsub("\n", '<br>')
  end

  def demo_question_panelist_percentage(question, question_panelist_count, query)
    return if [question, question_panelist_count, query].any?(&:blank?)

    panelist_count = query.panel.panelists.active.count
    return if panelist_count.zero?

    count = question_panelist_count.find { |arr| arr.first == question.id }.last
    percentage = ((count.to_f / panelist_count) * 100).round

    "#{percentage}%"
  end

  def convert_array_to_text_area(input)
    if input.instance_of?(Array)
      input.join("\n")
    else
      input
    end
  end
end
# rubocop:enable Metrics/ModuleLength
