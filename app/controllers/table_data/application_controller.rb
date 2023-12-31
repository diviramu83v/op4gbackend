# frozen_string_literal: true

# All Administrate controllers inherit from this `TableData::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
class TableData::ApplicationController < Administrate::ApplicationController
  before_action :authenticate_admin!

  # Override this value to specify the number of elements to display at a time
  # on index pages. Defaults to 20.
  def records_per_page
    params[:per_page] || 50
  end

  private

  def authenticate_admin!
    redirect_to not_found_url unless current_employee&.effective_role_admin?(@effective_role)
  end
end
