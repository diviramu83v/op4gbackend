# frozen_string_literal: true

require 'administrate/base_dashboard'

class DemoQueryDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    panel: Field::BelongsTo,
    country: Field::BelongsTo,
    demo_query_options: Field::HasMany,
    options: Field::HasMany,
    panelist_count: Field::Number,
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :panel,
    :country,
    :options,
    :panelist_count,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :panel,
    :panelist_count,
    :country,
    :options,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :panel,
    :country,
    :options,
  ].freeze

  # Overwrite this method to customize how demo queries are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(demo_query)
  #   "DemoQuery ##{demo_query.id}"
  # end
end
