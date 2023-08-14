# frozen_string_literal: true

# PanelistSuspender analyzes a panelist to determine whether they should be suspended or not
class PanelistSuspender
  def initialize(panelist)
    @panelist = panelist
  end

  attr_reader :note

  def auto_suspend
    return if suspend_reason.nil?

    @panelist.suspend
    @panelist.notes.create!(employee_id: 0, body: "Automatically suspended: #{suspend_reason}.")
  end

  def manual_suspend!(employee:, note_body:)
    @note = @panelist.notes.new(employee: employee, body: note_body)

    return false if @note.invalid?

    @note.save
    @panelist.suspend

    true
  end

  private

  def suspend_reason
    return 'email invalid' if email_invalid?
    return 'failed CleanID' if clean_id_failed?
    return "CleanID country doesn't match the panel's country" if clean_id_country_invalid?
  end

  def email_invalid?
    @panelist.email.match?(/[0-9]{5,}.@/)
  end

  def clean_id_failed?
    raise 'no clean id data' if @panelist.clean_id_data.nil?

    validator = CleanIdValidator.new(@panelist.clean_id_data)
    validator.failed?
  end

  def clean_id_country_invalid?
    return false if @panelist.clean_id_data.blank?

    country = @panelist.clean_id_data.dig('forensic', 'geo', 'countryCode')

    return false if country.blank?
    return false if country.downcase == @panelist.primary_panel.country.slug.downcase
    return false if country == 'GB' && @panelist.primary_panel.country.slug == 'uk'

    true
  end
end
