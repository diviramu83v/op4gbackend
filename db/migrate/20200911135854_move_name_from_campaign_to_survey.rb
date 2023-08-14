# frozen_string_literal: true

class MoveNameFromCampaignToSurvey < ActiveRecord::Migration[5.2]
  def up
    return unless table_exists?(:surveys)
    return unless table_exists?(:campaigns)
    return unless column_exists?(:surveys, :name)
    return unless column_exists?(:campaigns, :name)

    # rubocop:disable Rails/SkipsModelValidations
    Survey.where(name: nil).find_each do |survey|
      survey.update_attribute(:name, survey.campaign.name)
    end
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    # no goin back
  end
end
