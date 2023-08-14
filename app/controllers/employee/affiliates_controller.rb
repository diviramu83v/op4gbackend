# frozen_string_literal: true

# This is the controller for the Affilate model
class Employee::AffiliatesController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def index
    @affiliates = Affiliate.all
  end

  def show
    @affiliate = Affiliate.find(params[:id])
  end
end
