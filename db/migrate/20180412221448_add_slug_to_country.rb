# frozen_string_literal: true

class AddSlugToCountry < ActiveRecord::Migration[5.1]
  def up
    add_column :countries, :slug, :string

    Country.find_by(name: 'United States').update_attributes(slug: 'us') if Country.find_by(name: 'United States').present?
    Country.find_by(name: 'Canada').update_attributes(slug: 'ca') if Country.find_by(name: 'Canada').present?
    Country.find_by(name: 'United Kingdom').update_attributes(slug: 'uk') if Country.find_by(name: 'United Kingdom').present?
    Country.find_by(name: 'Germany').update_attributes(slug: 'de') if Country.find_by(name: 'Germany').present?
    Country.find_by(name: 'France').update_attributes(slug: 'fr') if Country.find_by(name: 'France').present?
    Country.find_by(name: 'Spain').update_attributes(slug: 'es') if Country.find_by(name: 'Spain').present?
    Country.find_by(name: 'Italy').update_attributes(slug: 'it') if Country.find_by(name: 'Italy').present?
    Country.find_by(name: 'Australia').update_attributes(slug: 'au') if Country.find_by(name: 'Australia').present?

    change_column_null :countries, :slug, false
  end

  def down
    remove_column :countries, :slug
  end
end
