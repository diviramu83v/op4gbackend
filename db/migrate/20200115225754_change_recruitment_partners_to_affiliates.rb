# frozen_string_literal: true

class ChangeRecruitmentPartnersToAffiliates < ActiveRecord::Migration[5.1]
  def change
    rename_table :recruitment_partners, :affiliates
  end
end
