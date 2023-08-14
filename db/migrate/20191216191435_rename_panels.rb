# frozen_string_literal: true

class RenamePanels < ActiveRecord::Migration[5.1]
  def up
    panel = Panel.find_by(name: 'Op4G')
    panel.update!(name: 'Op4G (old)', abbreviation: 'Op4G (old)', slug: 'op4g-old')

    panel = Panel.find_by(name: 'OPlus')
    panel.update!(name: 'OPlus (old)', abbreviation: 'OPlus (old)', slug: 'oplus-old')

    panel = Panel.find_by(name: 'New_Op4G')
    panel.update!(name: 'Op4G', abbreviation: 'Op4G', slug: 'op4g-us')
  end

  def down
    panel = Panel.find_by(name: 'Op4G')
    panel.update!(name: 'New_Op4G', abbreviation: 'New_Op4G', slug: 'new_op4g')

    panel = Panel.find_by(name: 'OPlus (old)')
    panel.update!(name: 'OPlus', abbreviation: 'OPlus', slug: 'oplus')

    panel = Panel.find_by(name: 'Op4G (old)')
    panel.update!(name: 'Op4G', abbreviation: 'Op4G', slug: 'op4g')
  end
end
