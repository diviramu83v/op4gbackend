# frozen_string_literal: true

class MakeOnboardingInitialProjectStatusNotNull < ActiveRecord::Migration[5.1]
  def change
    Onboarding.where(initial_project_status: nil).delete_all

    change_column_null(:onboardings, :initial_project_status_id, false)
  end
end
