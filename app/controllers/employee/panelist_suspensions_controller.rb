# frozen_string_literal: true

class Employee::PanelistSuspensionsController < Employee::OperationsBaseController
  authorize_resource 'Onboarding'

  def new; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    suspend_count = 0
    not_found_count = 0
    panelist_suspension_params.each do |email_or_token|
      panelist = find_panelist(email_or_token)
      if panelist.blank?
        not_found_count += 1
        next
      end
      next unless panelist.suspend

      suspend_count += 1
      panelist.notes.create(employee_id: current_employee.id, body: params[:panelist_emails_or_tokens][:note])
      panelist.block_ips(params[:panelist_emails_or_tokens][:note])
    end

    flash[:notice] = "#{suspend_count} #{'panelist'.pluralize(suspend_count)} suspended"
    if not_found_count.positive?
      flash[:alert] =
        "#{not_found_count} #{'email'.pluralize(not_found_count)} / #{'token'.pluralize(not_found_count)}
         didn't correspond to a panelist"
    end

    redirect_to new_panelist_suspension_url
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def find_panelist(email_or_token)
    if email_or_token.include?('@')
      get_panelist_by_email(email_or_token)
    else
      get_panelist_by_onboarding_token(email_or_token)
    end
  end

  def panelist_suspension_params
    params[:panelist_emails_or_tokens][:emails_or_tokens].gsub("\r\n", ' ').tr(',', ' ').split
  end

  def get_panelist_by_email(email)
    Panelist.find_by(email: email)
  end

  def get_panelist_by_onboarding_token(token)
    onboarding = Onboarding.find_by(token: token)
    return if onboarding.nil?

    Panelist.find_by(id: onboarding.panelist_id)
  end
end
