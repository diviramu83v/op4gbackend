# frozen_string_literal: true

class Employee::ReturnKeysController < Employee::OperationsBaseController
  authorize_resource
  before_action :set_survey

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def index
    respond_to do |format|
      format.html
      @return_keys = @survey.return_keys.order('used_at, created_at').page(params[:page]).per(50)
      format.csv do
        @return_keys = @survey.return_keys.order('used_at, created_at')
        file = CSV.generate do |csv|
          csv << %w[return_key created_at used_at]

          @return_keys.each do |return_key|
            csv << [return_key.token, return_key.created_at, return_key.used_at]
          end
        end
        send_data file, filename: "survey-#{@survey.id}-project-#{@survey.project.id}-return_keys.csv"
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def new
    @survey = Survey.find(params[:survey_id])
  end

  def create
    @survey = Survey.find(params[:survey_id])
    UploadReturnKeysJob.perform_later(@survey, key_number)

    redirect_to survey_return_keys_url(@survey, loading_keys: true)
  end

  private

  def key_number
    params.dig(:return_keys, :number)&.to_i
  end

  def set_survey
    @survey = Survey.find(params[:survey_id])
  end
end
