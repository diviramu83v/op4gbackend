# frozen_string_literal: true

class SorceryResetPassword < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :reset_password_token, :string, default: nil
    add_column :customers, :reset_password_token_expires_at, :datetime, default: nil
    add_column :customers, :reset_password_email_sent_at, :datetime, default: nil
    add_column :customers, :access_count_to_reset_password_page, :integer, default: 0

    add_index :customers, :reset_password_token
  end
end
