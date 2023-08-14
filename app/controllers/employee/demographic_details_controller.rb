# frozen_string_literal: true

class Employee::DemographicDetailsController < Employee::OperationsBaseController
  authorize_resource

  def show
    @demographic_detail = DemographicDetail.find(params[:id])

    respond_to do |format|
      format.html
      format.csv do
        filename = "demographic-details-#{@demographic_detail.id}.csv"

        send_data @demographic_detail.to_csv, filename: filename
      end
    end
  end

  def new
    @demographic_detail = DemographicDetail.new
  end

  def create
    @demographic_detail = DemographicDetail.new(demographic_detail_params)

    if @demographic_detail.save
      redirect_to @demographic_detail
    else
      render 'new'
    end
  end

  private

  def demographic_detail_params
    params.require(:demographic_detail).permit(:upload_data)
  end
end
