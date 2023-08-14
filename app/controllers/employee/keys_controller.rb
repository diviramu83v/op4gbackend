# frozen_string_literal: true

class Employee::KeysController < Employee::OperationsBaseController
  include ActionView::Helpers::NumberHelper
  authorize_resource

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def index
    @survey = Survey.find(params[:survey_id])

    respond_to do |format|
      format.html do
        @keys = @survey.keys.order('used_at, created_at').page(params[:page]).per(50)

        # TODO: move this to another controller
        @keys = @keys.used if params[:status] == 'used'
        @keys = @keys.unused if params[:status] == 'unused'
      end
      format.csv do
        @keys = @survey.keys.order('used_at, created_at')
        send_data @keys.to_csv, filename: @survey.keys_filename
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def new
    @survey = Survey.find(params[:survey_id])
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @survey = Survey.find(params[:survey_id])
    @upload = key_params[:upload]

    if @survey.temporary_keys.present?
      flash[:alert] = 'Key import job in progress. Please wait until the current job finishes.'
      return redirect_to survey_keys_url(@survey)
    end

    check_key_count

    redirect_to survey_keys_url(@survey)
  rescue ActionController::ParameterMissing
    flash[:alert] = 'No upload file selected.'
    redirect_to new_survey_key_url(@survey)
  rescue CSV::MalformedCSVError => e
    flash[:alert] = "Uploaded file contents are not valid CSV: #{e}"
    redirect_to new_survey_key_url(@survey)
  rescue ArgumentError => e
    logger.info "WATCHING: Error caught: #{e.message}"
    flash[:alert] = 'Unable to upload file selected.'
    redirect_to new_survey_key_url(@survey)
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def destroy
    @key = Key.find(params[:id])
    @survey = @key.survey

    @key.destroy!

    redirect_to survey_keys_url(@survey)
  end

  private

  # rubocop:disable Metrics/MethodLength
  def check_key_count
    key_count = @survey.add_temporary_keys_from_csv(@upload.path)

    if key_count.zero?
      flash[:alert] = 'No keys found.'
    else
      flash[:notice] = "#{key_count} #{'key'.pluralize(key_count)} found. Import job started successfully."
    end

    return if key_count < Key::IMPORT_LIMIT

    formatted_key_count = number_with_delimiter(key_count, delimiter: ',')
    flash[:alert] =
      "You may have hit the limit on the number of keys to import at once.
      If you need more than #{formatted_key_count} keys, please break your file up."
  end
  # rubocop:enable Metrics/MethodLength

  def key_params
    params.require(:keys).permit(:upload)
  end
end
