# frozen_string_literal: true

require 'administrate/base_dashboard'

class SurveyResponsePatternDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    responses: Field::HasMany.with_options(class_name: 'SurveyResponseUrl'),
    surveys: Field::HasMany,
    id: Field::Number,
    slug: Field::String,
    name: Field::String,
    sort: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :slug,
    :name,
    :sort,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :slug,
    :name,
    :sort,
    :surveys,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :responses,
    :surveys,
    :slug,
    :name,
    :sort,
  ].freeze

  # Overwrite this method to customize how survey response patterns are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(survey_response_pattern)
    survey_response_pattern.name
  end
end
