# frozen_string_literal: true

class CreateCountrySpecificPanels < ActiveRecord::Migration[5.1]
  def up
    ca_op4g = Panel.create(name: 'Op4G-CA', abbreviation: 'Op4G-CA', slug: 'op4g_ca', category: 'internal', status: Panel.statuses[:inactive])
    uk_op4g = Panel.create(name: 'Op4G-UK', abbreviation: 'Op4G-UK', slug: 'op4g_uk', category: 'internal', status: Panel.statuses[:inactive])
    de_op4g = Panel.create(name: 'Op4G-DE', abbreviation: 'Op4G-DE', slug: 'op4g_de', category: 'internal', status: Panel.statuses[:inactive])
    fr_op4g = Panel.create(name: 'Op4G-FR', abbreviation: 'Op4G-FR', slug: 'op4g_fr', category: 'internal', status: Panel.statuses[:inactive])
    es_op4g = Panel.create(name: 'Op4G-ES', abbreviation: 'Op4G-ES', slug: 'op4g_es', category: 'internal', status: Panel.statuses[:inactive])
    it_op4g = Panel.create(name: 'Op4G-IT', abbreviation: 'Op4G-IT', slug: 'op4g_it', category: 'internal', status: Panel.statuses[:inactive])
    au_op4g = Panel.create(name: 'Op4G-AU', abbreviation: 'Op4G-AU', slug: 'op4g_au', category: 'internal', status: Panel.statuses[:inactive])

    canada = Country.find_by(name: 'Canada')
    united_kingdom = Country.find_by(name: 'United Kingdom')
    germany = Country.find_by(name: 'Germany')
    france = Country.find_by(name: 'France')
    spain = Country.find_by(name: 'Spain')
    italy = Country.find_by(name: 'Italy')
    australia = Country.find_by(name: 'Australia')

    ca_op4g.panel_countries.create(country_id: canada.id)
    uk_op4g.panel_countries.create(country_id: united_kingdom.id)
    de_op4g.panel_countries.create(country_id: germany.id)
    fr_op4g.panel_countries.create(country_id: france.id)
    es_op4g.panel_countries.create(country_id: spain.id)
    it_op4g.panel_countries.create(country_id: italy.id)
    au_op4g.panel_countries.create(country_id: australia.id)

    [ca_op4g, uk_op4g, de_op4g, fr_op4g, es_op4g, it_op4g, au_op4g].each do |panel|
      panel.demo_questions_categories.create(name: 'General', slug: 'general', sort_order: 1)
      panel.demo_questions_categories.create(name: 'Professional', slug: 'professional', sort_order: 2)
      panel.demo_questions_categories.create(name: 'Home', slug: 'home', sort_order: 3)
      panel.demo_questions_categories.create(name: 'Health', slug: 'health', sort_order: 4)
    end
  end

  def down
    ['Op4G-CA', 'Op4G-UK', 'Op4G-DE', 'Op4G-FR', 'Op4G-ES', 'Op4G-IT', 'Op4G-AU'].each do |panel_name|
      panel = Panel.find_by(name: panel_name)
      PanelMembership.where(panel_id: panel.id).destroy_all
      panel.panel_countries.destroy_all
      panel.demo_questions_categories.destroy_all
      panel.delete
    end
  end
end
