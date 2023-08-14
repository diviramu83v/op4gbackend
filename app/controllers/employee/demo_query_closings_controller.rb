# frozen_string_literal: true

class Employee::DemoQueryClosingsController < Employee::OperationsBaseController
  authorize_resource class: 'SampleBatch'

  def create
    @query = DemoQuery.find(params[:query_id])

    flash[:notice] = if @query.close_batches
                       'Successfully closed all open batches.'
                     else
                       'No batches to close.'
                     end

    redirect_to survey_queries_url(@query.survey)
  end
end
