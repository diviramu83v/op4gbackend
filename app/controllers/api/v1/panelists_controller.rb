# frozen_string_literal: true

class Api::V1::PanelistsController < Api::BaseController
  protect_from_forgery with: :null_session

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    return missing_attributes_response unless all_params_present?
    return bad_attributes_response if invalid_attributes?
    return duplicate_email_response if duplicate_email?

    @panelist = Panelist.new(panelist_params)

    @panelist.assign_attributes(
      locale: Locale.default,
      campaign: campaign,
      original_panel: panel,
      primary_panel: panel,
      lock_flag: campaign.lock_flag,
      last_activity_at: Time.now.utc
    )

    if @panelist.save
      @panelist.panels << @panelist.original_panel
      success_response
    else
      save_error_response
    end

    # Temporary logging: just an easy way to see when this is being used.
    Rails.logger.info("Panelist API request completed for vendor; id: #{@token.vendor.id}")
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def panelist_params
    params.require(:panelist)
          .permit(:first_name, :last_name, :email, :password)
  end

  def all_params
    params.require(:panelist)
          .permit(:first_name, :last_name, :email, :password, :code, :panel)
  end

  # rubocop:disable Metrics/AbcSize
  def all_params_present?
    all_params[:first_name].present? &&
      all_params[:last_name].present? &&
      all_params[:email].present? &&
      all_params[:password].present? &&
      all_params[:code].present? &&
      all_params[:panel].present?
  end
  # rubocop:enable Metrics/AbcSize

  def invalid_attributes?
    panel.nil? || campaign.nil?
  end

  def duplicate_email?
    email = all_params[:email].strip.downcase
    Panelist.find_by(email: email).present?
  end

  def campaign
    @campaign ||= RecruitingCampaign.find_by(code: all_params[:code])
  end

  def panel
    @panel ||= Panel.find_by(slug: panel_slug)
  end

  def panel_slug
    all_params[:panel].try(:downcase)
  end

  def missing_attributes_response
    render status: :bad_request,
           json: { status: 400, error: 'Missing required attributes.' }.to_json
  end

  def bad_attributes_response
    render status: :bad_request,
           json: { status: 400, error: 'Invalid attributes.' }.to_json
  end

  def duplicate_email_response
    render status: :bad_request,
           json: {
             status: 400,
             error: 'Email address has already been used.'
           }.to_json
  end

  def success_response
    render status: :created,
           json: {
             status: 201,
             message: 'Successfully created new panelist.'
           }.to_json
  end

  def save_error_response
    render status: :bad_request,
           json: {
             status: 400,
             error: 'Unexpected error. Unable to complete sign up.'
           }.to_json
  end
end
