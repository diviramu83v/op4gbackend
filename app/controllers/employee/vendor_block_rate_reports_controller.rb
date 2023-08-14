# frozen_string_literal: true

class Employee::VendorBlockRateReportsController < Employee::OperationsBaseController
  authorize_resource class: 'Vendor'

  def show
    @vendor = Vendor.find(params[:vendor_id])
  end
end
