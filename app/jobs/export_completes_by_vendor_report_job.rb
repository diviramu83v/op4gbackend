# frozen_string_literal: true

# export data for completes by vendor report
class ExportCompletesByVendorReportJob < ApplicationJob
  include ApplicationHelper
  queue_as :default

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def perform(current_user, start_date, end_date, vendor_id)
    csv_file = if vendor_id.blank?
                 generate_all_vendors_csv(start_date, end_date)
               else
                 generate_single_vendor_csv(start_date, end_date, vendor_id)
               end

    CompletesByVendorReportDownloadChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: "vendor_report_#{format_date_for_filename(start_date)}_to_#{format_date_for_filename(end_date)}_#{vendor_for_filename(vendor_id)}.csv",
        content: csv_file
      }
    )
  end

  private

  def generate_all_vendors_csv(start_date, end_date)
    CSV.generate do |csv|
      csv << ['Project ID', 'Project Name', 'Work Order', 'Survey Name', 'Vendor', 'Country', 'Audience', 'Quoted completes', 'Requested completes',
              'Client CPI', 'Incentive', 'Captured Completes', 'Final Status: Accepted', 'Final Status: Rejected', 'Final Status: Fraudulent']

      start_time = start_date.to_datetime.utc
      end_time = end_date.to_datetime.utc

      surveys = Survey.joins(:onramps, :onboardings, :vendor_batches)
                      .includes(:project)
                      .where(onboardings: { created_at: start_time..end_time })
                      .where.not(vendor_batches: { vendor_id: nil }).distinct

      surveys.find_each do |survey|
        next unless survey.vendor_batches

        survey.vendor_batches.find_each do |vendor_batch|
          quoted_completes = vendor_batch.quoted_completes
          requested_completes = vendor_batch.quoted_completes
          onramp = survey.onramps.where(vendor_batch: vendor_batch).first
          completes = onramp.onboardings.complete.where(created_at: start_time..end_time)
          accepted_count = completes.accepted.count
          rejected_count = completes.rejected.count
          fraudulent_count = completes.fraudulent.count

          csv << [survey.project.id, survey.project.name, survey.project.work_order, survey.name, vendor_batch.vendor.name, survey.country&.name,
                  survey.audience, format_number(quoted_completes), format_number(requested_completes), format_currency(survey.cpi.to_f),
                  format_currency(vendor_batch.incentive.to_f), format_number(completes.count), format_number(accepted_count), format_number(rejected_count),
                  format_number(fraudulent_count)]
        end
      end
    end
  end

  def generate_single_vendor_csv(start_date, end_date, vendor_id)
    CSV.generate do |csv|
      csv << ['Project ID', 'Project Name', 'Work Order', 'Survey Name', 'Country', 'Audience', 'Quoted completes', 'Requested completes', 'Client CPI',
              'Incentive', 'Captured Completes', 'Final Status: Accepted', 'Final Status: Rejected', 'Final Status: Fraudulent']

      start_time = start_date.to_datetime.utc
      end_time = end_date.to_datetime.end_of_day.utc
      vendor = Vendor.find(vendor_id)

      surveys = Survey.joins(:onramps, :onboardings, :vendor_batches)
                      .includes(:project)
                      .where(onboardings: { created_at: start_time..end_time })
                      .where(vendor_batches: { vendor_id: vendor_id }).distinct

      surveys.find_each do |survey|
        quoted_completes = survey.vendor_batches.find_by(vendor: vendor).quoted_completes
        requested_completes = survey.vendor_batches.find_by(vendor: vendor).requested_completes
        vendor_batches = vendor.vendor_batches
        vendor_batch = survey.vendor_batches.where(vendor_id: vendor.id).first
        onramp = survey.onramps.where(vendor_batch: vendor_batches).first
        completes = onramp.onboardings.complete.where(created_at: start_time..end_time)
        accepted_count = completes.accepted.count
        rejected_count = completes.rejected.count
        fraudulent_count = completes.fraudulent.count

        csv << [survey.project.id, survey.project.name, survey.project.work_order, survey.name, survey.country&.name, survey.audience,
                format_number(quoted_completes), format_number(requested_completes), format_currency(survey.cpi.to_f),
                format_currency(vendor_batch.incentive.to_f), format_number(completes.count), format_number(accepted_count), format_number(rejected_count),
                format_number(fraudulent_count)]
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def format_date_for_filename(date)
    date.to_datetime.strftime('%m_%d_%Y')
  end

  def vendor_for_filename(vendor_id)
    return 'all_vendors' if vendor_id.blank?

    Vendor.find(vendor_id).name.downcase
  end
end
