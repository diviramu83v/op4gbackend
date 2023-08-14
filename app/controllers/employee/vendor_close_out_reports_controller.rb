# frozen_string_literal: true

class Employee::VendorCloseOutReportsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'

  def index
    @project = Project.find(params[:project_id])
    @vendor_batches = @project.vendor_batches.preload(:vendor, onramp:
      [:complete_onboardings, :complete_accepted_onboardings, :complete_fraudulent_onboardings, :complete_rejected_onboardings,
       :accepted_onboardings, :fraudulent_onboardings, :rejected_onboardings, :complete_recorded_onboardings, :onboardings])
  end
end
