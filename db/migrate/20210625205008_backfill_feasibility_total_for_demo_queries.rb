# frozen_string_literal: true

class BackfillFeasibilityTotalForDemoQueries < ActiveRecord::Migration[5.2]
  def change
    safety_assured do
      DemoQuery.feasibility.find_each do |demo|
        demo.update(feasibility_total: demo.panelist_count)
      end
    end
  end
end
