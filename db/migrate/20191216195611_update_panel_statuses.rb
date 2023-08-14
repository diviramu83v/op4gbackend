# frozen_string_literal: true

class UpdatePanelStatuses < ActiveRecord::Migration[5.1]
  def up
    panel = Panel.find_by(name: 'Op4G')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-CA')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-UK')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-DE')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-FR')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-ES')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-IT')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G-AU')
    panel.update!(status: 'active')

    panel = Panel.find_by(name: 'OPlus (old)')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G (old)')
    panel.update!(status: 'inactive')
  end

  def down
    panel = Panel.find_by(name: 'Op4G')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-CA')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-UK')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-DE')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-FR')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-ES')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-IT')
    panel.update!(status: 'inactive')
    panel = Panel.find_by(name: 'Op4G-AU')
    panel.update!(status: 'inactive')

    panel = Panel.find_by(name: 'OPlus (old)')
    panel.update!(status: 'active')
    panel = Panel.find_by(name: 'Op4G (old)')
    panel.update!(status: 'active')
  end
end
