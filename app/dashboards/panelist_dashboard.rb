# frozen_string_literal: true

require 'administrate/base_dashboard'

class PanelistDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    panels: Field::HasMany,
    demo_answers: Field::HasMany,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    email: Field::String,
    first_name: Field::String,
    last_name: Field::String,
    # name: Field::String,
    birthdate: Field::DateTime,
    country: Field::BelongsTo,
    postal_code: Field::String,
    zip_code: Field::BelongsTo,
    legacy_earnings: Field::Number,
    address: Field::String,
    city: Field::String,
    state: Field::String,
    # msa: Field::HasOne,
    # pmsa: Field::HasOne,
    # dma: Field::HasOne,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :panels,
    # :name,
    :email,
    :country,
    :postal_code,
    :zip_code,
    # :state,
    # :msa,
    # :pmsa,
    # :dma,
    :legacy_earnings,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :email,
    :first_name,
    :last_name,
    :birthdate,
    :postal_code,
    :zip_code,
    :legacy_earnings,
    # :state,
    # :msa,
    # :pmsa,
    # :dma,
    :panels,
    :demo_answers,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :first_name,
    :last_name,
    :email,
    :birthdate,
    :postal_code,
    :zip_code,
    :legacy_earnings,
    :address,
    :city,
    :state,
    # :msa,
    # :pmsa,
    # :dma,
    :panels,
    # :demo_answers,
  ].freeze

  # Overwrite this method to customize how panelists are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(panelist)
    "#{panelist.name} <#{panelist.email}>"
  end
end
