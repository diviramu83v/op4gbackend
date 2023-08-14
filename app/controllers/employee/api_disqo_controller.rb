# frozen_string_literal: true

class Employee::ApiDisqoController < Employee::SupplyBaseController
  skip_authorization_check

  def index
    @years = (2021..Time.zone.now.year).to_a
  end
end
