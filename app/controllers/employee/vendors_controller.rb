# frozen_string_literal: true

class Employee::VendorsController < Employee::OperationsBaseController
  authorize_resource

  def index
    @vendors = Vendor.active.by_name
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to vendors_url
    else
      render :new
    end
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def edit
    @vendor = Vendor.find(params[:id])
  end

  def update
    @vendor = Vendor.find(params[:id])

    if @vendor.update(vendor_params)
      redirect_to vendors_url, notice: 'Successfully updated vendor.'
    else
      render :edit
    end
  end

  private

  def vendor_params
    if current_employee.admin_or_ops_manager?(@effective_role)
      standard_params.merge(secured_params)
    else
      standard_params
    end
  end

  def standard_params
    params.require(:vendor).permit(:name, :abbreviation, :complete_url,
                                   :terminate_url, :overquota_url,
                                   :security_url, :contact_info,
                                   :collect_followup_data, :follow_up_wording)
  end

  def secured_params
    params.require(:vendor).permit(:uid_parameter,
                                   :security_disabled_by_default,
                                   :gate_survey_on_by_default,
                                   :include_hashing_param_in_hash_data,
                                   :disable_redirects, :hash_key,
                                   :send_complete_webhook, :complete_webhook_url,
                                   :send_secondary_webhook, :secondary_webhook_url,
                                   :webhook_method, :hashing_param)
  end
end
