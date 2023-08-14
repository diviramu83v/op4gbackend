# frozen_string_literal: true

require 'administrate/base_dashboard'

class SampleBatchDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    project: Field::BelongsTo,
    invitations: Field::HasMany.with_options(class_name: 'ProjectInvitation'),
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    count: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :project,
    :invitations,
    :created_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :project,
    :count,
    :invitations,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :project,
    :invitations,
    :count,
  ].freeze

  # Overwrite this method to customize how sample batches are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(sample_batch)
    "[#{sample_batch.project.name}][#{sample_batch.count} invitations]"
  end
end
