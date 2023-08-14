# frozen_string_literal: true

class BackfillFailedPrescreenerData < ActiveRecord::Migration[5.2]
  def change
    PrescreenerQuestion.find_each(&:set_failed)
  end
end
