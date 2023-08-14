# frozen_string_literal: true

class CreateALockedPanel < ActiveRecord::Migration[5.2]
  def change
    Panel.create(
      name: 'Expert panel',
      abbreviation: 'Expert',
      slug: 'expert-panel',
      status: 'active',
      category: 'locked'
    )
  end
end
