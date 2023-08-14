# frozen_string_literal: true

class ChangeDefaultColorForExpertRecruitBatches < ActiveRecord::Migration[6.1]
  def change
    change_column_default :expert_recruit_batches, :color, from: '#000000', to: '#163755'
  end
end
