# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_admin!
end
