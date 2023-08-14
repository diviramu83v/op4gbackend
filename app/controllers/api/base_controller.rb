# frozen_string_literal: true

class Api::BaseController < ApplicationController
  skip_before_action :authenticate_employee!
end
