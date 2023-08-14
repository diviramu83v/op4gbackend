# frozen_string_literal: true

class Employee::ExpertRecruitBatchesController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  before_action :load_survey, only: [:index, :new, :create]
  before_action :load_recruit_data, only: [:create, :update]

  def index; end

  def new
    @expert_recruit_batch = @survey.expert_recruit_batches.new
  end

  def edit
    @expert_recruit_batch = ExpertRecruitBatch.find(params[:id])
    @survey = @expert_recruit_batch.survey
  end

  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    @expert_recruit_batch = @survey.expert_recruit_batches.new(expert_recruit_batch_params)
    if @upload_file.blank? && @pasted_data.blank?
      flash[:alert] = 'No upload file selected or data entered.'
      return render 'new'
    end

    if show_pasted_data_error(@pasted_data)
      flash[:alert] = 'Invalid data entered. Please make sure each record has a valid email address and first name.'
      return render 'new'
    end

    if @expert_recruit_batch.save
      handle_uploaded_or_pasted_data
      redirect_to survey_expert_recruit_batches_url(@survey), notice: 'Successfully created expert recruit batch'
    else
      render 'new'
    end
  end

  def update
    @expert_recruit_batch = ExpertRecruitBatch.find(params[:id])
    @survey = @expert_recruit_batch.survey

    if @expert_recruit_batch.update(expert_recruit_batch_params)
      handle_uploaded_or_pasted_data
      redirect_to survey_expert_recruit_batches_url(@survey), notice: 'Successfully updated expert recruit batch'
    else
      flash.now[:alert] = 'Unable to update expert recruit batch'
      render 'edit'
    end
  end

  def handle_uploaded_or_pasted_data
    data = user_provided_data
    @expert_recruit_batch.update!(csv_data: data) if data.present?
  end

  def user_provided_data
    if @upload_file.present?
      get_csv_data(@upload_file)
    elsif @pasted_data.present?
      get_csv_data_from_text_area(@pasted_data)
    end
  end

  def destroy
    @expert_recruit_batch = ExpertRecruitBatch.find(params[:id])
    survey = @expert_recruit_batch.survey
    @expert_recruit_batch.destroy
    flash[:notice] = 'Expert recruit batch has been removed'
    redirect_to survey_expert_recruit_batches_url(survey)
  end

  private

  def expert_recruit_batch_params
    params.require(:expert_recruit_batch).permit(:description, :email_subject, :incentive, :employee_id, :time, :first_name,
                                                 :send_for_client, :client_name, :client_phone, :logo, :from_email, :email_body, :email_signature, :color)
  end

  def load_survey
    @survey = Survey.find(params[:survey_id])
  end

  def get_csv_data(file)
    CSV.foreach(file.path, headers: true).with_object({}) do |row, hash|
      next unless row['email'].present? && row['first_name'].present?

      hash[row['email']] = row['first_name']
    end.to_json
  end

  def get_csv_data_from_text_area(text_area)
    text_area.split("\n").each_with_object({}) do |row, hash|
      next if row.blank?

      row = row.split(',')
      next unless row_valid?(row)

      # row[0] is email, row[1] is the first_name
      hash[row[0].strip] = row[1].strip
    end.to_json
  end

  def row_valid?(row)
    row[0].include?('@') && row[1].exclude?('@')
  end

  def load_recruit_data
    @upload_file = params[:expert_recruit_batch][:emails_first_names]
    @pasted_data = params[:expert_recruit_batch][:pasted_first_names_emails]
  end

  def pasted_data_valid?(pasted_data)
    row_array = pasted_data.split(/\r\n/).map(&:strip)
    new_row_array = row_array.map { |row| row.split(',').map(&:strip) }
    data_valid = nil
    new_row_array.each do |row|
      data_valid = true if row.length > 1 && row_valid?(row)
    end
    data_valid
  end

  def show_pasted_data_error(pasted_data)
    pasted_data.present? && !pasted_data_valid?(pasted_data)
  end
end
