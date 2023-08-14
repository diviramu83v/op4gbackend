# frozen_string_literal: true

class Employee::DemoQueryTrafficController < Employee::OperationsBaseController
  include RenderDemoQuery

  authorize_resource class: 'DemoQuery'

  def show
    @query = DemoQuery.find(params[:query_id])
    @count = @query.panelist_count
  end
end
