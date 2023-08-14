# frozen_string_literal: true

class Employee::TrackingPixelsController < Employee::RecruitmentBaseController
  authorize_resource class: 'TrackingPixel'

  def index
    @pixels = TrackingPixel.newest_first
  end

  def new
    @pixel = TrackingPixel.new
  end

  def create
    @pixel = TrackingPixel.new(tracking_pixel_params)

    if @pixel.save
      redirect_to pixels_path, notice: 'Pixel added successfully'
    else
      render 'new'
    end
  end

  def edit
    @pixel = TrackingPixel.find(params[:id])
  end

  def update
    @pixel = TrackingPixel.find(params[:id])

    if @pixel.update(tracking_pixel_params)
      redirect_to pixels_path, notice: 'Pixel updated successfully'
    else
      render 'edit'
    end
  end

  def destroy
    result = TrackingPixel.destroy(params[:id])

    notice = 'Error deleting pixel'
    notice = 'Pixel removed successfully' if result.destroyed?

    redirect_to pixels_path, notice: notice
  end

  private

  def tracking_pixel_params
    params.require(:tracking_pixel).permit(:url, :category, :description)
  end
end
