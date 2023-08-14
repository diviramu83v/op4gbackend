# frozen_string_literal: true

class Employee::DecodingsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  def new
    @decoding = Decoding.new
  end

  def create
    @decoding = Decoding.new(decoding_params.merge(employee: current_employee))
    if @decoding.save
      redirect_to @decoding
    else
      flash.now[:alert] = 'Unable to decode UIDs.'
      render 'new'
    end
  end

  def show
    @decoding = Decoding.find(params[:id])
    return render :show unless @decoding.decoded?

    redirect_to default_tab_url
  end

  private

  def decoding_params
    params.require(:decoding).permit(:encoded_uids)
  end

  # rubocop:disable Metrics/MethodLength
  def default_tab_url
    if @decoding.errors?
      decoding_errors_url(@decoding)
    elsif @decoding.panel_traffic?
      if @decoding.multiple_panels?
        decoding_combined_url(@decoding)
      else
        decoding_panel_url(@decoding, @decoding.first_panel)
      end
    elsif @decoding.only_one_vendor?
      decoding_vendor_url(@decoding, @decoding.first_vendor)
    else
      decoding_matches_url(@decoding)
    end
  end
  # rubocop:enable Metrics/MethodLength
end
