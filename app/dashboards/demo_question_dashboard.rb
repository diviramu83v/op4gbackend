# frozen_string_literal: true

require 'administrate/base_dashboard'

class DemoQuestionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    country: Field::BelongsTo,
    id: Field::Number,
    input_type: Field::Select.with_options(
      collection: %w[single multiple]
    ),
    demo_questions_category: Field::BelongsTo,
    sort_order: Field::Number,
    body: Field::String,
    label: Field::String,
    button_label: Field::String,
    demo_options: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :country,
    :demo_questions_category,
    :body,
    :label,
    :button_label,
    :demo_options,
    :input_type,
    :sort_order,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :country,
    :demo_questions_category,
    :body,
    :label,
    :button_label,
    :demo_options,
    :input_type,
    :sort_order,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :country,
    :demo_questions_category,
    :body,
    :label,
    :button_label,
    :demo_options,
    :input_type,
    :sort_order,
  ].freeze

  # Overwrite this method to customize how demo_questions are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(demo_question)
    text = demo_question.label
    text = "#{demo_question.country.name}: #{text}" unless demo_question.country.nil?
    "[#{demo_question.panel.name}] #{text}"
  end
end
