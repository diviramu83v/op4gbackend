# frozen_string_literal: true

class Employee::EffectiveRolesController < Employee::OperationsBaseController
  authorize_resource class: false

  def create
    session[:effective_role] = params[:role]
    redirect_url = URI.parse(params[:redirect_url]).path

    redirect_to redirect_url
  end
end
