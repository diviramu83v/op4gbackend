# frozen_string_literal: true

module TableData
  class EmployeesController < TableData::ApplicationController
    def update
      params[:employee].delete('password') if params[:employee][:password] == ''
      super
    end
  end
end
