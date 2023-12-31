# frozen_string_literal: true

require 'administrate/base_dashboard'

class DemoAnswerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    panelist: Field::BelongsTo.with_options(
      searchable: true,
      searchable_field: 'email'
    ),
    demo_option: Field::BelongsTo,
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
    :panelist,
    :demo_option,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :panelist,
    :demo_option,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :demo_option,
  ].freeze

  # Overwrite this method to customize how demo answers are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(demo_answer)
    "[#{demo_answer.option.panel.name}] #{demo_answer.option.button_label}"
  end
end
