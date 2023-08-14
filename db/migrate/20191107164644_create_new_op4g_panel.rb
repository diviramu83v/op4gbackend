# frozen_string_literal: true

class CreateNewOp4gPanel < ActiveRecord::Migration[5.1]
  def up
    old_op4g = Panel.find(1)
    new_op4g = Panel.create(name: 'New_Op4G', abbreviation: 'new_Op4G', slug: 'new_op4g', category: 'internal', status: Panel.statuses[:inactive])
    old_op4g.panel_countries.find_each do |country|
      new_op4g.panel_countries.create(country_id: country.id)
    end

    new_op4g.demo_questions_categories.create(name: 'General', slug: 'general', sort_order: 1)
    new_op4g.demo_questions_categories.create(name: 'Professional', slug: 'professional', sort_order: 2)
    new_op4g.demo_questions_categories.create(name: 'Home', slug: 'home', sort_order: 3)
    new_op4g.demo_questions_categories.create(name: 'Health', slug: 'health', sort_order: 4)
  end

  def down
    Panel.find_by(name: 'New_Op4G').panel_countries.destroy_all
    Panel.find_by(name: 'New_Op4G').demo_questions_categories.destroy_all
    Panel.find_by(name: 'New_Op4G').delete
  end
end
