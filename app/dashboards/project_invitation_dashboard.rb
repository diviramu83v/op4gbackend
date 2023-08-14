# frozen_string_literal: true

require 'administrate/base_dashboard'

class ProjectInvitationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    project: Field::BelongsTo,
    panelist: Field::BelongsTo,
    batch: Field::BelongsTo.with_options(class_name: 'SampleBatch'),
    survey: Field::BelongsTo,
    id: Field::Number,
    sample_batch_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :project,
    :panelist,
    :batch,
    :survey,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :project,
    :panelist,
    :batch,
    :survey,
    :id,
    :sample_batch_id,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :project,
    :panelist,
    :batch,
    :survey,
    :sample_batch_id,
  ].freeze

  # Overwrite this method to customize how project invitations are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(project_invitation)
  #   "ProjectInvitation ##{project_invitation.id}"
  # end
end
