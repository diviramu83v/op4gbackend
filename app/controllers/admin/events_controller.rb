# frozen_string_literal: true

class Admin::EventsController < Admin::BaseController
  def index
    @events = SystemEvent.order('happened_at DESC')
  end
end
