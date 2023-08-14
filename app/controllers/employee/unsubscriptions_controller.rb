# frozen_string_literal: true

class Employee::UnsubscriptionsController < Employee::OperationsBaseController
  authorize_resource class: 'Survey'

  def show
    @unsubscriptions = Unsubscription.order(created_at: :desc)

    respond_to do |format|
      format.html
      format.csv do
        send_data @unsubscriptions.to_csv, filename: 'unsubscribed-list.csv'
      end
    end
  end
end
