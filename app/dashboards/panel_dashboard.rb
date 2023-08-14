# frozen_string_literal: true

require 'administrate/base_dashboard'

class PanelDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    abbreviation: Field::String,
    slug: Field::String,
    countries: Field::HasMany,
    landing_page_title: Field::String,
    landing_page_content: Field::Text,
    panelist_count: Field::Number,
    incentive_cents: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    demo_question_categories: Field::HasMany,
    demo_questions: Field::HasMany
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :abbreviation,
    :slug,
    :countries,
    :panelist_count,
    :incentive_cents,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :abbreviation,
    :slug,
    :countries,
    :landing_page_title,
    :landing_page_content,
    :panelist_count,
    :incentive_cents,
    :demo_questions,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :abbreviation,
    :slug,
    :countries,
    :landing_page_title,
    :landing_page_content,
    :incentive_cents
  ].freeze

  # Overwrite this method to customize how panels are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(panel)
    panel.name
  end
end
