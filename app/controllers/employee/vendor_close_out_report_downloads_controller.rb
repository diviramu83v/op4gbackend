# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Employee::VendorCloseOutReportDownloadsController < ApplicationController
  authorize_resource class: 'Onboarding'
  before_action :set_variables, only: [:show]
  require 'spreadsheet'

  include ApplicationHelper

  def show
    if vendor_quota?(@vendor_name)
      export_quota_file(@file_name, quotas(@project, @vendor_name))
    else
      vendor = Vendor.find_by(name: @vendor_name)
      @vendor_batches = @project.vendor_batches.preload(:vendor, onramp:
        [:complete_onboardings, :complete_accepted_onboardings, :complete_fraudulent_onboardings, :complete_rejected_onboardings,
         :accepted_onboardings, :fraudulent_onboardings, :rejected_onboardings, :complete_recorded_onboardings, :onboardings]).where(vendor: vendor)

      export_vendor_file(@file_name, @vendor_batches)
    end

    DeleteVendorCloseOutDownloadFileJob.perform_later(@file_name)
  end

  private

  def set_variables
    @project = Project.find(params[:project_id])
    @vendor_name = params[:vendor_name]
    @file_name = "#{@project.id}_#{@vendor_name}_#{Time.zone.now.strftime('%m_%d_%Y')}.xls"
  end

  def vendor_quota?(vendor_name)
    %w[Disqo Cint Schlesinger].include?(vendor_name)
  end

  def quotas(project, vendor_name)
    return project.disqo_quotas if vendor_name == 'Disqo'
    return project.cint_surveys if vendor_name == 'Cint'

    project.schlesinger_quotas
  end

  def quota_id(onboarding)
    return onboarding.onramp.disqo_quota.quota_id if onboarding.onramp.disqo?
    return onboarding.onramp.cint_survey.cint_id if onboarding.onramp.cint?

    onboarding.onramp.schlesinger_quota.name
  end

  def quota_cpi(onboarding)
    return onboarding.onramp.disqo_quota.cpi if onboarding.onramp.disqo?
    return onboarding.onramp.cint_survey.cpi if onboarding.onramp.cint?

    onboarding.onramp.schlesinger_quota.cpi
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def export_quota_file(file_name, quotas)
    book = Spreadsheet::Workbook.new
    accepted = book.create_worksheet name: 'Accepted'
    accepted.row(0).concat ['PM Name', 'Op4G Admin ID', 'Quota ID', 'UID', 'Payout', 'Survey']
    rejected = book.create_worksheet name: 'Rejected'
    rejected.row(0).concat ['PM Name', 'Op4G Admin ID', 'Quota ID', 'UID', 'Payout', 'Reason', 'Survey']
    fraudulent = book.create_worksheet name: 'Fraudulent'
    fraudulent.row(0).concat ['PM Name', 'Op4G Admin ID', 'Quota ID', 'UID', 'Payout', 'Survey']
    accepted.column(0).width = 18
    accepted.column(1).width = 36
    accepted.column(3).width = 36
    accepted.column(5).width = 26
    rejected.column(0).width = 18
    rejected.column(1).width = 36
    rejected.column(3).width = 36
    rejected.column(6).width = 26
    fraudulent.column(0).width = 18
    fraudulent.column(1).width = 36
    fraudulent.column(3).width = 36
    fraudulent.column(5).width = 26

    quota_data(quotas, accepted, rejected, fraudulent)

    book.write(file_name)

    send_file(file_name, disposition: 'attachment', type: 'application/xls')
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def export_vendor_file(file_name, vendor_batches)
    book = Spreadsheet::Workbook.new
    accepted = book.create_worksheet name: 'Accepted'
    accepted.row(0).concat %w[UID CPI Survey]
    rejected = book.create_worksheet name: 'Rejected'
    rejected.row(0).concat %w[UID Reason CPI Survey]
    fraudulent = book.create_worksheet name: 'Fraudulent'
    fraudulent.row(0).concat %w[UID CPI Survey]
    accepted.column(0).width = 36
    accepted.column(2).width = 26
    rejected.column(0).width = 36
    rejected.column(3).width = 26
    fraudulent.column(0).width = 36
    fraudulent.column(2).width = 26

    vendor_data(vendor_batches, accepted, rejected, fraudulent)

    book.write(file_name)

    send_file(file_name, disposition: 'attachment', type: 'application/xls')
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Layout/LineLength
  def quota_data(quotas, accepted, rejected, fraudulent)
    Onboarding.complete.accepted.joins(:onramp).includes(:survey, :project, :disqo_quota, :cint_survey, :schlesinger_quota).where(onramps: { id: quotas.joins(:onramp).pluck(:'onramps.id') }).order('onramps.survey_id').each.with_index(1) do |onboarding, index|
      accepted.update_row index, onboarding.project.manager.name, onboarding.token, quota_id(onboarding), onboarding.uid,
                          format_currency_with_zeroes(quota_cpi(onboarding).to_f), onboarding.onramp.survey.name
    end

    Onboarding.complete.rejected.joins(:onramp).includes(:survey, :project, :disqo_quota, :cint_survey, :schlesinger_quota).where(onramps: { id: quotas.joins(:onramp).pluck(:'onramps.id') }).order('onramps.survey_id').each.with_index(1) do |onboarding, index|
      rejected.update_row index, onboarding.project.manager.name, onboarding.token, quota_id(onboarding), onboarding.uid,
                          format_currency_with_zeroes(quota_cpi(onboarding).to_f), onboarding.rejected_reason, onboarding.onramp.survey.name
    end

    Onboarding.complete.fraudulent.joins(:onramp).includes(:survey, :project, :disqo_quota, :cint_survey, :schlesinger_quota).where(onramps: { id: quotas.joins(:onramp).pluck(:'onramps.id') }).order('onramps.survey_id').each.with_index(1) do |onboarding, index|
      fraudulent.update_row index, onboarding.project.manager.name, onboarding.token, quota_id(onboarding), onboarding.uid,
                            format_currency_with_zeroes(quota_cpi(onboarding).to_f), onboarding.onramp.survey.name
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Layout/LineLength

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Layout/LineLength
  def vendor_data(vendor_batches, accepted, rejected, fraudulent)
    vendor_batches.group_by(&:vendor_name).each do |_vendor_name, batches|
      Onboarding.complete.accepted.joins(:onramp).includes(:survey).where(onramps: { vendor_batch_id: batches.pluck(:id) }).order('onramps.survey_id').each.with_index(1) do |onboarding, index|
        accepted.update_row index, onboarding.uid, format_currency_with_zeroes(onboarding.survey.cpi.to_f), onboarding.onramp.survey.name
      end

      Onboarding.complete.rejected.joins(:onramp).includes(:survey).where(onramps: { vendor_batch_id: batches.pluck(:id) }).order('onramps.survey_id').each.with_index(1) do |onboarding, index|
        rejected.update_row index, onboarding.uid, onboarding.rejected_reason, format_currency_with_zeroes(onboarding.survey.cpi.to_f),
                            onboarding.onramp.survey.name
      end

      Onboarding.complete.fraudulent.joins(:onramp).includes(:survey).where(onramps: { vendor_batch_id: batches.pluck(:id) }).order('onramps.survey_id').each.with_index(1) do |onboarding, index|
        fraudulent.update_row index, onboarding.uid, format_currency_with_zeroes(onboarding.survey.cpi.to_f), onboarding.onramp.survey.name
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Layout/LineLength
end
# rubocop:enable Metrics/ClassLength
