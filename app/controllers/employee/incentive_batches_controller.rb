# frozen_string_literal: true

class Employee::IncentiveBatchesController < Employee::RecruitmentBaseController
  authorize_resource class: 'IncentiveBatch'

  before_action :load_batch, only: [:show, :edit, :update]

  def index
    @incentive_batches = IncentiveBatch.all
  end

  def show; end

  def new
    @incentive_batch = IncentiveBatch.new
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    @incentive_batch = IncentiveBatch.new(incentive_batch_params.merge(employee: current_employee))
    upload_file = params[:incentive_batch][:csv_data]

    if upload_file.blank?
      flash[:alert] = 'No upload file selected.'
      redirect_to new_incentive_batch_url
      return
    end

    if @incentive_batch.save
      data = get_csv_data(upload_file)
      @incentive_batch.update!(csv_data: data)
      redirect_to incentive_batches_url, notice: 'Successfully created incentive batch'
    else
      flash.now[:alert] = 'Unable to create incentive batch'
      render 'new'
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def edit; end

  def update
    if @incentive_batch.update(incentive_batch_params)
      redirect_to incentive_batches_url, notice: 'Successfully updated incentive batch'
    else
      flash.now[:alert] = 'Unable to update incentive batch'
      render 'edit'
    end
  end

  private

  def incentive_batch_params
    params.require(:incentive_batch).permit(:survey_name, :reward, csv_data: [])
  end

  def load_batch
    @incentive_batch = IncentiveBatch.find(params[:id])
  end

  def get_csv_data(file)
    csv_data = Hash.new { |h, k| h[k] = [] }

    CSV.foreach(file.path) do |row|
      next unless column_valid?(row.first)

      csv_data.merge!({ row[0] => [row[1], row[2]] })
    end
    csv_data.to_json
  end

  def column_valid?(column)
    column.present?
  end
end
