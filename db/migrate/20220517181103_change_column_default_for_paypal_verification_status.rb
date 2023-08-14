# frozen_string_literal: true

class ChangeColumnDefaultForPaypalVerificationStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default :panelists, :paypal_verification_status, from: 'not_verified', to: 'unverified'
  end
end
