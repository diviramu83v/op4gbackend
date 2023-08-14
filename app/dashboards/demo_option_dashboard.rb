# frozen_string_literal: true

require 'administrate/base_dashboard'

class DemoOptionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    demo_question: Field::BelongsTo,
    panelists: Field::HasMany,
    panelist_count: Field::Number,
    id: Field::Number,
    label: Field::String,
    sort_order: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :demo_question,
    :label,
    :panelist_count,
    :sort_order,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :demo_question,
    :label,
    :panelist_count,
    :panelists,
    :sort_order,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :demo_question,
    :label,
    :sort_order,
  ].freeze

  # Overwrite this method to customize how demo options are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(demo_option)
    "[#{demo_option.panel.name}] #{demo_option.button_label}"
  end
end
